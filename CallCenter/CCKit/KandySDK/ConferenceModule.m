//
//  ConferenceModule.m
//  tvc
//
//  Created by aiquantong on 8/17/16.
//  Copyright © 2016 genband. All rights reserved.
//

#import "ConferenceModule.h"
#import "CallModule.h"
#import "TonePlayer.h"

#import "UIAlertUtil.h"
#import "AppDelegate.h"
#import "MPVRoomArchive.h"

#import "CCMPVCallViewController.h"
#import "MBProgressHUD+Add.h"


@interface ConferenceModule()<KandyMultiPartyConferenceNotificationDelegate>
{
  
}
@end

@implementation ConferenceModule

@synthesize curConferenceId,curRoomNumber;
@synthesize curPSTNRoomNumber,curPinCode;


static ConferenceModule *shareInstance = nil;

+(ConferenceModule *) shareInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ConferenceModule alloc] init];
    });
    return shareInstance;
}


- (instancetype)init
{
  self = [super init];
  if (self) {
    [self registerKandyNotification];
  }
  return self;
}


-(void)registerKandyNotification;
{
    [[Kandy sharedInstance].services.multiPartyConference registerNotifications:self];
}


-(void)dealloc
{
  KDALog(@"dealloc");
  [[Kandy sharedInstance].services.multiPartyConference unregisterNotifications:self];
}


-(void)createRoomAndInvite:(NSArray *)inviteeArr callback:(KandyCallback)callback
{
  
  NSMutableArray * communityRecords = [[NSMutableArray alloc] init];
  KandyRecord * record = nil;
  
  for (NSString * userID in inviteeArr) {
    record = [[KandyRecord alloc] initWithURI:userID type:EKandyRecordType_contact associationType:EKandyRecordAssociationType_community];
    [communityRecords addObject:record];
  }
  KandyMultiPartyConferenceInvitees *invitees = [[KandyMultiPartyConferenceInvitees alloc] initWithChatInvitees:communityRecords mailInvitees:nil SMSInvitees:nil];
  
  __weak typeof(self) weekself = self;
  [[Kandy sharedInstance].services.multiPartyConference
   createRoomAndInvite:invitees
   annotation:EKandyMultiPartyConferenceAnnotation_nickname
   responseCallback:^(NSError * error, id<KandyMultiPartyConferenceRoomProtocol> conferenceRoomDetails,
                      id<KandyMultiPartyConferenceSuccessfulInviteesProtocol> succeedInvitees,
                      id<KandyMultiPartyConferenceFailedInviteesProtocol> failedInvitees) {
     
     KDALog(@"conferenceRoomDetails === %@ %@ %@ %@ error === %@ ", conferenceRoomDetails.conferenceID, conferenceRoomDetails.roomNumber, conferenceRoomDetails.roomPSTNNumber, conferenceRoomDetails.pinCode,
            [error description]);
     
     typeof (self) blockself = weekself;
     
     if (blockself) {
         if (!error) {
             blockself.curConferenceId = conferenceRoomDetails.conferenceID;
             blockself.curRoomNumber = conferenceRoomDetails.roomNumber;
             blockself.curPSTNRoomNumber = conferenceRoomDetails.roomPSTNNumber;
             blockself.curPinCode = conferenceRoomDetails.pinCode;
         }else{
             blockself.curConferenceId = nil;
             blockself.curRoomNumber = nil;
             blockself.curPSTNRoomNumber = nil;
             blockself.curPinCode = nil;
         }
     }
       if (callback) {
           callback(error);
       }
       
   }];
}


-(void)inviteWithInviteeArr:(NSArray *)inviteeArr callback:(KandyCallback)callback
{
  if (!curConferenceId && callback) {
    callback([[NSError alloc] initWithDomain:@"curConferenceId should be not nul" code:-100 userInfo:nil]);
    return;
  }
  
  NSMutableArray * communityRecords = [[NSMutableArray alloc] init];
  KandyRecord * record = nil;
  
  for (NSString * userID in inviteeArr) {
    record = [[KandyRecord alloc] initWithURI:userID type:EKandyRecordType_contact associationType:EKandyRecordAssociationType_community];
    [communityRecords addObject:record];
  }
  
  KandyMultiPartyConferenceInvitees *invitees = [[KandyMultiPartyConferenceInvitees alloc] initWithChatInvitees:communityRecords mailInvitees:nil SMSInvitees:nil];
  
  [[Kandy sharedInstance].services.multiPartyConference
   invite:invitees conferenceID:curConferenceId
   responseCallback:^(NSError *error, id<KandyMultiPartyConferenceSuccessfulInviteesProtocol> successfulInvitees, id<KandyMultiPartyConferenceFailedInviteesProtocol> failedInvitees) {
     KDALog(@"error === %@ ", [error description]);
       if (callback) {
           callback(error);
       }
   } ];
}


