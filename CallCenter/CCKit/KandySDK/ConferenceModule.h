//
//  ConferenceModule.h
//  tvc
//
//  Created by aiquantong on 8/17/16.
//  Copyright © 2016 genband. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAdpter.h"

typedef void(^KandyConferenceCallback)(NSError *error, id<KandyMultiPartyConferenceCallDetailsProtocol> conferenceCallDetails);


@interface ConferenceModule : NSObject

@property(nonatomic, strong) NSString *curConferenceId;
@property(nonatomic, strong) NSString *curRoomNumber;
@property(nonatomic, strong) NSString *curPSTNRoomNumber;
@property(nonatomic, strong) NSString *curPinCode;

@property(nonatomic, assign) BOOL mIsVideo;
@property(nonatomic, assign) BOOL mIsAudio;

+(ConferenceModule *) shareInstance;

-(void)registerKandyNotification;

-(void)createRoomAndInvite:(NSArray *)inviteeArr callback:(KandyCallback)callback;

-(void)inviteWithInviteeArr:(NSArray *)inviteeArr callback:(KandyCallback)callback;

-(void)joinWithnickName:(NSString *)nickName callback:(KandyCallback)callback;

-(void)acceptConference:(KandyCallback)callback;

-(void)leave:(KandyCallback)callback;

-(void)getConferenceDetail:(KandyConferenceCallback)callback;

-(void)doParticipantAction:(EKandyMultiPartyConferenceAction)action participantID:(NSString *)participantID callback:(KandyCallback)callback;

@end

