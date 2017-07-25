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
#import "KandyLoggerProtocol.h"

/**
 *  Default logger - prints no NSLog
 */
@interface KandyLogger : NSObject <KandyLoggerProtocol>

/**
 *  Initialization method for the logger
 *
 *  @param formatter the formatter to use inorder to format the log texts
 *
 *  @return initialized KandyLogger object conforms to KandyLoggerProtocol
 */
-(id)initWithFormatter:(id<KandyLoggingFormatterProtocol>)formatter;

@end