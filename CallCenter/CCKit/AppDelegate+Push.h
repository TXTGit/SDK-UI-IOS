//
//  AppDelegate+Push.h
//  Haier
//
//  Created by aiquantong on 20/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#import <objc/runtime.h>
#import <PushKit/PushKit.h>
#import "AccessModule.h"
#import "TonePlayer.h"


@interface AppDelegate(Push)<PKPushRegistryDelegate>

@property (atomic, strong) PKPushRegistry *pushRegistry;;
@property (atomic, strong) NSMutableArray *notificationsList;


-(void)startNotification:(NSDictionary *)launchOptions;

//SDKDemo 默认的行为是在kandy login成功后调用 用来处理notification的行为

-(void)doRemoteNotifications;

@end


