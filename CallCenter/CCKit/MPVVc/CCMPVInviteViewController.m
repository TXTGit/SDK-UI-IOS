//
//  CCMPVInviteViewController.m
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "CCMPVInviteViewController.h"
#import <KandySDK/KandySDK.h>

#import "UIAlertUtil.h"
#import "ConferenceModule.h"
#import "MPVRoomArchive.h"

#import "CCMPVCallViewController.h"
#import "MBProgressHUD+Add.h"

#import "CCKitManger.h"


@interface CCMPVInviteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *mtableArr;
}

@property (nonatomic, strong) IBOutlet UITableView *mtableView;

@property (nonatomic, strong) IBOutlet UIView *section0Footer;
@property (nonatomic, strong) IBOutlet UITextField *addMunberTxt;

@property (nonatomic, strong) IBOutlet UIView *section1Footer;
@property (nonatomic, strong) IBOutlet UITextField *nickNameTxt;

@end

@implementation CCMPVInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"创建多人会议";
    [self setRightNavTitle:@"取消" selector:@selector(oncickCancel:)];
    
    mtableArr = [[NSMutableArray alloc] initWithCapacity:10];
    [mtableArr addObject:[Kandy sharedInstance].sessionManagement.currentUser.record.uri];
    
    self.mtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)oncickCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *vc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mtableView.frame.size.width, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.mtableView.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:13];
    
    if (section == 0) {
        label.text = @"成员列表";
    }else if(section == 1){
        label.text = @"昵称设置";
    }else{
        label.text = @"XX";
    }
    [vc addSubview:label];
    
    return vc;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    if (section == 0) {
        self.section0Footer.frame = CGRectMake(0, 0, self.mtableView.frame.size.width, 60);
        return self.section0Footer;
    }else if(section == 1){
        self.section1Footer.frame = CGRectMake(0, 0, self.mtableView.frame.size.width, 110);
        return self.section1Footer;
    }else{
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (section == 0) {
        return 60;
    }else if(section == 1){
        return 110;
    }else{
        return 0;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return [mtableArr count];
    }else{
        return 0;
    }
}


static NSString *tableCellName = @"listCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    tableCell = [tableView dequeueReusableCellWithIdentifier:tableCellName];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableCellName];
    }
    tableCell.textLabel.font = [UIFont systemFontOfSize:13];
    NSString *txt = [[mtableArr objectAtIndex:[indexPath row]] description];
    
    tableCell.textLabel.textColor = [UIColor darkTextColor];
    tableCell.textLabel.text = txt;
    
    return tableCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([indexPath row] == 0) {
        return NO;
    }else{
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath row];
        if (row < [mtableArr count]) {
            [mtableArr removeObjectAtIndex:row];
            [self.mtableView reloadData];
        }
    }
}


-(IBAction)onclickAddMum:(id)sender
{
    NSString *mumId = self.addMunberTxt.text;
    if (mumId && [mumId hasSuffix:[Kandy sharedInstance].sessionManagement.currentUser.record.domain]) {
        [mtableArr addObject:mumId];
        [self.mtableView reloadData];
        self.addMunberTxt.text = @"";
    }else{
        [UIAlertUtil showAlertWithTitle:@"提示" message:@"输入的参会者，domain不正确" persentViewController:self];
    }
}

static MBProgressHUD *phud = nil;
-(IBAction)onclickCreateMPV:(id)sender
{
    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    phud = [MBProgressHUD showMessag:@"正在创建会议" toView:ad.rootNv.view];
    
    [CCKitManger
     createRoomAndInvite:mtableArr
     callback:^(NSError *error) {
        KDALog(@"createRoomAndInvite error == %@", [error description]);
         NSString *roomId = [ConferenceModule shareInstance].curRoomNumber;
         NSString *conferenceId = [ConferenceModule shareInstance].curConferenceId;
         
         MPVRoomModel *mv = [[MPVRoomModel alloc] init];
         mv.roomId = [roomId copy];
         mv.conferenceId = [conferenceId copy];
         mv.roomState = RoomState_Run;
         [MPVRoomArchive appendSave:mv];
         
         if (phud) {
             phud.labelText = @"正在加入会议";
         }
         
         [[ConferenceModule shareInstance]
          joinWithnickName:self.nickNameTxt.text
          callback:^(NSError *error) {
              KDALog(@"joinWithnickName error == %@", [error description]);

              dispatch_async(dispatch_get_main_queue(), ^{
                  if (phud) {
                      [phud hide:YES];
                  }
                  
                  if (error == nil) {
                      CCMPVCallViewController *cccall = [[CCMPVCallViewController alloc] initWithNibName:@"CCMPVCallViewController" bundle:nil];
                      cccall.roomNumber = roomId;
                      AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                      [ad.rootNv presentViewController:cccall animated:YES completion:NULL];
                  }else{
                      [MBProgressHUD showError:@"加入会议失败" toView:self.view];
                  }
              });
          }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


