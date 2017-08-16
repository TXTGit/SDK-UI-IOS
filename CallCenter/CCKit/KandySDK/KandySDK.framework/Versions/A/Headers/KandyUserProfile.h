/*
 * Copyright © 2016 GENBAND. All Rights Reserved.
 *
 * GENBAND CONFIDENTIAL. All information, copyrights, trade secrets
 * and other intellectual property rights, contained herein are the property
 * of GENBAND. This document is strictly confidential and must not be
 * copied, accessed, disclosed or used in any manner, in whole or in part,
 * without GENBAND's express written authorization.
 *
 */

#import <Foundation/Foundation.h>



@class KandyRecord;
@class KandyUserProfileParams;



@interface KandyUserProfile : NSObject

/**
 *  Property represents KandyRecord contact. Cannot be a nil.
 */
@property (nonatomic, readonly, strong) KandyRecord * _Nonnull userContact;

/**
 *  Property represents KandyUserProfileParams profile parameters. Can be nil.
 */
@property (nonatomic, readonly, strong) KandyUserProfileParams * _Nullable userProfileParams;

/**
 *  Default initializer is unavailable
 *
 */
- (instancetype _Null_unspecified)init NS_UNAVAILABLE;

/**
 *  Initializer.
 *
 *  @param userContact       is KandyRecord instance. Cannot be a nil;
 *  @param userProfileParams is KandyUserProfileParams instance. Cannot be a nil;
 *
 *  @return KandyUserProfile instance.
 */
- (instancetype _Nullable)initWithUserContact:(KandyRecord * _Nonnull)userContact userProfileParams:(KandyUserProfileParams * _Nullable)userProfileParams NS_DESIGNATED_INITIALIZER;

@end
