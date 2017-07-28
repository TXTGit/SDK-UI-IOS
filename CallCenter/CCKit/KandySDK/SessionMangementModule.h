//
//  SessionMangementModel.h
//  SDKDemo
//
//  Created by aiquantong on 28/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAdpter.h"

@interface SessionMangementModule : NSObject

+(NSError*)saveCurrentSession;

+(KandySession*)getSavedSessionData;

+(BOOL)removeSaveSession;

@end
