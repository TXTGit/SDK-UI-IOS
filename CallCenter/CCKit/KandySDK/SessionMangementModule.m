//
//  SessionMangementModel.m
//  SDKDemo
//
//  Created by aiquantong on 28/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "SessionMangementModule.h"

@implementation SessionMangementModule

+(NSString *)sessionPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *rootLogPath = [documentsDirectory stringByAppendingPathComponent:@"user"];
    KDALog(@"sessionManagement rootLogPath === %@",rootLogPath);
    return rootLogPath;
}

+(NSError*)saveCurrentSession;
{
    return [[Kandy sharedInstance].sessionManagement saveToPath:[SessionMangementModule sessionPath]];
}


+(KandySession*)getSavedSessionData;
{
    return [KandySessionManagement getSavedSessionDataFromPath:[SessionMangementModule sessionPath]];
}


+(BOOL)removeSaveSession;
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExit = [fm fileExistsAtPath:[SessionMangementModule sessionPath] isDirectory:&isDir];
    if (isExit) {
        NSError *error = nil;
        [fm removeItemAtPath:[SessionMangementModule sessionPath] error:&error];
        KDALog(@"removeSaveSession == %@", [error description]);
        return error?NO:YES;
    }else{
        return YES;
    }

}

@end
