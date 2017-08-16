//
//  CustomLogViewController.m
//  tvc
//
//  Created by aiquantong on 2/28/17.
//  Copyright © 2017 genband. All rights reserved.
//

#import "CustomLogViewController.h"
#import "CustomSDKLogger.h"

#import <MessageUI/MessageUI.h>
#import "UIAlertUtil.h"


@interface CustomLogViewController ()<UISearchBarDelegate, UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSArray *mMatch;
    int mMatchIndex;
    
    MFMailComposeViewController *mailVC;
}

@property (strong, nonatomic) IBOutlet UITextView *txtView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation CustomLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"日志";
    
    mMatch = [NSArray array];
    mMatchIndex = 0;
    
    UIBarButtonItem *lf = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoback:)];
    self.navigationItem.leftBarButtonItem = lf;
    
    UIBarButtonItem *rf = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = rf;
    
#ifdef __IPHONE_7_0
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
#endif
    
    if ([Kandy sharedInstance].loggingInterface &&
        [[Kandy sharedInstance].loggingInterface respondsToSelector:@selector(getLogFileData)]) {
        
        NSData *dt = [(CustomSDKLogger *)[Kandy sharedInstance].loggingInterface getLogFileData];
        self.txtView.text = [[NSString alloc] initWithData:dt encoding:NSASCIIStringEncoding];
    };
}


-(IBAction)onclickPerformance:(id)sender
{
    [(CustomSDKLogger *)[Kandy sharedInstance].loggingInterface testPerformance];
    [UIAlertUtil showAlertWithTitle:@"提示"
                            message:@"测试已经完成"
              persentViewController:self];
}

-(IBAction)clear:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Attach an image to the email
        if ([Kandy sharedInstance].loggingInterface &&
            [[Kandy sharedInstance].loggingInterface respondsToSelector:@selector(cleanLogFile)]) {
            [(CustomSDKLogger *)[Kandy sharedInstance].loggingInterface cleanLogFile];
        };
        
        if ([Kandy sharedInstance].loggingInterface &&
            [[Kandy sharedInstance].loggingInterface respondsToSelector:@selector(getLogFileData)]) {
            
            NSData *dt = [(CustomSDKLogger *)[Kandy sharedInstance].loggingInterface getLogFileData];
            self.txtView.text = [[NSString alloc] initWithData:dt encoding:NSASCIIStringEncoding];
        };
        
    });
}


-(IBAction)next:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self.txtView select:self];
    if (mMatchIndex + 1 < [mMatch count]) {
        mMatchIndex++;
        NSTextCheckingResult *res = [mMatch objectAtIndex:mMatchIndex];
        [self.txtView setSelectedRange:res.range];
    }
}

-(IBAction)previous:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self.txtView select:self];
    if (mMatchIndex > 0) {
        mMatchIndex--;
        NSTextCheckingResult *res = [mMatch objectAtIndex:mMatchIndex];
        [self.txtView setSelectedRange:res.range];
    }
}


- (void)textViewDidChangeSelection:(UITextView *)textView;
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    NSLog(@"searchBarSearchButtonClicked  = %@", searchBar.text);
    [searchBar resignFirstResponder];
    NSString *keyword = searchBar.text;
    
    if (keyword && ![keyword isEqualToString:@""]) {
        NSError  *err = nil;
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:keyword options:NSRegularExpressionIgnoreMetacharacters error:&err];
        
        if (!err) {
            NSArray *match = [reg matchesInString:self.txtView.text options:NSMatchingReportProgress range:NSMakeRange(0, self.txtView.text.length)];
            if (match) {
                mMatch = match;
                mMatchIndex = 0;
                
                if ([match count] > 0) {
                    NSTextCheckingResult *res = [mMatch objectAtIndex:mMatchIndex];
                    [self.txtView select:self];
                    self.txtView.selectedRange = res.range;
                }
                
            }
        }
    }
}


-(void)gotoback:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)rightAction:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([MFMailComposeViewController canSendMail] == YES) {
            
            mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            
            [mailVC setSubject:@"app run log"];
            
            NSArray *toRecipients = [NSArray arrayWithObject:@"Ai.Quantong@genband.com"];
            [mailVC setToRecipients:toRecipients];
            
            // Attach an image to the email
            NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
            NSString *app_id = [[NSBundle mainBundle] bundleIdentifier];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
            
            NSString *app_info = [NSString stringWithFormat:@"bundleIdentifier:%@\n appVersion:%@-%@",app_id,app_Version,app_build];
            
            [mailVC setMessageBody:[NSString stringWithFormat:@"HI, the attachment is app run log \n appinfo: %@",app_info] isHTML:NO];
            
            if ([Kandy sharedInstance].loggingInterface) {
                NSData *myData = [(CustomSDKLogger *)[Kandy sharedInstance].loggingInterface getLogFileData];
                [mailVC addAttachmentData:myData mimeType:@"text/html" fileName:@"log.TXT"];
            }
            
            [self presentViewController:mailVC animated:YES completion:NULL];
        }else{
            [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"请先配置邮箱客户端！" persentViewController:self];
        }
    });
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    int isSendOK = 1;
    
    switch (result) {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultFailed:
            isSendOK = 1;
            [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"邮件发送失败" persentViewController:self];
            break;
            
        case MFMailComposeResultSent:
            isSendOK = 0;
            [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"邮件发送成功" persentViewController:self];
            break;
            
        default:
            break;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
