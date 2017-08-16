//
//  MPVMemTableViewCell.m
//  SDKDemo
//
//  Created by aiquantong on 25/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "MPVMemTableViewCell.h"
#import "ConferenceModule.h"

@interface MPVMemTableViewCell()
{
    MPVMemModel *memM;
}

@property (nonatomic,strong) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) IBOutlet UILabel *adminLabel;
@property (nonatomic,strong) IBOutlet UIView *opView;
@property (nonatomic,strong) IBOutlet UIButton *leaveBtn;
@property (nonatomic,strong) IBOutlet UIButton *micBtn;
@property (nonatomic,strong) IBOutlet UIButton *cameraBtn;

@end


@implementation MPVMemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setupModel:(MPVMemModel *)mem;
{
    memM = mem;
    
    self.nameLabel.text = mem.participant.participantID;
    if (self.nameLabel.text.length == 0 ) {
        self.nameLabel.text = @"无名称";
    }
    if (mem.participant.audioState == EKandyMultiPartyConferenceParticipantCallMediaState_incomingAndOutgoing) {
        [self.micBtn setImage:[UIImage imageNamed:@"mic_close"] forState:UIControlStateNormal];
    }else{
        [self.micBtn setImage:[UIImage imageNamed:@"mic_open"] forState:UIControlStateNormal];
    }
    
    if (mem.participant.videoState == EKandyMultiPartyConferenceParticipantCallMediaState_incomingAndOutgoing) {
        [self.cameraBtn setImage:[UIImage imageNamed:@"camera_close"] forState:UIControlStateNormal];
    }else{
        [self.cameraBtn setImage:[UIImage imageNamed:@"camera_open"] forState:UIControlStateNormal];
    }
    
    [self.opView setHidden:!mem.isShowOp];
    if (mem.isAdmin) {
        [self.adminLabel setHidden:NO];
        [self.adminLabel setText:@"主持人"];
    }else if(mem.isSelf){
        [self.adminLabel setHidden:NO];
        [self.adminLabel setText:@"自己"];
    }else{
        [self.adminLabel setHidden:YES];
    }

    if (!mem.isCanOp) {
        [self.leaveBtn setEnabled:NO];
        [self.micBtn setEnabled:NO];
        [self.cameraBtn setEnabled:NO];
    }else if (mem.isSelf) {
        [self.leaveBtn setEnabled:NO];
        [self.micBtn setEnabled:NO];
        [self.cameraBtn setEnabled:NO];
    }else{
        [self.leaveBtn setEnabled:YES];
        [self.micBtn setEnabled:YES];
        [self.cameraBtn setEnabled:YES];
    }
}


/**
 主持人强制设置成员离开

 @param sender XIB
 */
-(IBAction)onclickLeave:(id)sender
{
    if (memM && memM.participant.participantID && memM.participant.participantID.length > 0) {
        [self.leaveBtn setEnabled:NO];
        
        [[ConferenceModule shareInstance]
         doParticipantAction:EKandyMultiPartyConferenceAction_remove
         participantID:memM.participant.participantID
         callback:^(NSError *error) {
             KDALog(@"error === %@" , [error description]);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMPVDetail" object:nil];
             });
        }];
    }
}


/**
 主持人设置成员关闭麦克风
 
 @param sender XIB
 */
-(IBAction)onclickMute:(id)sender
{
    if (memM && memM.participant.participantID && memM.participant.participantID.length > 0) {
        [self.micBtn setEnabled:NO];
        
        [[ConferenceModule shareInstance]
         doParticipantAction:memM.participant.audioState == EKandyMultiPartyConferenceParticipantCallMediaState_incomingAndOutgoing?EKandyMultiPartyConferenceAction_mute:EKandyMultiPartyConferenceAction_unmute
         participantID:memM.participant.participantID
         callback:^(NSError *error) {
             KDALog(@"error === %@" , [error description]);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.micBtn setEnabled:YES];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMPVDetail" object:nil];
             });
         }];
    }
}

/**
 主持人设置成员关闭摄像头
 
 @param sender XIB
 */
-(IBAction)onclickCamera:(id)sender
{
    if (memM && memM.participant.participantID && memM.participant.participantID.length > 0) {
        [self.cameraBtn setEnabled:NO];
        
        [[ConferenceModule shareInstance]
         doParticipantAction:memM.participant.videoState == EKandyMultiPartyConferenceParticipantCallMediaState_incomingAndOutgoing?EKandyMultiPartyConferenceAction_disableVideo:EKandyMultiPartyConferenceAction_enableVideo
         participantID:memM.participant.participantID
         callback:^(NSError *error) {
             KDALog(@"error === %@" , [error description]);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.cameraBtn setEnabled:YES];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMPVDetail" object:nil];
             });
         }];
    }
}

@end
