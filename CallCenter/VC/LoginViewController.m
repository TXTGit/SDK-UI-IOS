//
//  LoginViewController.m
//  CallCenter
//
//  Created by aiquantong on 8/8/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "LoginViewController.h"
#import "SupportViewController.h"

#import "../CCKit/3rdParty/Toast/UIView+Toast.h"
#import "Utils.h"
#import "CCKitManger.h"

@interface LoginViewController ()
{
    NSDate *startDate;
    NSTimer *timer;
}


@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UIView *phoneView;

@property (nonatomic, strong) IBOutlet UITextField *smsTextField;
@property (nonatomic, strong) IBOutlet UIView *smsView;

@property (nonatomic, strong) IBOutlet UIButton *sendSmsButton;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.phoneView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.smsView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 登录

 @param sender xib指向
 */
-(IBAction)login:(id)sender
{
    [Utils showHUDOnWindowWithText:@"正在登录.."];
    [CCKitManger
     loginKandyWithUserName:self.phoneTextField.text
     password:self.smsTextField.text
     callback:^(NSError *error) {
         [Utils hideHUDForWindow];
         if (error) {
             [self.view makeToast:[error description]];
         }else{
             SupportViewController *mvc = [[SupportViewController alloc] initWithNibName:@"SupportViewController" bundle:nil];
             [self.navigationController setViewControllers:@[mvc] animated:YES];
         }
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
