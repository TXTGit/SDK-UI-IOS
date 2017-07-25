//
//  LoginViewController.m
//  CallCenter
//
//  Created by aiquantong on 8/8/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "LoginViewController.h"
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

-(void)startTimer
{
    startDate = [NSDate date];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCallback:) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)stopTimer
{
    if (timer) {
        [timer invalidate];
    }
    timer = nil;
}

-(void)timeCallback:(id)sender
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startDate];
    
    [self.sendSmsButton setTitle:[NSString stringWithFormat:@"%dS",(int)timeInterval] forState:UIControlStateNormal];
    if (timeInterval > 60) {
        [self stopTimer];
        
    }
}


-(IBAction)login:(id)sender
{
    [Utils showHUDOnWindowWithText:@"正在登录.."];
    [CCKitManger loginKandyWithUserName:self.phoneTextField.text
     password:self.smsTextField.text
     callback:^(NSError *error) {
         [Utils hideHUDForWindow];
         if (error) {
             [self.view makeToast:[error description]];
         }else{
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController setNavigationBarHidden:NO];
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
