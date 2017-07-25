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

@interface KandyUserProfileParams : NSObject

/**
 *  Property represents first name (nickname). Can be nil.
 */
@property (nonatomic, readonly, strong, nullable) NSString * displayName;

/**
 *  Property represents image file UUID. Can be nil.
 */
@property (nonatomic, readonly, strong, nullable) NSString * imageUUID;

/**
 This property represents custom user data that can be stored with profile. userData dictionary is only supports generic JSON compatible objects: NSString, NSNumber, NSData, NSArray and NSDictionary
 */
@property (nonatomic, readonly, strong, nullable) NSDictionary <NSString*, NSObject*> * userData;

/**
 *  Default initializer is unavailable.
 *
 */
- (instancetype _Null_unspecified)new NS_UNAVAILABLE;
- (instancetype _Null_unspecified)init NS_UNAVAILABLE;

/**
 *  Initializer.
 *
 *  @param displayName is NSString instance value. Can be nil.
 *  @param imageUUID   is NSString instance value. Can be nil.
 *
 *  @return KandyUserProfileParams instance.
 */
- (instancetype _Nullable)initWithDisplayName:(NSString * _Nullable)displayName imageUUID:(NSString * _Nullable)imageUUID;

/**
 
 Initialize KandyUserProfileParams object with specific parameters

 @param displayName optional display name
 @param imageUUID   optional image file resource UUID
 @param userData    optional custom user data that can be stored as a part of the profile

 @return an instance of KandyUserProfileParams object
 */
- (instancetype _Nullable)initWithDisplayName:(NSString *_Nullable)displayName imageUUID:(NSString * _Nullable)imageUUID userData:(NSDictionary* _Nullable)userData;

@end
