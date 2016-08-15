//
//  MMEditorDetailController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMEditorDetailController.h"
#import "MMEditor.h"
@interface MMEditorDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (assign,nonatomic,getter=isLoad)BOOL load;
@end

@implementation MMEditorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mm_header.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    self.webView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    if (self.editor.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/editor/%d/profile-page/ios",self.editor.id]]]];
    }
}

-(void)setEditor:(MMEditor *)editor{
    _editor = editor;
    
    self.title = editor.name;
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString hasPrefix:@"http://news-at.zhihu.com/api/4/editor/"]) {
        return YES;
    }else{
        
//        if ([request.URL.absoluteString hasPrefix:@"mailto:"]) {
//            NSRange range = [request.URL.absoluteString rangeOfString:@"mailto:"];
//            NSString *str = [request.URL.absoluteString substringFromIndex:range.length + range.location];
//            MMLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",str]]);
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",str]]];
//        }else{
            [[UIApplication sharedApplication]openURL:request.URL];
//        }
        
        
        return NO;
    }
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.indicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.indicatorView stopAnimating];
}


@end
