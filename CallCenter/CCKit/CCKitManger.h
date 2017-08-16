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

/**
 注册kandy  
 https://developer.kandycn.com/ 登录kandy开放平台获取key和secret
 
 @param key
 @param secret
 */
+(void)registerWithKey:(NSString *)key secret:(NSString *)secret;

/**
 登录kandy

 @param userName 用户名  如：aiiphon5c@sdkdemo.txtechnology.com.cn
 @param password 密码
 @param callback 结果的回调函数(^KandyCallback)(NSError *error)
 */
+(void)loginKandyWithUserName:(NSString *)userName password:(NSString *)password callback:(KandyCallback)callback;

/**
 登出kandy

 @param callback 结果的回调函数(^KandyCallback)(NSError *error)
 */
+(void)loginoutCallback:(KandyCallback)callback;


#pragma mark 本sdk中采用CCCallViewController为call处理委托控制器并将细节逻辑进行包装
/*
 注意点：
 1，video默认声音输出为扬声器， audio默认声音输出为听筒
 2，默认收到call的唤醒界面在 callModule  -(void) gotIncomingCall:(id<KandyIncomingCallProtocol>)call{
 3，CallVc／CCCallViewController对业务进行处理  
 4，业务处理路径当前仅仅支持单个call，通话中call进来，会自动reject
 */


/**
 拨打呼叫

 @param isPstn   是否为传统呼叫  YES： PSTN   NO：VOIP
 @param isVideo  是否视频
 @param Callee   被叫号码 如：aiiphone6p@sdkdemo.txtechnology.com.cn
 @param callback 结果的回调函数(^KandyCallback)(NSError *error)
 */
+(void)callWithIsPstn:(BOOL)isPstn isWithVideo:(BOOL)isVideo callee:(NSString *)Callee callback:(KandyCallback)callback;

/**
 来电时接受来电

 @param callback 结果的回调函数(^KandyCallback)(NSError *error)
 */
+(void)accept:(KandyCallback)callback;

/**
 来电时拒绝来电

 @param callback 结果的回调函数(^KandyCallback)(NSError *error)
 */
+(void)reject:(KandyCallback)callback;

/**
 挂断电话 主叫呼叫中或者通话中调用此函数结束通话

 @param callback 结果的回调函数(^KandyCallback)(NSError *error)
 */
+(void)hangup:(KandyCallback)callback;

/**
 打开和关闭Mic

 @param callback (^KandyCallback)(NSError *error)
 */
+(void)startAndShutMute:(KandyCallback)callback;


/**
 打开和关闭Camera 在视频通话中调用

 @param callback (^KandyCallback)(NSError *error)
 */
+(void)startAndShutLocalView:(KandyCallback)callback;


/**
 在扬声器和听筒之间切换 在插入耳机后本设置不起作用

 @param callback (^KandyCallback)(NSError *error)
 */
+(void)switchSpeakerAndReceiver:(KandyCallback)callback;


/**
 切换前后摄像头

 @param callback (^KandyCallback)(NSError *error)
 */
+(void)switchFontAndBackCamera:(KandyCallback)callback;



#pragma mark MPV 采用CCMPVCallViewController为MPV Call处理委托控制器并将细节逻辑进行包装
/*
 注意点：
 1，默认收到call的唤醒界面在 ConferenceModule -(void)onInviteReceived:(KandyMultiPartyConferenceInvite*)inviteEvent;
 2，CallVc／CCMPVCallViewController对业务进行处理
 3，对比MPV和Call流程，MPV流程是在Call的流程上加入房间管理的功能。故MPV Call这个会议前需要join这个房间，挂断需要leave这个房间。而其他的操作都是相同
 */


/**
 创建会议并邀请成员

 @param inviteeArr 成员列表数组如[aiiphone6p@sdkdemo.txtechnology.com.cn, user2@sdkdemo.txtechnology.com.cn]
 @param callback callback (^KandyCallback)(NSError *error)
 */
+(void)createRoomAndInvite:(NSArray *)inviteeArr callback:(KandyCallback)callback;

/**
 邀请成员

 @param inviteeArr 新邀请成员列表数组如[aiiphone6p@sdkdemo.txtechnology.com.cn, user2@sdkdemo.txtechnology.com.cn]
 @param callback callback (^KandyCallback)(NSError *error)
 */
+(void)inviteWithInviteeArr:(NSArray *)inviteeArr callback:(KandyCallback)callback;


/**
 接受会议

 @param callback callback (^KandyCallback)(NSError *error)
 */
+(void)conferenceAccept:(KandyCallback)callback;

/**
 拒绝会议

 @param callback callback (^KandyCallback)(NSError *error)
 */
+(void)conferenceReject:(KandyCallback)callback;

//挂断会议

/**
 挂断会议

 @param callback callback (^KandyCallback)(NSError *error)
 */
+(void)conferenceHangup:(KandyCallback)callback;

@end