-(void)acceptConference:(KandyCallback)callback
{
  if (!self.curRoomNumber || !self.curConferenceId) {
    callback([[NSError alloc] initWithDomain:@"curRoomNumber is null" code:-100 userInfo:nil]);
    return;
  }
  
  [TonePlayer stopTonePlayer];
  NSString *nickName = [Kandy sharedInstance].sessionManagement.currentUser.record.uri;
  [[ConferenceModule shareInstance] joinWithnickName:nickName callback:callback];
}


-(void)refuseConference:(KandyCallback)callback
{
  [TonePlayer stopTonePlayer];
    if (callback) {
        callback(nil);
    }
}


-(void)joinWithnickName:(NSString *)nickName callback:(KandyCallback)callback
{
  if (!self.curConferenceId && callback) {
    callback([[NSError alloc] initWithDomain:@"curConferenceId is null" code:-100 userInfo:nil]);
    return;
  }
  
  [[Kandy sharedInstance].services.multiPartyConference
   join:self.curConferenceId
   nickName:nickName
   responseCallback:^(NSError *error) {
     KDALog(@"error join === %@ ", [error description]);
       if (callback) {
           callback(error);
       }
   }];
}


-(void)leave:(KandyCallback)callback
{
    if (!self.curConferenceId || !self.curRoomNumber) {
        if (callback) {
            callback([[NSError alloc] initWithDomain:@"incomingConferenceRoom and curRoomNumber is null"
                                                code:-100
                                            userInfo:nil]);
        }
        return;
    }
    
    [[Kandy sharedInstance].services.multiPartyConference leave:curConferenceId
                                               responseCallback:^(NSError *error) {
                                                   
                                                   KDALog(@"error === %@ ", [error description]);
                                                   if (callback) {
                                                       callback(error);
                                                   }
                                               }];
}


-(void)destroy:(KandyCallback)callback {
  
  if (!self.curRoomNumber && callback) {
      callback([[NSError alloc] initWithDomain:@"curRoomNumber is null" code:-100 userInfo:nil]);
    return;
  }
  
  [[Kandy sharedInstance].services.multiPartyConference destroyRoom:curRoomNumber
                                                   responseCallback:^(NSError *error) {
                                                     
                                                     KDALog(@"error === %@ ", [error description]);
                                                       if (callback) {
                                                           callback(error);
                                                       }
                                                   }];
}


-(void)getConferenceDetail:(KandyConferenceCallback)callback
{
    if (!self.curConferenceId && callback) {
        callback([[NSError alloc] initWithDomain:@"curConferenceId is null" code:-100 userInfo:nil],nil);
        return;
    }
    
    [[Kandy sharedInstance].services.multiPartyConference
     getConferenceCallDetailsWithConferenceID:self.curConferenceId
     responseCallback:^(NSError *error, id<KandyMultiPartyConferenceCallDetailsProtocol> conferenceCallDetails) {
         if (callback) {
             callback(error,conferenceCallDetails);
         }
     }];
}



-(void)doParticipantAction:(EKandyMultiPartyConferenceAction)action participantID:(NSString *)participantID callback:(KandyCallback)callback
{
  if (!self.curConferenceId && callback) {
    callback([[NSError alloc] initWithDomain:@"curConferenceId is null" code:-100 userInfo:nil]);
    return;
  }
  
  KandyMultiPartyConferenceParticipantActionParams * participantActions =
  [[KandyMultiPartyConferenceParticipantActionParams alloc] initWithParticipantID:participantID action:action];
  
  [[Kandy sharedInstance].services.multiPartyConference
   updateRoomParticipantActions:@[participantActions]
   conferenceID:self.curConferenceId
   responseCallback:^(NSError * error, NSArray<KandyMultiPartyConferenceParticipantActionParams*>* successfullActions, NSArray<KandyMultiPartyConferenceParticipantFailedActionParams*>* failedActions) {
       if (callback) {
           callback(error);
       }
   }];
}


