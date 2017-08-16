//
//  MPVRoomArchive.h
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPVRoomModel.h"

@interface MPVRoomArchive : NSObject

+(NSMutableArray *)read;

+(BOOL)appendSave:(MPVRoomModel *)arr;

+(BOOL)delMv:(MPVRoomModel *)arr;

@end


