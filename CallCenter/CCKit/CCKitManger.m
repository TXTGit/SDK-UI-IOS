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
    [[ProvisionModule shareInstance]
     directLogin:userName
     password:password
     callback:^(NSError *error) {
         if (callback) {
             callback(error);
         }
     }];
}

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


#pragma mark 在有来电来的时候有效
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


#pragma mark 接通后有效
//挂断来电
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


#pragma mark MPV
//MPV的流程和CALL流程相比，MPV流程是在Call的流程上加入房间管理的功能
//及call这个会议前需要join这个房间，挂断需要leave这个房间


//创建房间和邀请成员
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


//接受会议
//error 为nil 请在 callback 中执行跳转到
//参考 -(void)onInviteReceived:(KandyMultiPartyConferenceInvite*)inviteEvent;
//实现逻辑

+(void)conferenceAccept:(KandyCallback)callback;
{
    [[ConferenceModule shareInstance] acceptConference:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

//拒绝会议
+(void)conferenceReject:(KandyCallback)callback;
{
    [[CallModule shareInstance] reject:^(NSError *error) {

    }];
    
    [[ConferenceModule shareInstance] leave:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

//挂断会议
+(void)conferenceHangup:(KandyCallback)callback;
{
    [[CallModule shareInstance] hangup:^(NSError *error) {

    }];
    
    [[ConferenceModule shareInstance] leave:^(NSError *error) {
        if (callback) {
            callback(error);
        }

    }];
}


@end



