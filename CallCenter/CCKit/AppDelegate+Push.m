//
//  AppDelegate+Push.m
//  Haier
//
//  Created by aiquantong on 20/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "AppDelegate+Push.h"
#import "SessionMangementModule.h"


@implementation AppDelegate(Push)

@dynamic pushRegistry;
@dynamic notificationsList;


static char Object_PushRegistry;

- (id)pushRegistry {
    id object = objc_getAssociatedObject(self, &Object_PushRegistry);
    return object;
}

- (void)setPushRegistry:(PKPushRegistry *)pushRegistry
{
    [self willChangeValueForKey:@"pushRegistry"];
    objc_setAssociatedObject(self, &Object_PushRegistry, pushRegistry, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pushRegistry"];
}


static char Object_NotificationsList;

- (id)notificationsList {
    id object = objc_getAssociatedObject(self, &Object_NotificationsList);
    return object;
}

- (void)setNotificationsList:(NSMutableArray *)notificationsList
{
    [self willChangeValueForKey:@"notificationsList"];
    objc_setAssociatedObject(self, &Object_NotificationsList, notificationsList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"notificationsList"];
}


-(void)startNotification:(NSDictionary *)launchOptions
{
    if (self.notificationsList == nil) {
        self.notificationsList = [NSMutableArray new];
    }
    [self removeLocalNotificaion];
    
    if (launchOptions && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil)
    {
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self.notificationsList addObject:remoteNotification];
    }
    KDALog(@"notificationsList == %@ launchOptions == %@", [self.notificationsList description], launchOptions);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self initPushNotificationCategory];
    
    if (objc_getClass("PKPushRegistry") != nil) {
        [self startVoIPPush];
    }else{
        [self startStandardPush];
    }
}


#pragma mark - tradition_Notifications

-(void)startStandardPush
{
    NSLog(@"startStandardPush");
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //Register UserNotificationSettings
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil]];
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
#pragma GCC diagnostic pop
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //不支持voip 推送的时候 调用标准推送模式
    if (objc_getClass("PKPushRegistry") == nil) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:@"deviceToken"];
    NSLog(@"deviceToken === %@", deviceToken);
}

//传统推送方式 已经不在支持
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self.notificationsList addObject:userInfo];
    //[self handleRemoteNotifications];
}

#pragma mark - voip_Notifications

-(void)startVoIPPush
{
    NSLog(@"startVoIPPush");
    self.pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    self.pushRegistry.delegate = self;
    self.pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}


#pragma mark - push
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    [[NSUserDefaults standardUserDefaults]setObject:credentials.token forKey:@"voipToken"];
    NSLog(@"credentials.type == %@ credentials.token === %@", credentials.type, credentials.token);
}


- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    KDALog(@"didReceiveIncomingPushWithPayload  payload === %@  type == %@ ", [payload.dictionaryPayload description], type);
    if (type && [type isEqualToString:PKPushTypeVoIP]) {
        [self createLocalNotificaion:payload.dictionaryPayload];
        
        if (self.notificationsList == nil) {
            self.notificationsList = [NSMutableArray new];
        }
        
        [self.notificationsList addObject:[payload.dictionaryPayload copy]];
        UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
        if (applicationState == UIApplicationStateActive) {
            [self doRemoteNotifications];
        }
    }
}


- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type;
{
    NSLog(@"didInvalidatePushTokenForType type == %@", type);
    [AccessModule disableKandyPushNotification];
}


-(void)initPushNotificationCategory
{
    //为了开启localnotification 也是需要设置 本地推送模式
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
}


