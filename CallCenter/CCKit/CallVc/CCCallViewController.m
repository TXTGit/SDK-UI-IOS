//
//  CCCallViewController.m
//  CallCenter
//
//  Created by aiquantong on 8/2/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCCallViewController.h"
#import "../KandySDK/CallModule.h"
#import "CCKitManger.h"

#define smallView_Width  150
#define smallView_Height 150

@interface CCCallViewController ()<CallModuleDelagate, UIGestureRecognizerDelegate>
{
    UIWindow *showWindow;
    NSDate *startDate;
    NSTimer *timer;
}

@property (nonatomic, strong) IBOutlet UIImageView *callTypeImageView;
@property (nonatomic, strong) IBOutlet UILabel *callTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel *callStateLabel;
@property (nonatomic, strong) IBOutlet UILabel *callSourceLabel;
@property(nonatomic, strong) IBOutlet UIView *localView;

@property(nonatomic, strong) IBOutlet UIView *receiveCallActionView;
@property(nonatomic, strong) IBOutlet UIButton *recceptButton;
@property(nonatomic, strong) IBOutlet UIButton *hlodButton;
@property(nonatomic, strong) IBOutlet UIButton *refuseButton;

@property(nonatomic, strong) IBOutlet UIView *sendCallActionView;

@property(nonatomic, strong) IBOutlet UIView *callAudioView;
@property (nonatomic, strong) IBOutlet UIImageView *callAudioImageView;
@property (nonatomic, strong) IBOutlet UILabel *callAudioCallSourceLabel;
@property(nonatomic, strong) IBOutlet UILabel *callAudioTimeLabel;
@property(nonatomic, strong) IBOutlet UIView *callAudioControlView;
@property(nonatomic, strong) IBOutlet UIButton *callAudioSwitchMuteButton;
@property(nonatomic, strong) IBOutlet UIButton *callAudioSwitchSpeakerButton;


@property(nonatomic, strong) IBOutlet UIView *callView;
@property(nonatomic, strong) IBOutlet UIView *callRemoteView;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *callRemoteTop;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *callRemoteRight;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *callRemoteWidth;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *callRemoteHeight;

@property(nonatomic, strong) IBOutlet UIView *callLocalView;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *callLocalTop;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *calllLocalRight;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *calllLocalWidth;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *calllLocalHeight;

@property (nonatomic, strong) IBOutlet UILabel *callVideoCallSourceLabel;
@property(nonatomic, strong) IBOutlet UILabel *callVideoTimeLabel;
@property(nonatomic, strong) IBOutlet UIView *callVideoControlView;
@property(nonatomic, strong) IBOutlet UIButton *switchFBCameraButton;
@property(nonatomic, strong) IBOutlet UIButton *switchMuteButton;
@property(nonatomic, strong) IBOutlet UIButton *switchCameraButton;
@property(nonatomic, strong) IBOutlet UIButton *switchSpeakerButton;

@end


