/*
 * Copyright 2015 © GENBAND US LLC, All Rights Reserved
 * This software embodies materials and concepts which are
 * proprietary to GENBAND and/or its licensors and is made
 * available to you for use solely in association with GENBAND
 * products or services which must be obtained under a separate
 * agreement between you and GENBAND or an authorized GENBAND
 * distributor or reseller.
 
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
 * AND/OR ITS LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * THE WARRANTY AND LIMITATION OF LIABILITY CONTAINED IN THIS
 * AGREEMENT ARE FUNDAMENTAL PARTS OF THE BASIS OF GENBAND’S BARGAIN
 * HEREUNDER, AND YOU ACKNOWLEDGE THAT GENBAND WOULD NOT BE ABLE TO
 * PROVIDE THE PRODUCT TO YOU ABSENT SUCH LIMITATIONS.  IN THOSE
 * STATES AND JURISDICTIONS THAT DO NOT ALLOW CERTAIN LIMITATIONS OF
 * LIABILITY, GENBAND’S LIABILITY SHALL BE LIMITED TO THE GREATEST
 * EXTENT PERMITTED UNDER APPLICABLE LAW.
 
 * Restricted Rights legend:
 * Use, duplication, or disclosure by the U.S. Government is
 * subject to restrictions set forth in subdivision (c)(1) of
 * FAR 52.227-19 or in subdivision (c)(1)(ii) of DFAR 252.227-7013.
 */

#import "CustomSDKLogger.h"
#import "KandyAdpter.h"


@interface CustomSDKLogger()
{
    dispatch_queue_t logqueue;
}
@end

@implementation CustomSDKLogger

#define kLogFilderName @"log"
#define kLogFileName @"Log.TXT"
#define kOldLogFileName @"oldLog.TXT"
#define kSwapFileSize 1024 * 1024 * 10

@synthesize loggingFormatter;


-(id)initWithFormatter:(id<KandyLoggingFormatterProtocol>)formatter
{
    self = [super init];
    if (self)
    {
        logqueue = dispatch_queue_create("com.mcc.logQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(logqueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
        [self resetLogFile];
        self.loggingFormatter = formatter;
    }
    return self;
}


#pragma mark - Public

-(NSString *)getRootLogPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *rootLogPath = [documentsDirectory stringByAppendingPathComponent:kLogFilderName];
    
    BOOL isDir = NO;
    NSError *error = nil;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:rootLogPath isDirectory:&isDir];
    if (isExist && isDir) {
        
    }else{
        BOOL isCreate = [[NSFileManager defaultManager] createDirectoryAtPath:rootLogPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (isCreate) {
            NSLog(@"create root log  error === %@", [error description]);
        }
    }
    return rootLogPath;
}


-(void)resetLogFile
{
    NSString *rootLogPath = [self getRootLogPath];
    dispatch_async(logqueue, ^{
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",rootLogPath, kLogFileName];
        
        BOOL isDir = NO;
        NSError *error = nil;
        BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
        
        if (isExit && !isDir) {
            unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error] fileSize];
            
            if (error!= nil) {
                NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
                return;
            }
            
            if (fileSize > kSwapFileSize) {
                NSString *oldFilePath = [NSString stringWithFormat:@"%@/%@",rootLogPath, kOldLogFileName];
                BOOL isOldDir = NO;
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:oldFilePath isDirectory:&isOldDir]){
                    if (!isDir) {
                        [[NSFileManager defaultManager] removeItemAtPath:oldFilePath error:&error];
                        
                        if (error!= nil) {
                            NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
                            return;
                        }
                    }
                }
                [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:oldFilePath error:&error];
                if (error!= nil) {
                    NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
                    return;
                }
            }else{
                
            }
        }else{
            
        }
    });
    
    KDALog(@"rootLogPath === %@", rootLogPath);
    NSString *startContents = @"\n\n\n===startLogFile===\n";
    [self logWithLevel:EKandyLogLevel_info andLogString:startContents];
}


-(NSData*)getLogFileData{
    NSString *rootLogPath = [self getRootLogPath];
    NSString *txtFilePath = [rootLogPath stringByAppendingPathComponent:kLogFileName];
    NSData *logData = [NSData dataWithContentsOfFile:txtFilePath];
    return logData;
}


-(NSData*)getOldLogFileData{
    NSString *rootLogPath = [self getRootLogPath];
    NSString *txtFilePath = [rootLogPath stringByAppendingPathComponent:kOldLogFileName];
    NSData *logData = [NSData dataWithContentsOfFile:txtFilePath];
    return logData;
}


-(void)cleanLogFile
{
    NSString *rootLogPath = [self getRootLogPath];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",rootLogPath, kLogFileName];
    
    NSError *error = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        BOOL isOk = [[NSFileManager defaultManager] removeItemAtPath:fileName error:&error];
        NSLog(@"cleanLogFile path == %@  error == %@", fileName, [error description]);
        if (isOk) {
            NSString *fileContent = [NSString stringWithFormat:@"===cleanLogFile===\nkandy version === %@\n\n", [Kandy sharedInstance].version];
            [self logWithLevel:EKandyLogLevel_info andLogString:fileContent];
        }
    }
    
    NSString *oldfileName = [NSString stringWithFormat:@"%@/%@",rootLogPath, kOldLogFileName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:oldfileName]){
        [[NSFileManager defaultManager] removeItemAtPath:oldfileName error:&error];
        NSLog(@"cleanLogFile oldfileName == %@  error == %@", oldfileName, [error description]);
    }
    
}



#pragma mark - KandyLoggerProtocol

-(void)logWithLevel:(EKandyLogLevel)level andLogString:(NSString *)logString{
    
    dispatch_async(logqueue, ^{
        
        NSString *rootLogPath = [self getRootLogPath];
        NSString *fileName = [rootLogPath stringByAppendingPathComponent:kLogFileName];
        
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
        if (!isExist) {
            NSError *error = nil;
            [logString writeToFile:fileName atomically:NO encoding:NSASCIIStringEncoding error:&error];
            
            if (error!= nil) {
                NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
                return;
            }
        }else{
            NSFileHandle *fh = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
            [fh seekToEndOfFile];
            NSString *logContact = [NSString stringWithFormat:@"%@\n", logString];
            NSData *logdata = [logContact dataUsingEncoding:NSASCIIStringEncoding];
            [fh writeData:logdata];
            [fh synchronizeFile];
            [fh closeFile];
        }
    });
}

-(void)testPerformance
{
    int max  = 1024*64;
    for (int i = 0 ; i < max; i++) {
        KDALog(@"%d - %.5f",i, [[NSDate date] timeIntervalSince1970]);
    }
    KDALog(@"end log");
}

@end







