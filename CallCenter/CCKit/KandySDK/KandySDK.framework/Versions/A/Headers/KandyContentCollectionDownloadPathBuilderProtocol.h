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


/**
 Download path builder for content collection service
 */
@protocol KandyContentCollectionsDownloadPathBuilderProtocol <NSObject>

/**
 Download path for content collection items. Default builder path is: Documents/kandy/ContentCollections/Contents
 */
-(nonnull NSString*)downloadAbsolutePathForContentId:(nonnull NSString*)contentId;

/**
 Download path for content collections. Default builder path is: Documents/kandy/ContentCollections/Collections
 */
-(nonnull NSString*)downloadAbsolutePathForCollectionId:(nonnull NSString*)collectionId;

@end
