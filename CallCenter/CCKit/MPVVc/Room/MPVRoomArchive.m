//
//  MPVRoomArchive.m
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "MPVRoomArchive.h"
#import "KandyAdpter.h"

@implementation MPVRoomArchive

+(NSMutableArray *)read;
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[MPVRoomArchive filePath]]){
        return [NSMutableArray array];
    }
    
    NSMutableArray *retArr = [[NSMutableArray alloc] initWithCapacity:10];
    NSArray *arr = [NSArray arrayWithContentsOfFile:[MPVRoomArchive filePath]];
    for (NSDictionary *dic in arr) {
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            [retArr addObject:[MPVRoomModel decodeDic:dic]];
        }
    }
    
    return retArr;
}

+(BOOL)appendSave:(MPVRoomModel *)smv;
{
    NSMutableArray *curArr = [MPVRoomArchive read];
    NSMutableArray *retArr = [[NSMutableArray alloc] initWithCapacity:10];
    BOOL isFind = NO;
    for (MPVRoomModel *mv in curArr) {
        if (mv && [mv isKindOfClass:[MPVRoomModel class]]) {
            if (smv && [smv.roomId isEqualToString:mv.roomId]) {
                isFind = YES;
                mv.roomState = smv.roomState;
            }
            [retArr addObject:[MPVRoomModel encodeDic:mv]];
        }
    }
    
    if (!isFind) {
        [retArr insertObject:[MPVRoomModel encodeDic:smv] atIndex:0];
    }
    BOOL retBl = [retArr writeToFile:[MPVRoomArchive filePath] atomically:YES];
    KDALog(@" appendSave retBl == %d",retBl);

    return retBl;
}


+(BOOL)delMv:(MPVRoomModel *)smv;
{
    NSMutableArray *curArr = [MPVRoomArchive read];
    NSMutableArray *retArr = [[NSMutableArray alloc] initWithCapacity:10];
    for (MPVRoomModel *mv in curArr) {
        if (mv && [mv isKindOfClass:[MPVRoomModel class]]) {
            if (smv && [smv.roomId isEqualToString:mv.roomId]) {
                continue;
            }
            [retArr addObject:[MPVRoomModel encodeDic:mv]];
        }
    }
    
    BOOL retBl = [retArr writeToFile:[MPVRoomArchive filePath] atomically:YES];
    KDALog(@" appendSave retBl == %d",retBl);
    
    return retBl;
}


+(NSString *)filePath
{
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDir,@"file.dt"];
    
    return filePath;
}

@end
