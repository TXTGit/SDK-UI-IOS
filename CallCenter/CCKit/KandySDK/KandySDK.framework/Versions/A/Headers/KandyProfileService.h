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

#import "KandyDeviceProfileParams.h"

@class KandyUserProfile;
@class KandyUserProfileParams;
@class KandyTransferProgress;
@class KandyRecord;

extern NSString * const kKandyProfileUserName;
extern NSString * const kKandyProfileImageAbsolutePath;
extern NSString * const kKandyProfileUserData;

@interface KandyProfileService : NSObject

/**
 *  Get all of the user's device profiles
 *
 *  @param responseCallBack callback that will be called upon completion. Will return an array of KandyDeviceProfile or an error in case of failure
 */
- (void)getUserDeviceProfilesWithResponseCallback:(void(^)(NSError* error, NSArray* userDeviceProfiles))responseCallBack;

/**
 *  Update the current device profile
 *
 *  @param deviceProfileParams the params to update
 *  @param responseCallBack    callback that will be called upon completion. will return an error incase of failure
 */
- (void)updateDeviceProfile:(KandyDeviceProfileParams*)deviceProfileParams responseCallback:(void(^)(NSError* error))responseCallBack;

/**
 *  Updates current user nickname.
 *
 *  @param aNewUserName     is NSString instance of new nickname. Can be empty string. Cannot be a nil.
 *  @param responseCallback is value of response callback. Can be a nil.
 */
- (void)updateUserName:(NSString *)newUserName responseCallback:(void(^)(NSError *error, KandyUserProfile *userProfile))responseCallback;

/**
 *  Updates current user image (avatar).
 *
 *  @param imageAbsolutePath is NSString instance of image's absolute path. Can be empty string. Cannot be a nil.
 *  @param progressCallback  is uploading image callback. Can be a nil.
 *  @param responseCallback  is response callback. Can be nil.
 */
- (void)updateProfileImage:(NSString *)imageAbsolutePath progressCallback:(void(^)(KandyTransferProgress* transferProgress))progressCallback responseCallback:(void(^)(NSError *error, KandyUserProfile *userProfile))responseCallback;

/**
 Updates custom data stored within user profile
 
 @param newUserData      newUserData dictionary containig custom data that app can story within user profile. Must contain only generic data types: NSString, NSNumber, NSData, NSArray, NSDictionary
 @param responseCallback the response callback
 */
- (void)updateUserData:(NSDictionary *)newUserData responseCallback:(void (^)(NSError *error, KandyUserProfile *userProfile))responseCallback;

/**
 *  Updates current user profile - both nickname and image (avatar).
 *  @param profileParams     is NSDictionary instance. Has a keys kKandyProfileUserName and kKandyProfileImageAbsolutePath. Also params can include optional kKandyProfileUserData which must be an NSDictionary of generic JSON compatible objects: NSString, NSNumber, NSData, NSArray, NSDictionary. Cannot be nil.
 *  @param progressCallback  is uploading image callback. Can be a nil.
 *  @param responseCallback  is response callback. Can be a nil.
 */
- (void)updateUserProfile:(NSDictionary *)profileParams progressCallback:(void(^)(KandyTransferProgress* transferProgress))progressCallback responseCallback:(void(^)(NSError *error, KandyUserProfile *userProfile))responseCallback;

/**
 *  Removes current user image (avatar).
 *
 *  @param responseCallBack is responce callback. Can be nil.
 */
- (void)removeProfileImageWithResponseCallback:(void(^)(NSError *error, KandyUserProfile *userProfile))responseCallback;

/**
 *  Getting profile of current user.
 *
 *  @param responseCallback is response callback. Can be nil.
 */
- (void)getProfileWithResponseCallback:(void(^)(NSError *error, KandyUserProfile *userProfile))responseCallback;

/**
 *  Getting profile by specified contact.
 *
 *  @param contactId        is KandyRecord instance. Cannot be a nil.
 *  @param responseCallback is response callback. Can be nil.
 */
- (void)getProfileByContactId:(KandyRecord *)contactId responseCallback:(void(^)(NSError* error, KandyUserProfile *userProfile))responseCallback;


@end