#pragma mark KandyMultiPartyConferenceNotificationDelegate ------------------

static MBProgressHUD *phud = nil;

-(void)onInviteReceived:(KandyMultiPartyConferenceInvite*)inviteEvent;
{
    KDALog(@"onInviteReceived inviteEvent == %@", [inviteEvent description]);
    
    id<KandyMultiPartyConferenceRoomProtocol> conferenceRoomDetails = inviteEvent.conferenceRoomDetails;
    
    //防止同一个会议收到多个消息的情况
    if (inviteEvent.sender.uri && [inviteEvent.sender.uri isEqualToString:[Kandy sharedInstance].sessionManagement.currentUser.record.uri]) {
        return;
    }
    
    self.curConferenceId = conferenceRoomDetails.conferenceID;
    self.curRoomNumber = conferenceRoomDetails.roomNumber;
    
    [inviteEvent markAsReceivedWithResponseCallback:^(NSError *error) {
        KDALog(@"error === %@", [error description]);
    }];
    
    [TonePlayer startTonePlayer];
    
    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [UIAlertUtil
     showAlertWithPersentViewController:ad.rootNv
     alertCallBack:^(NSInteger index) {
         [TonePlayer stopTonePlayer];
         if (index == 0) {
             
         }else if(index == 1 || index == 2){
             MPVRoomModel *mv = [[MPVRoomModel alloc] init];
             mv.conferenceId = self.curConferenceId;
             mv.roomId = self.curRoomNumber;
             mv.roomState = RoomState_Run;
             
             [MPVRoomArchive appendSave:mv];
             
             if (index == 2) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                      phud = [MBProgressHUD showMessag:@"正在加入会议" toView:ad.rootNv.view];
                  });
                 
                 [[ConferenceModule shareInstance]
                  acceptConference:^(NSError *error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (phud) {
                              [phud hide:YES];
                              phud = nil;
                          }
                          if(error == nil){
                              CCMPVCallViewController *cccall = [[CCMPVCallViewController alloc] initWithNibName:@"CCMPVCallViewController" bundle:nil];
                              cccall.roomNumber = self.curRoomNumber;
                              cccall.isVideo = YES;
                              [cccall showInWindow];
                          }else{
                              KDALog(@"establishCallWithResponseBlock error = %@", [error description]);
                              [MBProgressHUD showError:@"加入会议失败" toView:ad.rootNv.view];
                          }
                      });
                  }];
             }
             
         }else{
             
         }
     }
     title:@"你有一个会议邀请"
     message:[NSString stringWithFormat:@"房间号：%@",self.curRoomNumber]
     cancelButtonTitle:@"拒绝"
     otherButtonTitles:@"稍后",@"加入",nil];
}


-(void)onConferenceRoomRemovedReceived:(KandyMultiPartyConferenceRoomRemoved*)event;
{
  KDALog(@"");

}


-(void)onParticipantMuteReceived:(KandyMultiPartyConferenceParticipantMute*)event;
{
  KDALog(@"");

}


-(void)onParticipantUnmuteReceived:(KandyMultiPartyConferenceParticipantUnmute*)event;
{
  KDALog(@"");

}


-(void)onParticipantJoinedRoomReceived:(KandyMultiPartyConferenceParticipantJoined*)event;
{
  KDALog(@"");
  
}


-(void)onParticipantLeftRoomReceived:(KandyMultiPartyConferenceParticipantLeft*)event;
{
  KDALog(@"");

}


-(void)onParticipantNameChangeReceived:(KandyMultiPartyConferenceParticipantNameChanged*)event;
{
  KDALog(@"");

}


-(void)onParticipantVideoEnableReceived:(KandyMultiPartyConferenceParticipantVideoEnabled*)event;
{
  KDALog(@"");

}


-(void)onParticipantVideoDisableReceived:(KandyMultiPartyConferenceParticipantVideoDisabled*)event;
{
  KDALog(@"");

}


-(void)onParticipantHoldReceived:(KandyMultiPartyConferenceParticipantHold*)event;
{
  KDALog(@"");
}


-(void)onParticipantUnholdReceived:(KandyMultiPartyConferenceParticipantUnhold*)event;
{
  KDALog(@"");

}


-(void)onParticipantRemovedReceived:(KandyMultiPartyConferenceParticipantRemoved*)event;
{
  KDALog(@"");

}

@end


