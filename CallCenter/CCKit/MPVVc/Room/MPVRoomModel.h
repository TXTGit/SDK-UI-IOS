//
//  MPVRoomModel.h
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RoomState){
    RoomState_Unknown = 0,
    RoomState_Run = 1,
    RoomState_Over = 2
};

@interface MPVRoomModel : NSObject

@property (nonatomic,strong) NSString* conferenceId;

@property (nonatomic,strong) NSString* roomId;

@property (nonatomic,assign) RoomState roomState;

-(NSString *)roomStateStr;

+(MPVRoomModel *)decodeDic:(NSDictionary *)dic;

+(NSMutableDictionary *)encodeDic:(MPVRoomModel *)mv;

@end



