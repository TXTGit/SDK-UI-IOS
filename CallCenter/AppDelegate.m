//
//  AppDelegate.m
//  CallCenter
//
//  Created by aiquantong on 22/6/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SupportViewController.h"

#import "CCKit/KandySDK/ProvisionModule.h"
#import "CCKit/Utils/Utils.h"
#import "CCKitManger.h"

#import "AppDelegate+Push.h"
#import "BasicNavViewController.h"

#import "CCKitManger.h"
#import "SessionMangementModule.h"


@interface AppDelegate ()
{
    
}
@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CCKitManger registerWithKey:@"DAK2af7fc60b41b407d9fbd49ec4226e1a0"
                          secret:@"DAS67fd493180d049948e17789776d5f480"];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self startNotification:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    SupportViewController *mvc = [[SupportViewController alloc] initWithNibName:@"SupportViewController" bundle:nil];
    self.rootNv = [[BasicNavViewController alloc] initWithRootViewController:mvc];
    self.window.rootViewController = self.rootNv;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KandySession *sk = [SessionMangementModule getSavedSessionData];
        if (sk && sk.currentUser) {
            [Utils showHUDOnWindowWithText:@"正在登录.."];
            [CCKitManger loginKandyWithUserName:sk.currentUser.userId password:sk.currentUser.password callback:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils hideHUDForWindow];
                    if (error) {
                        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                        [self.rootNv setViewControllers:@[login] animated:YES];
                    }
                });
            }];
        }else{
            LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.rootNv setViewControllers:@[login] animated:YES];
        }
    });
    
    [self.window makeKeyAndVisible];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