//匹配不同的来源信息的推送
-(BOOL)createLocalNotificaion:(NSDictionary *)dic
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval =  kCFCalendarUnitEra;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    NSString *messageType = [dic objectForKey:@"messageType"];
    
    NSDictionary *aps = [dic objectForKey:@"aps"];
    if(aps){
        NSInteger badge = [[aps objectForKey:@"badge"] integerValue];
        notification.applicationIconBadgeNumber = badge;
        //notification.soundName = [[aps objectForKey:@"sound"] stringValue];
    }
    
    if (messageType && [messageType isEqualToString:@"incomingCall"]) {
        NSString *alertBodyStr = @"你有一个来电：";
        NSDictionary *senderDic = [dic objectForKey:@"sender"];
        if (senderDic) {
            NSString *userId = [senderDic objectForKey:@"user_id"];
            if (userId) {
                alertBodyStr = [NSString stringWithFormat:@"%@ %@", alertBodyStr, userId];
            }
        }else{
            NSString *userId = [dic objectForKey:@"source"];
            if (userId) {
                alertBodyStr = [NSString stringWithFormat:@"%@ %@", alertBodyStr, userId];
            }
        }
        
        notification.alertBody = alertBodyStr;
        notification.category = @"comingCall";
        notification.userInfo = dic;
        
        if (applicationState != UIApplicationStateActive) {
            [TonePlayer startTonePlayerWithOneTime];
        }
    }else if(messageType && [messageType isEqualToString:@"chat"]){
        
        //暂时仅仅判断chat 消息
        NSString *destination = [dic objectForKey:@"destination"];
        if (destination && [destination isKindOfClass:[NSString class]]) {
            NSString *ksuserId = [SessionMangementModule getSavedSessionData].currentUser.userId;
            KDALog(@"destination === %@  ksuserId === %@ ", destination, ksuserId);
            if (!destination || !ksuserId || ![ksuserId isEqualToString:destination]) {
                return NO;
            }
        }else{
            return NO;
        }
        
        notification.alertBody = [aps objectForKey:@"alert"];
        notification.soundName = [aps objectForKey:@"sound"];
        notification.userInfo = dic;
    }else if(messageType && [messageType isEqualToString:@"goFetch"]){
        notification.alertBody = @"你有一个会议邀请";
        notification.soundName = [aps objectForKey:@"sound"];
        notification.userInfo = dic;
    }else if (messageType && [messageType isEqualToString:@"groupChat"]){
        notification.alertBody = [aps objectForKey:@"你有一个群组消息"];
        notification.soundName = [aps objectForKey:@"sound"];
        notification.userInfo = dic;
    }else if(messageType && [messageType isEqualToString:@"private"]){
        notification.alertBody = [NSString stringWithFormat:@"私有消息:%@",[dic description]];
        return YES;
    }
    else{
        notification.alertBody = [NSString stringWithFormat:@"未知消息:%@",[dic description]];
    }
    
    if (applicationState != UIApplicationStateActive) {
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
    return YES;
}


-(void)removeLocalNotificaion
{
    NSArray *localArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotificaion in localArr) {
        NSDictionary *userInfo = localNotificaion.userInfo;
        KDALog(@"userInfo == %@", userInfo);
        
        [[UIApplication sharedApplication] cancelLocalNotification:localNotificaion];
    }
}


//成功登录kandy 调用此函数 对推送消息进行处理
//kandy sdk 将不同的事件分发到对应的处理模块，调用响应的代理函数
-(void)doRemoteNotifications
{
    for(NSDictionary *remoteNotification in self.notificationsList)
    {
        KDALog(@"222 remoteNotification === %@", remoteNotification);
        id<KandyEventProtocol> event = [[Kandy sharedInstance].services.push getRemoteNotificationEvent:remoteNotification];
        KDALog(@"222 remoteNotification event === %@", [event description]);
        //      [self _handleEventUI:event]; // event is nil if not handled by Kandy
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Kandy sharedInstance].services.push handleRemoteNotification:remoteNotification responseCallback:^(NSError *error) {
                
                KDALog(@"333 remoteNotification remoteNotification == %@  error === %@", [remoteNotification description], [error description]);
                if(error && [error.domain isEqualToString:KandyNotificationServiceErrorDomain] &&
                   error.code == EKandyNotificationServiceError_pushFormatNotSupported)
                {
                    //Push format not supported by Kandy, handle the notification by my self
                }else{
                    [self.notificationsList removeObject:remoteNotification];
                }
            }];
        });
    }
    
}

+(void)showCallPushNotification:(id<KandyCallProtocol>)call;
{
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if (applicationState == UIApplicationStateBackground) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval =  kCFCalendarUnitEra;
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        NSString *alertBodyStr = @"你有一个来电";
        alertBodyStr = [NSString stringWithFormat:@"%@:%@", alertBodyStr, call.remoteRecord.uri];
        notification.alertBody = alertBodyStr;
        notification.category = @"comingCall";
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

@end