@implementation CCCallViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    id<KandyCallProtocol> currentCall = [[CallModule shareInstance] getCurrentCall];

    BOOL isVideo = [[CallModule shareInstance] checkCurrentCallIsVideo];

    
    if (currentCall.callType == EKandyCallType_voip) {
        if (isVideo) {
            self.callTypeImageView.image = [UIImage imageNamed:@"voice_red@2x.png"];
        }else{
            self.callTypeImageView.image = [UIImage imageNamed:@"voice_blue@2x.png"];
        }
    }else{
        self.callTypeImageView.image = [UIImage imageNamed:@"voice_gray@2x.png"];
    }
    
    self.callSourceLabel.text = currentCall.remoteRecord.uri;
    
    if (currentCall.callType == EKandyCallType_voip) {
        if (isVideo) {
            self.callTypeLabel.text = @"视频电话";
        }else{
            self.callTypeLabel.text = @"IP电话";
        }
    }else{
        self.callTypeLabel.text = @"未知";
    }
    
    [CallModule shareInstance].delegate = self;
    if (currentCall.isIncomingCall) {
        self.callStateLabel.text = @"响铃中";
        [self.receiveCallActionView setHidden:NO];
        [self.sendCallActionView setHidden:YES];
        
    }else{
        self.callStateLabel.text = @"正在接通中";
        [self.receiveCallActionView setHidden:YES];
        [self.sendCallActionView setHidden:NO];
        
        __weak typeof(self) weekself = self;
        [[CallModule shareInstance] establishCallWithResponseBlock:^(NSError *error) {
            KDALog(@"establishCallWithResponseBlock error == %@", [error description]);
            typeof(self) blockself = weekself;
            if (blockself) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        blockself.callStateLabel.text = @"等待对方接听";
                    }else{
                        [blockself onclickHangup:nil];
                    }
                });
            }
        }];
    }

    UITapGestureRecognizer *callLocalGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchVideoView:)];
    [self.callLocalView addGestureRecognizer:callLocalGestrue];
    
    UITapGestureRecognizer *callRemoteGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchVideoView:)];
    [self.callRemoteView addGestureRecognizer:callRemoteGestrue];
    
    if ([[CallModule shareInstance] checkCurrentCallIsVideo]) {
        [[CallModule shareInstance] getCurrentCall].localVideoView = self.localView;
    }
    
}


