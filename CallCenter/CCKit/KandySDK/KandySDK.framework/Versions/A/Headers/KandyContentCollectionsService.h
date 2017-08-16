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

#import "KandyContentCollection.h"
#import "KandyContentCollectionItem.h"
#import "KandyContentCollectionsServiceSettings.h"

@interface KandyContentCollectionsService : NSObject

/**
 Content collecton service settings
 */
@property (nonnull, readonly) KandyContentCollectionsServiceSettings * settings;

/**
 Get all content collections associated with current privisioned user
 
 @param responseCallback The respose callback will return associated collections array or an error
 */
-(void)getAssociatedContentCollectionsWithResponseCallback:(void(^ _Nullable)(NSError * _Nullable error, NSArray<KandyContentCollection*> * _Nullable collections))responseCallback;

/**
 Download file associated with a singe collection item
 
 @brief Downloaded file will be named as ID of the collection item and saved to path provided by downloadPathBuilder from service settings
 
 @param contentUUID The UUID of the collection item
 @param responseCallback The respose callback will return path to downloaded file or an error
 */
-(void)downloadCollectionItemWithContentUUID:(nonnull NSString*)contentUUID responseCallback:(void(^ _Nullable)(NSError * _Nullable error, NSString * _Nullable pathToDownloadedFile))responseCallback;

/**
 Download whole content collection as an archive.
 
 @brief Collection file will be saved to path provided by downloadPathBuilder from service settings. Downloaded file will be .zip archive with the following format:
 
 *----> [package_id] - directory with the name of the package_id
   |
   *----> [metadata.json] - file named "metadata.json" which contains the collection metadata
   |
   *----> [items] - directory called "items" in which each file name is as its content uuid
     |
     *----> [content_id] - file with name of the content_id of first item
     |
     *----> [content_id] - file with name of the content_id of second item
     |
     |
     |      1...N - all items in the collection
     |
     |
     *----> [content_id] - file with name of the content_id of last item
 
 @param collectionId The ID of the content collection to download
 @param responseCallback The respose callback will return path to downloaded archive or an error
 */
-(void)downloadContentCollectionWithCollectionId:(nonnull NSString*)collectionId responseCallback:(void(^ _Nullable)(NSError * _Nullable error, NSString * _Nullable pathToDownloadedArchive))responseCallback;

@end
