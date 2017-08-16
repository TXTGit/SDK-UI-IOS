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
#import <AVFoundation/AVFoundation.h>

#import "KandyCallServiceEnums.h"

@interface KandyCallServiceSettings : NSObject

/**
 *  The default camera position when initiating video (on call start or during call). Default value is EKandyCameraPosition_front
 */
@property (nonatomic, assign) EKandyCameraPosition defaultCameraPosition;

/**
 *  The default camera resolution when initiating video call - default value is AVCaptureSessionPreset640x480
 */
@property (nonatomic, assign) NSString* defaultVideoResolution;

/**
 *  The camera orienation support (while video call). Default value is EKandyCameraOrientationSupport_statusBar
 */
@property (nonatomic, assign) EKandyCameraOrientationSupport cameraOrientationSupport;

/**
 *  Should the incoming call be automatically rejected incase already in GSM call. Default value is YES
 */
@property (nonatomic, assign) BOOL shouldRejectIncomingCallsWhileInGSMCall;

/**
 *  YES if the call termination events are being sent by push
 */
@property (assign, nonatomic) BOOL isCallTerminationPushEnabled;

/**
 KandySDK in CallKit mode will not manage VoIP calls. You'll be reponsibile to decline/hold or make any other actions on VoIP calls depending the state of incoming or active GSM calls. This will allow you to implement any logic needed to support your own behaviour. When you set enableCallKitMode to YES, this will also force useManualAudio set to YES.
 */
@property (nonatomic, assign, getter=isCallKitModeEnabled) BOOL enableCallKitMode;
/**
 * Default category of AudioSession. This property takes effect only if enableCallKitMode is NO. When CallKit mode is enabled, you are responsible to setup and propogate audio session properties
 */
@property (nonatomic, strong) NSString *audioSessionCategory;

/**
 * Default category options of AudioSession. This property takes effect only if enableCallKitMode is NO. When CallKit mode is enabled, you are responsible to setup and propogate audio session properties
 */
@property(nonatomic, assign) AVAudioSessionCategoryOptions audioSessionCategoryOptions;

/**
 * Default mode of AudioSession. This property takes effect only if enableCallKitMode is NO. When CallKit mode is enabled, you are responsible to setup and propogate audio session properties
 */
@property (nonatomic, strong) NSString *audioSessionMode;
/**
 Enable manual audio mode. This property is forced to YES when enableCallKitMode is YES. When useManualAudio is YES, KandySDK will not activate audio when the call starts, and will not deactivate audio when the call ends. Use manual audio when you need to stop audio recording so you can play video etc. meanwhile.
 */
@property (nonatomic, assign, getter=isUsingManualAudio) BOOL useManualAudio;
/**
 Enable or disable audio engine. This property takes effect only if useManualAudio is YES. When CallKit mode is enabled, you must manually activate audio when the call starts, to enable audio recording, and deactivate audio when the call ends.
 */
@property (nonatomic, assign, getter=isAudioEnabled) BOOL audioEnabled;

@end
