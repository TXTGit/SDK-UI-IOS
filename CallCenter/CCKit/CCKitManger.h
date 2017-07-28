//
//  CCKitManger.h
//  Haier
//
//  Created by aiquantong on 19/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KandyAdpter.h"
#import "AccessModule.h"
#import "ProvisionModule.h"
#import "CallModule.h"
#import "ConferenceModule.h"

@interface CCKitManger : NSObject

//注册kandy
+(void)registerWithKey:(NSString *)key secret:(NSString *)secret;

//登陆kandy
+(void)loginKandyWithUserName:(NSString *)userName password:(NSString *)password callback:(KandyCallback)callback;

+(void)loginoutCallback:(KandyCallback)callback;

#pragma mark 本sdk 中 采用 CCCallViewController为 call处理委托控制器
//拨打电话
+(void)callWithIsPstn:(BOOL)isPstn isWithVideo:(BOOL)isVideo callee:(NSString *)Callee callback:(KandyCallback)callback;

#pragma mark 在有来电来的时候有效
//接收来电
+(void)accept:(KandyCallback)callback;

//拒绝来电
+(void)reject:(KandyCallback)callback;

#pragma mark 接通后有效
//挂断来电
+(void)hangup:(KandyCallback)callback;

//打开和关闭mic
+(void)startAndShutMute:(KandyCallback)callback;

//打开和关闭camera
+(void)startAndShutLocalView:(KandyCallback)callback;


#pragma mark MPV
//MPV的流程和CALL流程相比，MPV流程是在Call的流程上加入房间管理的功能
//及call这个会议前需要join这个房间，挂断需要leave这个房间
+(void)createRoomAndInvite:(NSArray *)inviteeArr callback:(KandyCallback)callback;

//接受会议
+(void)conferenceAccept:(KandyCallback)callback;

//拒绝会议
+(void)conferenceReject:(KandyCallback)callback;

//挂断会议
+(void)conferenceHangup:(KandyCallback)callback;

@end
