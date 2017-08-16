//
//  TonePlayer.h
//  tvc
//
//  Created by aiquantong on 5/23/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KandyAdpter.h"


typedef NS_ENUM(NSInteger, RING_TYPE) {
  RING_TYPE_CONNECTING = 0,
  RING_TYPE_RING_TONG = 1,
  RING_TYPE_OVER_BUSY = 2,
  RING_TYPE_OVER_HANGUP = 3
};

#define RINGTYPEARR @[@"connecting",@"ringbacktone",@"busytone",@"hangup"]


@interface TonePlayer : NSObject

+(void)startTonePlayerWithOneTime;

+(void)startTonePlayer;

+(void)stopTonePlayer;


+(void)startRingSound:(RING_TYPE)ringType;

+(void)stopRingSound;

+(void)startOverSound:(RING_TYPE)ringType;

@end





