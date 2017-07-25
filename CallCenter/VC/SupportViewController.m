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

-(IBAction)onclickCall:(id)sender
{
    [CCKitManger callWithIsPstn:NO
     isWithVideo:self.switchVideo.isOn
     callee:self.iphoneTxt.text
     callback:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!error) {
                 CCCallViewController *cccall = [[CCCallViewController alloc] initWithNibName:@"CCCallViewController" bundle:nil];
                 [self.navigationController presentViewController:cccall animated:YES completion:NULL];
             }else{
                 
             }
         });
     }];
}


-(IBAction)onclickMPVStart:(id)sender
{
    CCMPVRoomListViewController *cccall = [[CCMPVRoomListViewController alloc] initWithNibName:@"CCMPVRoomListViewController" bundle:nil];
    [self.navigationController pushViewController:cccall animated:YES];
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
