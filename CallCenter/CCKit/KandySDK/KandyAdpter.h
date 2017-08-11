//
//  KandyAdpter.h
//  AwesomeProject
//
//  Created by aiquantong on 5/10/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KandySDK/KandySDK.h>

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

static BOOL is_kandy_console_debug = YES;

#define KDALog(fmt, ...) if(is_kandy_console_debug){ NSLog((@"%s [Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}   [[Kandy sharedInstance].loggingInterface logWithLevel:EKandyLogLevel_info andLogString:[[NSString alloc] initWithFormat:(@"AppLog %@ %s [Line %d]" fmt), [KandyAdpter getDateFromate:[NSDate date] dateFromat:@"YYYY-MM-DD HH:MM:SS"], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]];

#define Kandy_Host_Url  @"https://api.kandycn.com"


typedef void(^KandyCallback)(NSError *error);
typedef void(^KandyArrCallback)(NSError *error, NSArray *arr);

@interface KandyAdpter : NSObject

+ (KandyAdpter *)shareInstance;

-(void)initKandySDKWithKey:(NSString *)key secret:(NSString *)secret;

-(void)reinitKandySDK;

+(UIViewController *)getRootViewController;

+(void) saveKey:(NSString *)key Value:(NSString*)val;

+(NSString *)getValFormKey:(NSString *)key;

+(NSString *)getDateFromate:(NSDate *)date dateFromat:(NSString *)dateFromat;

+(NSString *)getTimeFromate:( NSTimeInterval) interval;

@end


