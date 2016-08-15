//
//  MMWebViewController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/14.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMWebViewController.h"

@interface MMWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webVIew;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;

@end

@implementation MMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mm_header.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webVIew.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.webVIew loadRequest:self.request];
    self.webVIew.delegate = self;
}

#pragma mark - IBAction
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)refreshBtnClicked:(id)sender {
    [self.webVIew reload];
    
}
- (IBAction)backBtnClicked:(id)sender {
    [self.webVIew goBack];
}

- (IBAction)forwardBtnClicked:(id)sender {
    [self.webVIew goForward];
}
#pragma mark - updateBtnEnable
-(void)updateBtnEnable{
    self.backBtn.enabled = self.webVIew.canGoBack;
    self.forwardBtn.enabled = self.webVIew.canGoForward;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self updateBtnEnable];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
