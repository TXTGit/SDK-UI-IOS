//
//  MPVRoomModel.m
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "MPVRoomModel.h"

@implementation MPVRoomModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.conferenceId = @"";
        self.roomId = @"";
        self.roomState = RoomState_Unknown;
    }
    return self;
}

-(NSString *)roomStateStr;
{
    switch (self.roomState) {
        case RoomState_Unknown:
        {
            return @"未知";
        }
            break;
            
        case RoomState_Run:
        {
            return @"进行中";
        }
            break;
            
        case RoomState_Over:
        {
            return @"结束";
        }
            break;
            
        default:
            break;
    }
}


+(MPVRoomModel *)decodeDic:(NSDictionary *)dic
{
    MPVRoomModel *mp = [[MPVRoomModel alloc] init];
    if (dic == nil) {
        return mp;
    }
    
    mp.conferenceId = [dic objectForKey:@"conferenceId"];
    mp.roomId = [dic objectForKey:@"roomId"];
    mp.roomState = [[[dic objectForKey:@"roomState"] description] integerValue];
    
    return mp;
}


+(NSMutableDictionary *)encodeDic:(MPVRoomModel *)mv
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:10];
    if (mv == nil) {
        return dic;
    }
    
    [dic setObject:mv.conferenceId forKey:@"conferenceId"];
    [dic setObject:mv.roomId forKey:@"roomId"];
    [dic setObject:@(mv.roomState) forKey:@"roomState"];

    return dic;
}


@end


