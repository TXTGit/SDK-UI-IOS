//
//  CCMPVCallViewController.m
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "CCMPVCallViewController.h"
#import "../KandySDK/CallModule.h"
#import "CCKitManger.h"
#import "CCMPVSettingCallViewController.h"

#import "ConferenceModule.h"
#import "MPVRoomArchive.h"


@interface CCMPVCallViewController ()<CallModuleDelagate>
{
    NSDate *startDate;
    NSTimer *timer;
}

@property (nonatomic, strong) IBOutlet UILabel *callStateLabel;
@property (nonatomic, strong) IBOutlet UILabel *callSourceLabel;


@property(nonatomic, strong) IBOutlet UIView *callAudioView;
@property (nonatomic, strong) IBOutlet UIImageView *callAudioImageView;
@property (nonatomic, strong) IBOutlet UILabel *callAudioCallSourceLabel;
@property(nonatomic, strong) IBOutlet UILabel *callAudioTimeLabel;
@property(nonatomic, strong) IBOutlet UIButton *callAudioSwitchMuteButton;
@property(nonatomic, strong) IBOutlet UIButton *callAudioSwitchSpeakerButton;

@property(nonatomic, strong) IBOutlet UIView *callVideoView;
@property(nonatomic, strong) IBOutlet UIView *callRemoteView;
@property (nonatomic, strong) IBOutlet UILabel *callVideoCallSourceLabel;
@property(nonatomic, strong) IBOutlet UILabel *callVideoTimeLabel;
@property(nonatomic, strong) IBOutlet UIButton *switchFBCameraButton;
@property(nonatomic, strong) IBOutlet UIButton *switchMuteButton;
@property(nonatomic, strong) IBOutlet UIButton *switchCameraButton;
@property(nonatomic, strong) IBOutlet UIButton *switchSpeakerButton;

@end

@implementation CCMPVCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [CallModule shareInstance].delegate = self;
    self.callSourceLabel.text = self.roomNumber;
    self.callStateLabel.text = @"正在接通中";
    
    __weak typeof(self) weekself = self;
    [[CallModule shareInstance] establishMPVCall:self.roomNumber callback:^(NSError *error) {
        KDALog(@"establishCallWithResponseBlock error == %@", [error description]);
        typeof(self) blockself = weekself;
        if (blockself) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    blockself.callStateLabel.text = @"等待响应中";
                }else{
                    [blockself onclickHangup:nil];
                }
            });
        }
    }];

    [self initCallAudioButtonImage];
    [self initVideoCallButtonImage];
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


-(void)callModuleStateChanged:(CALLModuleState)callState
{
    __weak typeof(self) weekself = self;
    switch (callState) {
        case CALLModuleState_unknown:
            
            break;
            
        case CALLModuleState_initialized:
            
            break;
            
            
        case CALLModuleState_dialing:
            
            break;
            
        case CALLModuleState_sessionProgress:
            
            break;
            
            
        case CALLModuleState_ringing:
            
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
                        self.callVideoView.frame = self.view.frame;
                        [self.view addSubview:self.callVideoView];
                        [blockself initVideoCallButtonImage];
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


-(IBAction)onclickAccept:(id)sender
{
    [CCKitManger accept:^(NSError *error) {
        
    }];
}

-(IBAction)onclickHold:(id)sender
{
    [[CallModule shareInstance] ignore:^(NSError *error) {
        
    }];
}

-(IBAction)onclickRefuse:(id)sender
{
    [CCKitManger conferenceReject:^(NSError *error) {
    
        KDALog(@"leave error == %@", [error description]);
        if (error &&
            [[error description] rangeOfString:@"Conference not active"].location != NSNotFound) {
            MPVRoomModel *mv = [[MPVRoomModel alloc] init];
            mv.roomId = self.roomNumber;
            mv.roomState = RoomState_Over;
            [MPVRoomArchive appendSave:mv];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    }];

}


-(IBAction)onclickHangup:(id)sender
{
    [self stopTimer];
    
    [CCKitManger conferenceHangup:^(NSError *error) {
        
        KDALog(@"leave error == %@", [error description]);
        if (error &&
            [[error description] rangeOfString:@"Conference not active"].location != NSNotFound) {
            MPVRoomModel *mv = [[MPVRoomModel alloc] init];
            mv.roomId = self.roomNumber;
            mv.roomState = RoomState_Over;
            [MPVRoomArchive appendSave:mv];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    }];
}


-(IBAction)onclickSwitchFBCamera:(id)sender
{
    [self.switchFBCameraButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [[CallModule shareInstance] switchFBCamera:^(NSError *error) {
        typeof(self) blockself = weekself;
        if (blockself) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockself.switchFBCameraButton setEnabled:YES];
            });
        }
    }];
}


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


-(IBAction)onclickSwitchSpeaker:(id)sender
{
    [self.switchSpeakerButton setEnabled:NO];
    [self.callAudioSwitchSpeakerButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [[CallModule shareInstance]
     changeAudioRoute:[[CallModule shareInstance] getCurrentCall].audioRoute == EKandyCallAudioRoute_speaker?EKandyCallAudioRoute_receiver:EKandyCallAudioRoute_speaker
     Callback:^(NSError *error) {
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


-(IBAction)onclickSetting:(id)sender
{
    CCMPVSettingCallViewController *cccall = [[CCMPVSettingCallViewController alloc] initWithNibName:@"CCMPVSettingCallViewController" bundle:nil];
    [self presentViewController:cccall animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[CallModule shareInstance] checkCurrentCallIsVideo]) {
        self.callVideoView.frame = self.view.frame;
        return (UIInterfaceOrientationMaskPortrait |
                UIInterfaceOrientationMaskLandscapeRight);
    }else{
        self.callAudioView.frame = self.view.frame;
        return (UIInterfaceOrientationMaskPortrait);
    }
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
