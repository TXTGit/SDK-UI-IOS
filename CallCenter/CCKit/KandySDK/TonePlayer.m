//
//  TonePlayer.m
//  tvc
//
//  Created by aiquantong on 5/23/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "TonePlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


static TonePlayer  *shareInstance = nil;

@interface TonePlayer()<AVAudioPlayerDelegate>

@end

@implementation TonePlayer


- (instancetype)init
{
  self = [super init];
  if (self) {
    shareInstance = self;
  }
  return self;
}


+(BOOL)getKeyVal:(NSString *)key
{
  bool isBool;
  id ob = [KandyAdpter getValFormKey:key];
  if(ob == nil){
    isBool = YES;
  }else{
    isBool = [ob boolValue];
  }
  return isBool;
}


static SystemSoundID sound;


+(void)startTonePlayerWithOneTime
{
  bool isVibrate = YES;
  
  bool isToning = YES;
  
  if (isVibrate) {
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  }
  
  if (isToning) {
    if (!sound) {
      
      NSString *path = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"m4r"];
      BOOL re = [[NSFileManager defaultManager]fileExistsAtPath:path];
      
      if (path && re) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error != kAudioServicesNoError) {
          sound = 0;
        }else{
          KDALog(@"AudioServicesCreateSystemSoundID == %d", (int)error);
        }
      }else{
        KDALog(@"fileExistsAtPath == %d",re);
      }
    }
    
    if (sound) {
      AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, soundOneTimeAudioCallback, NULL);
      AudioServicesPlaySystemSound(sound);
    }
  }
}



+(void)startTonePlayer
{
  bool isVibrate = YES;
  
  bool isToning = YES;
  
  if (isVibrate) {
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  }
  
  if (isToning) {
    if (!sound) {
        
      NSString *path = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"m4r"];
      BOOL re = [[NSFileManager defaultManager]fileExistsAtPath:path];
      
      if (path && re) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error != kAudioServicesNoError) {
          sound = 0;
        }else{
          KDALog(@"AudioServicesCreateSystemSoundID == %d", (int)error);
        }
      }else{
        KDALog(@"fileExistsAtPath == %d",re);
      }
    }
    
    if (sound) {
      AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, soundAudioCallback, NULL);
      AudioServicesPlaySystemSound(sound);
    }
  }
}


void systemAudioCallback()
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

void soundAudioCallback()
{
  AudioServicesPlaySystemSound(sound);
}


void soundOneTimeAudioCallback()
{
  bool isVibrate = YES;
  bool isToning = YES;
  
  if (isVibrate) {
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
  }
  
  if (isToning && sound) {
    AudioServicesRemoveSystemSoundCompletion(sound);
    AudioServicesDisposeSystemSoundID(sound);
    sound = 0;
  }
}


+(void)stopTonePlayer
{
  bool isVibrate = YES;
  
   bool isToning = YES;
  
  if (isVibrate) {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
  }
  
  if (isToning && sound) {
    AudioServicesRemoveSystemSoundCompletion(sound);
    AudioServicesDisposeSystemSoundID(sound);
    sound = 0;
  }
  
}


static AVAudioPlayer *ringAudioPlayer;


+(void)startRingSound:(RING_TYPE)ringType
{
  if (!ringAudioPlayer) {
    [ringAudioPlayer pause];
    [ringAudioPlayer stop];
    ringAudioPlayer = nil;
  }
    
  NSString *path = [[NSBundle mainBundle] pathForResource:RINGTYPEARR[ringType] ofType:@"m4r"];
  NSURL *url = [NSURL fileURLWithPath:path];
  NSError *error=nil;
  
  ringAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];

  ringAudioPlayer.numberOfLoops = NSIntegerMax;
  [ringAudioPlayer prepareToPlay];
  if(error){
    KDALog(@"initWithContentsOfURL:%@",error.localizedDescription);
    return;
  }
  
  AVAudioSession *audioSession=[AVAudioSession sharedInstance];
  
  [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
  if(error){
    KDALog(@"AVAudioSessionCategoryPlayback:%@",error.localizedDescription);
  }
  [audioSession setActive:YES error:&error];
  if(error){
    KDALog(@"setActive:%@",error.localizedDescription);
  }
  
  if (![ringAudioPlayer isPlaying]) {
    [ringAudioPlayer play];
  }
}



+(void)stopRingSound
{
  if ([ringAudioPlayer isPlaying]) {
    [ringAudioPlayer pause];
    [ringAudioPlayer stop];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
  }
}


static AVAudioPlayer *overAudioPlayer = nil;

+(void)startOverSound:(RING_TYPE)ringType {
  
  if (!overAudioPlayer) {
    [overAudioPlayer pause];
    [overAudioPlayer stop];
    overAudioPlayer = nil;
  }
  
  //NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received5",@"caf"];
  NSString *path = [[NSBundle mainBundle] pathForResource:RINGTYPEARR[ringType] ofType:@"m4r"];
  NSURL *url = [NSURL fileURLWithPath:path];
  NSError *error = nil;
  
  overAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
  //设置播放器属性
  overAudioPlayer.numberOfLoops = 0;//设置为0不循环
  [overAudioPlayer prepareToPlay];//加载音频文件到缓存
  overAudioPlayer.delegate = shareInstance;
  if(error){
    KDALog(@"initWithContentsOfURL:%@",error.localizedDescription);
    return;
  }
  
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
  if(error){
    KDALog(@"AVAudioSessionCategoryPlayback:%@",error.localizedDescription);
  }
  [audioSession setActive:YES error:&error];
  if(error){
    KDALog(@"setActive:%@",error.localizedDescription);
  }
  
  if (![overAudioPlayer isPlaying]) {
    [overAudioPlayer play];
  }
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
  
  if (overAudioPlayer) {
    [overAudioPlayer pause];
    [overAudioPlayer stop];
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
    overAudioPlayer = nil;
  }
  
}


@end





