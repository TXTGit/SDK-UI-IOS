//
//  CCMPVCallViewController.h
//  Haier
//
//  Created by aiquantong on 24/07/2017.
//  Copyright © 2017 aiquantong. All rights reserved.
//

#import "CCBasicViewController.h"

@interface CCMPVCallViewController : CCBasicViewController

@property (nonatomic, strong) NSString *roomNumber;
@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, strong) NSString *nickName;

-(void)showInWindow;

-(void)hiddenInWindow;

@end


