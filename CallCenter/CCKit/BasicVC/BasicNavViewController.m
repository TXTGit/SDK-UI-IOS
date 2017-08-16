//
//  BasicNavViewController.m
//  LSupport
//
//  Created by aiquantong on 4/20/17.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "BasicNavViewController.h"
#import "AppDelegate.h"


@interface BasicNavViewController ()

@end

@implementation BasicNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIViewController *)realVisibleViewController
{
    UIViewController *vc = self.visibleViewController;
    if (vc.childViewControllers && [vc.childViewControllers count] > 0) {
        vc = [vc.childViewControllers firstObject];
    }
    
    if (self.presentedViewController) {
        vc = self.presentedViewController;
    }
    
    return vc;
}

- (BOOL)shouldAutorotate
{
    return [[self realVisibleViewController] shouldAutorotate];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self realVisibleViewController] supportedInterfaceOrientations];
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self realVisibleViewController] preferredInterfaceOrientationForPresentation];
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
