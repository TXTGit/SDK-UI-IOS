//
//  SupportViewController.m
//  Haier
//
//  Created by aiquantong on 3/14/17.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "SupportViewController.h"
#import "CCCallViewController.h"
#import "CCKitManger.h"

#import "CCMPVRoomListViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#import "CustomLogViewController.h"
#import "UIView+Toast.h"


@interface SupportViewController ()

@property (nonatomic,strong)IBOutlet UITextField *iphoneTxt;
@property (nonatomic,strong) IBOutlet UISwitch *switchVideo;

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 呼叫
 
 @param sender xib指向
 */
-(IBAction)onclickCall:(id)sender
{
    [CCKitManger
     callWithIsPstn:NO
     isWithVideo:self.switchVideo.isOn
     callee:self.iphoneTxt.text
     callback:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!error) {
                 CCCallViewController *cccall = [[CCCallViewController alloc] initWithNibName:@"CCCallViewController" bundle:nil];
                 [cccall showInWindow];
             }else{
                 [self.view makeToast:[error description]];
             }
         });
     }];
}


/**
 开始多人会议
 
 @param sender xib指向
 */
-(IBAction)onclickMPVStart:(id)sender
{
    CCMPVRoomListViewController *cccall = [[CCMPVRoomListViewController alloc] initWithNibName:@"CCMPVRoomListViewController" bundle:nil];
    [self.navigationController pushViewController:cccall animated:YES];
}


/**
 退出
 
 @param sender xib指向
 */
-(IBAction)onclickLogout:(id)sender
{
    [CCKitManger loginoutCallback:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
            LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [ad.rootNv  setViewControllers:@[login] animated:YES];
        });
    }];
}

/**
 显示日志
 
 @param sender xib指向
 */
-(IBAction)onclickLog:(id)sender
{
    CustomLogViewController *cccall = [[CustomLogViewController alloc] initWithNibName:@"CustomLogViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:cccall];
    [self.navigationController presentViewController:nc animated:YES completion:^{
        
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