-(void)initCallAudioButtonImage
{
    if ([[CallModule shareInstance] getCurrentCall].isMute) {
        [self.callAudioSwitchMuteButton setImage:[UIImage imageNamed:@"mic_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.callAudioSwitchMuteButton setImage:[UIImage imageNamed:@"mic_close@2x.png"] forState:UIControlStateNormal];
    }
    
    if ([[CallModule shareInstance] getCurrentCall].audioRoute == EKandyCallAudioRoute_speaker) {
        [self.callAudioSwitchSpeakerButton setImage:[UIImage imageNamed:@"speacker_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.callAudioSwitchSpeakerButton setImage:[UIImage imageNamed:@"speacker_close@2x.png"] forState:UIControlStateNormal];
    }
    
    id<KandyCallProtocol> currentCall = [[CallModule shareInstance] getCurrentCall];
    
    BOOL isVideo = [[CallModule shareInstance] checkCurrentCallIsVideo];
    
    if (currentCall.callType == EKandyCallType_voip) {
        if (isVideo) {
            self.callAudioImageView.image = [UIImage imageNamed:@"voice_red@2x.png"];
        }else{
            self.callAudioImageView.image = [UIImage imageNamed:@"voice_blue@2x.png"];
        }
    }else{
        self.callAudioImageView.image = [UIImage imageNamed:@"voice_gray@2x.png"];
    }
    self.callAudioCallSourceLabel.text = currentCall.remoteRecord.uri;
}


-(void)initVideoCallButtonImage
{
    if ([[CallModule shareInstance] getCurrentCall].isMute) {
        [self.switchMuteButton setImage:[UIImage imageNamed:@"mic_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.switchMuteButton setImage:[UIImage imageNamed:@"mic_close@2x.png"] forState:UIControlStateNormal];
    }
    
    if ([[CallModule shareInstance] getCurrentCall].audioRoute == EKandyCallAudioRoute_speaker) {
        [self.switchSpeakerButton setImage:[UIImage imageNamed:@"speacker_close@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.switchSpeakerButton setImage:[UIImage imageNamed:@"speacker_open@2x.png"] forState:UIControlStateNormal];
    }
    
    if ([[CallModule shareInstance] getCurrentCall].isSendingVideo) {
        [self.switchCameraButton setImage:[UIImage imageNamed:@"camera_close@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.switchCameraButton setImage:[UIImage imageNamed:@"camera_open@2x.png"] forState:UIControlStateNormal];
    }
    self.callVideoCallSourceLabel.text = [[CallModule shareInstance] getCurrentCall].remoteRecord.uri;
}


static BOOL isHiddenInWindow = YES;

/**
 显示call view 在window中
 */
-(void)showInWindow
{
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.05 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       CGRect screenRect = [UIScreen mainScreen].bounds;
                       CGRect startFrame = CGRectMake(0,
                                                      -screenRect.size.height,
                                                      screenRect.size.width,
                                                      screenRect.size.height);
                       
                       CGRect endFrame = CGRectMake(0,
                                                    0,
                                                    screenRect.size.width,
                                                    screenRect.size.height);
                       
                       showWindow = [[UIWindow alloc] initWithFrame:startFrame];
                       showWindow.windowLevel = UIWindowLevelAlert;
                       showWindow.rootViewController = self;
                       [showWindow makeKeyAndVisible];
                       
                       [UIView
                        animateWithDuration:0.3
                        animations:^{
                            showWindow.frame = endFrame;
                        }
                        completion:^(BOOL finished) {
                            isHiddenInWindow = NO;
                        }];
                   });
}


/**
 隐藏call view 在window中
 */
-(void)hiddenInWindow;
{
    if (isHiddenInWindow == NO) {
        isHiddenInWindow = YES;
    }else{
        return;
    }
    
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    
    //CGRect startFrame = showWindow.frame;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    CGRect endFrame = CGRectMake(0,
                                 -screenRect.size.height,
                                 screenRect.size.width,
                                 screenRect.size.height);
    
    [UIView animateWithDuration:0.1
                     animations:^{
                        showWindow.frame = endFrame;
                     }
                     completion:^(BOOL finished) {
                         [showWindow setHidden:YES];
                     }];
}


-(void)dealloc
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


-(IBAction)onclickMIN:(id)sender
{
    CGRect startFrame = showWindow.frame;
    
    CGRect endFrame = CGRectMake(20,
                                 20,
                                 startFrame.size.width * 0.2,
                                 startFrame.size.height * 0.2);
    showWindow.frame = endFrame;
    self.view.frame = endFrame;
    self.callView.frame = endFrame;
    self.callAudioView.frame = endFrame;
//    [showWindow setNeedsDisplay];
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         showWindow.frame = endFrame;
//                     }
//                     completion:^(BOOL finished) {
//                         [showWindow setNeedsDisplay];
//                     }];
}



/**
 计时器
 */
-(void)startTimer
{
    startDate = [NSDate date];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCallback:) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)stopTimer
{
    if (timer) {
        [timer invalidate];
    }
    timer = nil;
}

-(void)timeCallback:(id)sender
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startDate];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval zoneinterval = [zone secondsFromGMTForDate:date];
    
    date = [date dateByAddingTimeInterval:-zoneinterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timeIntervalStr = [formatter stringFromDate:date];
    
    self.callAudioTimeLabel.text = timeIntervalStr;
    self.callVideoTimeLabel.text = timeIntervalStr;
}


-(void)setBigView:(UIView *)view
{
    if (view == self.callRemoteView) {
        self.callRemoteTop.constant = 0;
        self.callRemoteRight.constant = 0;
        self.callRemoteWidth.constant = self.view.bounds.size.width;
        self.callRemoteHeight.constant = self.view.bounds.size.height;
    }else if(view == self.callLocalView){
        self.callLocalTop.constant = 0;
        self.calllLocalRight.constant = 0;
        self.calllLocalWidth.constant = self.view.bounds.size.width;
        self.calllLocalHeight.constant = self.view.bounds.size.height;
    }else{
    
    }
    [self.callView sendSubviewToBack:view];
}


-(void)setSmallView:(UIView *)view
{
    if (view == self.callRemoteView) {
        self.callRemoteTop.constant = 23;
        self.callRemoteRight.constant = 0;
        self.callRemoteWidth.constant = smallView_Width;
        self.callRemoteHeight.constant = smallView_Height;
    }else if(view == self.callLocalView){
        self.callLocalTop.constant = 23;
        self.calllLocalRight.constant = 0;
        self.calllLocalWidth.constant = smallView_Width;
        self.calllLocalHeight.constant = smallView_Height;
    }else{
        
    }
    [self.callView bringSubviewToFront:view];
}



/**
 call view状态调用的函数

 @param isReceiveVideo 是否接受远程试图
 @param isSendVideo 是否发送本地试图
 */
-(void)callModuleVideoStateChanged:(BOOL)isReceiveVideo isSendVideo:(BOOL)isSendVideo;
{
    if (isReceiveVideo && isSendVideo) {
        [self setBigView:self.callRemoteView];
        [self.callRemoteView setHidden:NO];
        [self setSmallView:self.callLocalView];
        [self.callLocalView setHidden:NO];

    }else if(isReceiveVideo){
        [self.callRemoteView setHidden:NO];
        [self setBigView:self.callRemoteView];
        [self.callLocalView setHidden:YES];
    }else if(isSendVideo){
        [self.callRemoteView setHidden:YES];
        [self setBigView:self.callLocalView];
        [self.callLocalView setHidden:NO];
    }else{
        
    }
}



/**
 大小屏幕切换的函数

 @param sender xib
 */
-(IBAction)touchVideoView:(id)sender
{
    if ([[CallModule shareInstance] getCurrentCall].isReceivingVideo &&
        [[CallModule shareInstance] getCurrentCall].isSendingVideo &&
        [sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UIView *view = ((UITapGestureRecognizer *)sender).view;
        if (view == self.callRemoteView ||
            view == self.callLocalView) {
            if(view.frame.size.width > smallView_Width * 2){
                [self.callVideoControlView setHidden:!self.callVideoControlView.hidden];
            }else{
                if (view == self.callRemoteView) {
                    [self setBigView:self.callRemoteView];
                    [self setSmallView:self.callLocalView];
                }else if(view == self.callLocalView){
                    [self setBigView:self.callLocalView];
                    [self setSmallView:self.callRemoteView];
                }else{
                
                }
            }
        }
    }else{
        [self.callVideoControlView setHidden:!self.callVideoControlView.hidden];
    }
}


/**
 call状态代理函数

 @param callState call状态
 */
-(void)callModuleStateChanged:(CALLModuleState)callState
{
    __weak typeof(self) weekself = self;
    switch (callState) {
        case CALLModuleState_unknown:
            
            break;
            
        case CALLModuleState_initialized:
            
            break;
            
        case CALLModuleState_sessionProgress:
            
            break;
            
        case CALLModuleState_dialing:
        {
            if ([[CallModule shareInstance] checkCurrentCallIsVideo]) {
                [[CallModule shareInstance] getCurrentCall].localVideoView = self.localView;
            }
        }
            break;
            
        case CALLModuleState_ringing:
        {
            if ([[CallModule shareInstance] checkCurrentCallIsVideo]) {
                [[CallModule shareInstance] getCurrentCall].localVideoView = self.localView;
            }
        }
            break;
            
            
        case CALLModuleState_answering:
    
            break;
            
            
        case CALLModuleState_talking:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(self) blockself = weekself;
                if (blockself) {
                    BOOL isVideo = [[CallModule shareInstance] checkCurrentCallIsVideo];
                    
                    if (isVideo) {
                        self.callView.frame = self.view.frame;
                        [self.view addSubview:self.callView];
                        [blockself initVideoCallButtonImage];
                        
                        [[CallModule shareInstance] getCurrentCall].localVideoView = self.callLocalView;
                        [[CallModule shareInstance] getCurrentCall].remoteVideoView = self.callRemoteView;
                    }else{
                        self.callAudioView.frame = self.view.frame;
                        [self.view addSubview:self.callAudioView];
                        [blockself initCallAudioButtonImage];
                    }
                    [blockself startTimer];
                }
            });
        }
            break;
            
        case CALLModuleState_terminated:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(self) blockself = weekself;
                if (blockself) {
                    [blockself onclickHangup:nil];
                    [blockself stopTimer];
                }
            });
        }
            break;
            
        case CALLModuleState_notificationWaiting:
            
            break;
            
        default:
            break;
    }
}


