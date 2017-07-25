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

@class KandyContentCollectionItem;

@interface KandyContentCollection : NSObject

/**
 The ID of the collection
 */
@property (readonly, nonnull) NSString * collectionId;

/**
 Metadata associated with the collection
 */
@property (readonly, nonnull) NSDictionary * metadata;

/**
 List of content items
 */
@property (readonly, nonnull) NSArray<KandyContentCollectionItem*> * items;

/**
 Use method: initWithCollectionId:metadata:items
 */
-(null_unspecified instancetype)init NS_UNAVAILABLE;

/**
 Initialize content collection class with specified parameters

 @param collectionId The ID of the collection
 @param metadata The metadata assiciated with the collection
 @param collectionItems Collection content items
 
 @return Initialized instance of the content collection class 
 */
-(null_unspecified instancetype)initWithCollectionId:(nonnull NSString*)collectionId metadata:(nonnull NSDictionary*)metadata items:(nonnull NSArray<KandyContentCollectionItem*>*)collectionItems;

@end
