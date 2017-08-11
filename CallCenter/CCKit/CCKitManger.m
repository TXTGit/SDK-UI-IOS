//
//  CCKitManger.m
//  Haier
//
//  Created by aiquantong on 19/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "CCKitManger.h"

@implementation CCKitManger


//注册kandy
+(void)registerWithKey:(NSString *)key secret:(NSString *)secret;
{
    [[KandyAdpter shareInstance] initKandySDKWithKey:key secret:secret];
}


//登陆kandy
+(void)loginKandyWithUserName:(NSString *)userName password:(NSString *)password callback:(KandyCallback)callback;
{
    [AccessModule loginRN:userName
     password:password
     callback:^(NSError *error) {
         if (callback) {
             callback(error);
         }
     }];
}

//登出kandy
+(void)loginoutCallback:(KandyCallback)callback;
{
    [ProvisionModule deactivate:^(NSError *error) {
         if (callback) {
             callback(error);
         }
     }];
}


#pragma mark 本sdk中采用CCCallViewController为call处理委托控制器并将细节逻辑进行包装
//拨打电话
+(void)callWithIsPstn:(BOOL)isPstn isWithVideo:(BOOL)isVideo callee:(NSString *)Callee callback:(KandyCallback)callback;
{
    [[CallModule shareInstance]
     callWithIsPstn:isPstn
     isWithVideo:isVideo
     Callee:Callee
     Callback:^(NSError *error) {
         if (callback) {
             callback(error);
         }
     }];
}


//接收来电
+(void)accept:(KandyCallback)callback;
{
    [[CallModule shareInstance] accept:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}
//拒绝来电
+(void)reject:(KandyCallback)callback;
{
    [[CallModule shareInstance] reject:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

//挂断通话
+(void)hangup:(KandyCallback)callback;
{
    [[CallModule shareInstance] hangup:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

//打开和关闭mic
+(void)startAndShutMute:(KandyCallback)callback;
{
    [[CallModule shareInstance] startAndShutMute:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

//打开和关闭camera
+(void)startAndShutLocalView:(KandyCallback)callback;
{
    [[CallModule shareInstance] startAndShutLocalView:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}


+(void)switchSpeakerAndReceiver:(KandyCallback)callback;
{
    [[CallModule shareInstance]
     changeAudioRoute:[[CallModule shareInstance] getCurrentCall].audioRoute == EKandyCallAudioRoute_speaker?EKandyCallAudioRoute_receiver:EKandyCallAudioRoute_speaker
     Callback:^(NSError *error) {
         if (callback) {
             callback(error);
         }
     }];
}


+(void)switchFontAndBackCamera:(KandyCallback)callback;
{
    [[CallModule shareInstance] switchFBCamera:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}


#pragma mark MPV
+(void)createRoomAndInvite:(NSArray *)inviteeArr callback:(KandyCallback)callback;
{
    [[ConferenceModule shareInstance]
     createRoomAndInvite:inviteeArr
     callback:^(NSError *error) {
         if (callback) {
             callback(error);
         }
    }];
}


+(void)inviteWithInviteeArr:(NSArray *)inviteeArr callback:(KandyCallback)callback;
{
    [[ConferenceModule shareInstance]
     inviteWithInviteeArr:inviteeArr
     callback:^(NSError *error) {
         if (callback) {
             callback(error);
         }
     }];
}

+(void)conferenceAccept:(KandyCallback)callback;
{
    [[ConferenceModule shareInstance] acceptConference:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

+(void)conferenceReject:(KandyCallback)callback;
{
    [[CallModule shareInstance] reject:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
    
    [[ConferenceModule shareInstance] leave:^(NSError *error) {

    }];
    
}

+(void)conferenceHangup:(KandyCallback)callback;
{
    [[CallModule shareInstance] hangup:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
    
    [[ConferenceModule shareInstance] leave:^(NSError *error) {

    }];
}


@end



