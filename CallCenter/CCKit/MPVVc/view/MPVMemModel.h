//
//  MPVMemModel.h
//  SDKDemo
//
//  Created by aiquantong on 25/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KandySDK/KandySDK.h>

@interface MPVMemModel : NSObject

@property (nonatomic, strong) id<KandyMultiPartyConferenceParticipantProtocol> participant;

@property (nonatomic, assign) BOOL isShowOp;

@property (nonatomic, assign) BOOL isAdmin;

@end
