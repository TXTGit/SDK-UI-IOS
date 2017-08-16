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

#import <KandySDK/KandySDK.h>

@interface KandyReadAck : KandyBaseEvent <NSCopying>

/**
 *  EKandyChatMessageAckErrorType_none or an Ack error
 */
@property (readonly) EKandyChatMessageAckErrorType errorType;

/**
 *  Init a KandyReadAck Object
 *
 *  @param anUuid       The message UUID to Ack
 *  @param aTimestamp   Time of Acking
 *  @param anError      EKandyChatMessageAckErrorType_none or an Ack error
 *  @param anOrigin     The origin of the event
 *
 *  @return A new KandyDeliveryAck instance
 */
-(instancetype)initWithUUID:(NSString*)anUuid timeStamp:(NSDate*)aTimestamp errorType:(EKandyChatMessageAckErrorType)anError origin:(EKandyEventOrigin)anOrigin;

@end
