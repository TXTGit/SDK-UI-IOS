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

@interface KandyContentCollectionItem : NSObject

/**
 The UUID of the content
 */
@property (readonly, nonnull) NSString * contentUUID;

/**
 Metadta associated witht the content
 */
@property (readonly, nonnull) NSDictionary * metadata;

/**
 Use method: initWithContentUUID:metadata:
 */
-(null_unspecified instancetype)init NS_UNAVAILABLE;

/**
 Initialize collection item with specified parameters

 @param contentUUID The UUID of the contnent
 @param metadata Metadata associated with the content
 
 @return Initialized instance if collection item class 
 */
-(null_unspecified instancetype)initWithContentUUID:(nonnull NSString*)contentId metadata:(nonnull NSDictionary*)metadata;

@end
