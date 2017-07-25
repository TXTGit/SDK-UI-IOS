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
#import "KandyAnalyticsEnums.h"
#import "KandyAnalyticsReport.h"

@interface KandyAnalyticsReportingSettings : NSObject

/**
 *  Checks if the report should be sent
 *
 *  @param report Indicates report to be checked
 *
 *  @return Yes for adding event.
 */
-(BOOL) shoulAddReport:(KandyAnalyticsReport *) report;

/**
 *  update report configuration
 *
 *  @param type     define the report (service) EKandyAnalyticsReportType
 *  @param severity define the severity - EKandyReportSeverity
 */
-(void) updateReportType:(EKandyAnalyticsReportType)type severity:(EKandyReportSeverity)severity;

/**
 *  get the severity for specific type
 *
 *  @param type define the report (service) EKandyAnalyticsReportType
 *
 *  @return the severity - EKandyReportSeverity
 */
-(EKandyReportSeverity) getSeverityForReportType:(EKandyAnalyticsReportType)type;

/**
 *  get the severity for specific action
 *
 *  @param action define the report (action) EKandyAnalyticsClientAction
 *
 *  @return everity - EKandyReportSeverity
 */
-(EKandyReportSeverity) getSeverityForReportAction:(EKandyAnalyticsClientAction)action;

/**
 *  define if at the end of call need to send statistics
 */
@property(nonatomic, assign) BOOL shouldSendCallStatistics;

@end