/**
 接受call

 @param sender xib
 */
-(IBAction)onclickAccept:(id)sender
{
    [(UIButton *)sender setEnabled:NO];
    [CCKitManger accept:^(NSError *error) {
        
    }];
}

/**
 忽略call
 
 @param sender xib
 */
-(IBAction)onclickIgnore:(id)sender
{
    [[CallModule shareInstance] ignore:^(NSError *error) {

    }];
}


/**
 拒接Call

 @param sender xib
 */
-(IBAction)onclickRefuse:(id)sender
{
    [(UIButton *)sender setEnabled:NO];
    [CCKitManger reject:^(NSError *error) {

    }];
    [self hiddenInWindow];
}


/**
 挂断

 @param sender xib
 */
-(IBAction)onclickHangup:(id)sender
{
    [self stopTimer];
    
    [(UIButton *)sender setEnabled:NO];
    [CCKitManger hangup:^(NSError *error) {

    }];
    [self hiddenInWindow];
}


/**
 切换前后摄像头

 @param sender xib
 */
-(IBAction)onclickSwitchFBCamera:(id)sender
{
    [self.switchFBCameraButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [CCKitManger switchFontAndBackCamera:^(NSError *error) {
        typeof(self) blockself = weekself;
        if (blockself) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockself.switchFBCameraButton setEnabled:YES];
            });
        }
    }];
}

