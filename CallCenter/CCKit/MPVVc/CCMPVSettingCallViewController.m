//
//  CCMPVSettingCallViewController.m
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "CCMPVSettingCallViewController.h"
#import "ConferenceModule.h"

#import "MPVMemTableViewCell.h"
#import "UIView+Toast.h"
#import <KandySDK/KandySDK.h>


@interface CCMPVSettingCallViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *mtableArr;
}

@property (nonatomic, strong) IBOutlet UITableView *mtableView;

@property (nonatomic, strong) IBOutlet UIView *mtableHeader;
@property (nonatomic, strong) IBOutlet UILabel *mtableHeaderLabel;

@end

@implementation CCMPVSettingCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    mtableArr = [[NSMutableArray alloc] initWithCapacity:10];
    [[ConferenceModule shareInstance] getConferenceDetail:^(NSError *error, id<KandyMultiPartyConferenceCallDetailsProtocol> conferenceCallDetails) {
        KDALog(@"error == %@, conferenceCallDetails == %@", [error description], [conferenceCallDetails description]);
        
        [mtableArr removeAllObjects];
        
        NSString *adminStr = nil;
        if (conferenceCallDetails.admins && conferenceCallDetails.admins.count > 0 ) {
            adminStr = conferenceCallDetails.admins.firstObject;
        }
        
        for(id<KandyMultiPartyConferenceParticipantProtocol> participant in conferenceCallDetails.participants){
            MPVMemModel *mmm = [[MPVMemModel alloc] init];
            mmm.participant = participant;
            mmm.isShowOp = NO;
            
            if (participant.participantID && participant.participantID.length > 0) {
                mmm.isAdmin = [participant.participantID hasSuffix:adminStr];
            }
            [mtableArr addObject:mmm];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mtableView reloadData];
            self.mtableHeaderLabel.text = [NSString stringWithFormat:@"所有成员(%ud)", (int)conferenceCallDetails.participants.count];
        });
        
    }];
    
    self.mtableView.tableHeaderView = self.mtableHeader;
    self.mtableHeader.frame = CGRectMake(0, 0, self.mtableView.frame.size.width, 40);
    self.mtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [mtableArr count];
}


static NSString *tableCellName = @"MPVMemTableViewCellId";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPVMemTableViewCell *tableCell = nil;
    tableCell = [tableView dequeueReusableCellWithIdentifier:tableCellName];
    if (tableCell == nil) {
        [self.mtableView registerNib:[UINib nibWithNibName:@"MPVMemTableViewCell" bundle:nil] forCellReuseIdentifier:tableCellName];
        tableCell = [tableView dequeueReusableCellWithIdentifier:tableCellName];
    }
    MPVMemModel *mmm = [mtableArr objectAtIndex:[indexPath row]];
    [tableCell setupModel:mmm];
    return tableCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPVMemModel *mmm = [mtableArr objectAtIndex:[indexPath row]];
    if (mmm.isShowOp) {
        return 90;
    }else{
        return 44;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0 ; i < [mtableArr count]; i++) {
        MPVMemModel *mmm = [mtableArr objectAtIndex:i];
        if ([indexPath row] == i) {
            mmm.isShowOp = !mmm.isShowOp;
        }else{
            mmm.isShowOp = NO;
        }
    }
    [self.mtableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 邀请

 @param sender XIB
 */
-(IBAction)onclickInviteMore:(id)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"邀请新成员"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"输入用户ID";
        textField.text = @"10001@sdkdemo.txtechnology.com.cn";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       
                                   }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"确定"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   UITextField *accountTxt = alertController.textFields.firstObject;
                                   NSString *accountStr = accountTxt.text;
                                   if (accountStr &&
                                       [accountStr hasSuffix:[Kandy sharedInstance].sessionManagement.currentUser.record.domain]) {
                                       
                                       [[ConferenceModule shareInstance]
                                        inviteWithInviteeArr:@[accountStr]
                                        callback:^(NSError *error) {
                                            KDALog(@"inviteWithInviteeArr error == %@", [error description]);
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                  [self.view makeToast:@"发送邀请成员失败"];
                                                }else{
                                                  [self.view makeToast:@"发送邀请成员成功"];
                                                }
                                            });
                                       }];
                                   }else{
                                       [alertController.view makeToast:@"输入的参会者，domain不正确"];
                                   }
                               }];
    [alertController addAction:okAction];
    
   [self presentViewController:alertController animated:YES completion:nil];
}


-(IBAction)onclickClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
