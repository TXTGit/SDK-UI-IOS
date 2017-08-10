//
//  CCMPVRoomListViewController.m
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "CCMPVRoomListViewController.h"
#import "CCMPVInviteViewController.h"
#import "MPVRoomArchive.h"

#import "ConferenceModule.h"
#import "MBProgressHUD+Add.h"

#import "CCMPVCallViewController.h"
#import "UIAlertUtil.h"


@interface CCMPVRoomListViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *mtableArr;
}

@property (nonatomic, strong) IBOutlet UITableView *mtableView;

@end


@implementation CCMPVRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"会议室";
    [self setRightNavTitle:@"创建" selector:@selector(onclickCreate:)];
    
    self.mtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    mtableArr = [MPVRoomArchive read];
    [self.mtableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [mtableArr count];
}


static NSString *tableCellName = @"listCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    tableCell = [tableView dequeueReusableCellWithIdentifier:tableCellName];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableCellName];
    }
    tableCell.textLabel.font = [UIFont systemFontOfSize:14];
    MPVRoomModel *mp = [mtableArr objectAtIndex:[indexPath row]];
    
    tableCell.textLabel.textColor = [UIColor darkTextColor];
    tableCell.textLabel.text = mp.roomId;
    
    tableCell.detailTextLabel.textColor = [UIColor colorWithRed:101/225.f green:128/225.f blue:255/255.f alpha:1.000];
    tableCell.detailTextLabel.text = [mp roomStateStr];
    tableCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    return tableCell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath row];
        if (row < [mtableArr count]) {
            MPVRoomModel *mv = [mtableArr objectAtIndex:row];
            [MPVRoomArchive delMv:mv];
            
            [mtableArr removeObjectAtIndex:row];
            [self.mtableView reloadData];
        }
    }
}

static MBProgressHUD *phud = nil;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPVRoomModel *mv = [mtableArr objectAtIndex:[indexPath row]];
    if (mv.roomState != RoomState_Run) {
        [UIAlertUtil showAlertWithTitle:@"提示" message:@"当前会议已结束" persentViewController:self];
        return;
    }
    
    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    phud = [MBProgressHUD showMessag:@"正在加入会议" toView:ad.rootNv.view];
    
    [ConferenceModule shareInstance].curRoomNumber = mv.roomId;
    [ConferenceModule shareInstance].curConferenceId = mv.conferenceId;
    [[ConferenceModule shareInstance]
     acceptConference:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (phud) {
                 [phud hide:YES];
                 phud = nil;
             }
             if(error == nil){
                 AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 CCMPVCallViewController *cccall = [[CCMPVCallViewController alloc] initWithNibName:@"CCMPVCallViewController" bundle:nil];
                 cccall.roomNumber = mv.roomId;
                 cccall.isVideo = YES;
                 [cccall showInWindow];
             }else{
                 if ([[error description] rangeOfString:@"Conference not active"].location != NSNotFound){
                     mv.roomState = RoomState_Over;
                     [MPVRoomArchive appendSave:mv];
                     [self.mtableView reloadData];
                 }
                 
                 KDALog(@"establishCallWithResponseBlock error = %@", [error description]);
                 [MBProgressHUD showError:@"会议已结束" toView:ad.rootNv.view];
             }
         });
     }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)onclickCreate:(id)sender
{
    CCMPVInviteViewController *cccall = [[CCMPVInviteViewController alloc] initWithNibName:@"CCMPVInviteViewController" bundle:nil];
    [self.navigationController pushViewController:cccall animated:YES];
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