/**
 开关mic
 
 @param sender xib
 */
-(IBAction)onclickSwitchMute:(id)sender
{
    [self.switchMuteButton setEnabled:NO];
    [self.callAudioSwitchMuteButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [CCKitManger startAndShutMute:^(NSError *error) {
        typeof(self) blockself = weekself;
        if (blockself) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockself.switchMuteButton setEnabled:YES];
                [blockself.callAudioSwitchMuteButton setEnabled:YES];
                [blockself initVideoCallButtonImage];
                [blockself initCallAudioButtonImage];
            });
        }
    }];
}

/**
 切换扬声器和听筒
 
 @param sender xib
 */
-(IBAction)onclickSwitchSpeaker:(id)sender
{
    [self.switchSpeakerButton setEnabled:NO];
    [self.callAudioSwitchSpeakerButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [CCKitManger switchSpeakerAndReceiver:^(NSError *error) {
         typeof(self) blockself = weekself;
         if (blockself) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [blockself.switchSpeakerButton setEnabled:YES];
                 [blockself.callAudioSwitchSpeakerButton setEnabled:YES];
                 [blockself initVideoCallButtonImage];
                 [blockself initCallAudioButtonImage];
             });
         }
     }];
}

/**
 开关摄像头
 
 @param sender xib
 */
-(IBAction)onclickSwitchCamera:(id)sender
{
    [self.switchCameraButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [CCKitManger startAndShutLocalView:^(NSError *error) {
        typeof(self) blockself = weekself;
        if (blockself) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockself.switchCameraButton setEnabled:YES];
                [self initVideoCallButtonImage];
            });
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 支持屏幕旋转函数

 @return YES 是  NO 否
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[CallModule shareInstance] checkCurrentCallIsVideo]) {
        return (UIInterfaceOrientationMaskPortrait |
                UIInterfaceOrientationMaskLandscapeRight);
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    CGFloat duration = [coordinator transitionDuration];
    [UIView animateWithDuration:duration
                     animations:^{
                         
                     }
                     completion:^(BOOL finished) {
                         if ([[CallModule shareInstance] checkCurrentCallIsVideo]) {
                             self.callView.frame = self.view.frame;
                         }else{
                             self.callAudioView.frame = self.view.frame;
                         }
                     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



