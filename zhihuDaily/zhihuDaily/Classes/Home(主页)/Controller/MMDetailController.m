//
//  MMDetailController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/1.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMDetailController.h"
#import "MMHomeStoryStoryItem.h"
#import "MMTopView.h"
#import "MMEditor.h"
#import "MMDetailStory.h"
#import "UIImageView+WebCache.h"
#import "MMStoryNavigationView.h"
#import "Masonry.h"
#import "MMExtrastory.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "MMNavigationController.h"
#import "MMRecommender.h"
#import "MMWebViewController.h"
#import "MMCommentController.h"
#import "MMCommentParam.h"
#import "MMSourceTool.h"
@interface MMDetailController ()<UIWebViewDelegate,UIScrollViewDelegate,MMStoryNavigationViewDelegate>
@property (nonatomic,weak) MMTopView *topView;
@property (nonatomic,weak) UIWebView *webView;
@property (nonatomic,weak) UILabel *footer;
@property (nonatomic,weak) UILabel *header;
@property (nonatomic,weak) UIImageView *upArrow;
@property (nonatomic,weak) UIImageView *downArrow;
@property (nonatomic,weak) MMStoryNavigationView *storyNavigationView;
@property (nonatomic,strong) NSArray<NSString *> *allImages;
@property (nonatomic,assign)BOOL isCollected;
//@property (nonatomic,assign)BOOL isLoad;
#define MMTopViewY -40
#define MMTopViewH 220
@end

@implementation MMDetailController
#pragma mark  - 懒加载
- (MMTopView *)topView{
    if (!_topView) {
        MMTopView *topview = [MMTopView topView];
        topview.clipsToBounds = YES;
        topview.hidden = YES;
        topview.backgroundColor = [UIColor clearColor];
        _topView = topview;
        [self.view addSubview:_topView];
        topview.frame  = CGRectMake(0, MMTopViewY, MMScreenW, 220 - MMTopViewY);
        
    }
    return _topView;
}


-(UIWebView *)webView{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc]init];
        _webView = webView;
        [self.view addSubview:_webView];
        webView.frame = CGRectMake(0, 20, MMScreenW, MMScreenH + MMTopViewY -20);
        webView.delegate = self;
        webView.scrollView.delegate = self;
        [webView setOpaque:NO];
        webView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.view bringSubviewToFront:self.topView];
        [self.view bringSubviewToFront:self.header];
        [self.view bringSubviewToFront:self.storyNavigationView];
    }
    return _webView;
}

- (UILabel *)footer {
    if (!_footer) {
        UILabel *footer = [[UILabel alloc]init];
        footer.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        footer.textAlignment = NSTextAlignmentCenter;
        footer.text = @"载入下一篇";
        _footer = footer;
        [self.view addSubview:_footer];
        __weakSelf;
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.view);
            make.centerY.mas_equalTo(weakSelf.view.mas_bottom);
        }];
//        footer.backgroundColor = [UIColor yellowColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upArrow"]];
        [_footer addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.centerY.mas_equalTo(footer);
            make.right.mas_equalTo(footer.mas_left).offset(-10);
        }];
        _upArrow = imageView;
        [self.view bringSubviewToFront:self.storyNavigationView];
    }
    return _footer;
}
-(UILabel *)header{
    if (!_header) {
        UILabel *header = [[UILabel alloc]init];
        header.textColor = [UIColor whiteColor];
        header.textAlignment = NSTextAlignmentCenter;
        header.text = @"载入上一篇";
        _header = header;
        [self.view addSubview:_header];
        __weakSelf;
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.view);
            make.centerY.mas_equalTo(weakSelf.view.mas_top).offset(-20);
        }];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downArrow"]];
        [_header addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.centerY.mas_equalTo(header);
            make.right.mas_equalTo(header.mas_left).offset(-10);
        }];
        _downArrow = imageView;
    }
    return _header;
}

- (MMStoryNavigationView *)storyNavigationView{
    if (!_storyNavigationView) {
        MMStoryNavigationView * storyNavigationView = [MMStoryNavigationView storyNaviView];
        storyNavigationView.frame = CGRectMake(0, MMScreenH - 40, MMScreenW, 40);
        _storyNavigationView = storyNavigationView;
        [self.view addSubview:_storyNavigationView];
        _storyNavigationView.delegate = self;
    }
    return _storyNavigationView;
}
- (UIView*)currentTopView{
    return !self.topView.hidden?self.topView:nil;
}

#pragma mark - MMStoryNavigationViewDelegate
-(void)storyNavigationView:(MMStoryNavigationView *)naviView didClicked:(NSInteger)index{
    switch (index) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [self nextStory];
            break;
        case 2:
            break;
        case 3:
            
            break;
        case 4:
            {
                MMCommentController *vc =  [[MMCommentController alloc]init];
                MMCommentParam *param = [MMCommentParam commentWithId:self.story.id longComments:self.storyNavigationView.extraStory.long_comments shortComments:self.storyNavigationView.extraStory.short_comments];
                vc.commentParam = param;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            break;
        default:
            break;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
 
   
}



#pragma mark - setter
-(void)setStory:(MMHomeStoryStoryItem *)story{
    if (!story) {
        return;
    }
    _story = story;
    if ([self.delegate respondsToSelector:@selector(detailController:story:)]) {
        MMStoryPositionType type = [self.delegate detailController:self story:story];
        if (type & MMStoryPositionTypeFirst) {
            self.header.text = @"已经是第一篇了";
            [self.header sizeToFit];
            self.downArrow.hidden = YES;
        }
        if (type & MMStoryPositionTypeLast){
            self.footer.text = @"已经是最后一篇了";
            [self.footer sizeToFit];
            self.footer.textColor = [UIColor greenColor];
            self.upArrow.hidden = YES;
        }
    }
    
    [self setMyWebView];
    
}

-(void)setMyWebView{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    if (!self.story.id) {
        return;
    }
    
    __weakSelf;
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%lld",self.story.id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.storyNavigationView.extraStory = [MMExtraStory mj_objectWithKeyValues:responseObject];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MMLog(@"%@",error);
    }];
    [MMSourceTool getStoryWithID:self.story.id completion:^(MMDetailStory * obj) {
        if (!obj) {
            return;
        }
        MMDetailStory *ds =  obj;
        if (ds.body.length == 0) {
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://daily.zhihu.com/story/%lld",self.story.id]]]];
            return ;
        }
        NSURL *cssPath = [[NSBundle mainBundle]URLForResource:@"MMDay.css" withExtension:nil];
        if ([weakSelf.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
            ds.htmlStr = [NSString stringWithFormat: @"<html><head><link href=%@ rel=\"stylesheet\"></head><body class=\"night\">%@</body></html>",cssPath,ds.body];
        }else{
            ds.htmlStr = [NSString stringWithFormat: @"<html><head><link href=%@ rel=\"stylesheet\"></head><body>%@</body></html>",cssPath,ds.body];
        }
        
        if (ds.image) {
            weakSelf.topView.hidden = NO;
            weakSelf.topView.story = ds;
        }
        
        else{
            self.header.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            weakSelf.topView.hidden = YES;
        }
        [weakSelf.webView loadHTMLString:ds.htmlStr baseURL:nil];
    }];
        
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    MMLog(@"%f,%f",scrollView.contentOffset.y + scrollView.frame.size.height,scrollView.contentSize.height);
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        CGRect temp = self.topView.frame;
        temp.size.height =  MMTopViewH - MMTopViewY -offsetY;
        self.topView.frame = temp;
        
        
        self.header.transform = CGAffineTransformMakeTranslation(0, -offsetY);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (offsetY < -56) {
            transform = CGAffineTransformMakeRotation(M_PI);
        }
        if (!CGAffineTransformEqualToTransform(transform, self.downArrow.transform)) {
            [UIView animateWithDuration:0.25 animations:^{
                self.downArrow.transform = transform;
            }];
        }
        
    }else{
        CGRect temp = self.topView.frame;
        temp.origin.y =   MMTopViewY - offsetY;
        self.topView.frame = temp;
        if (scrollView.contentOffset.y + scrollView.frame.size.height>scrollView.contentSize.height ) {
            CGFloat offsetX = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
            self.footer.transform = CGAffineTransformMakeTranslation(0, -offsetX);
            
            CGAffineTransform transform = CGAffineTransformIdentity;
            if (offsetX > 56) {
                transform = CGAffineTransformMakeRotation(M_PI);
            }
            if (!CGAffineTransformEqualToTransform(transform, self.upArrow.transform)) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.upArrow.transform = transform;
                }];
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y + scrollView.frame.size.height-scrollView.contentSize.height > 56) {
        [self nextStory];
    }else if (scrollView.contentOffset.y < -56){
        [self previoueStory];
    }
}

#pragma mark - nextStory && previousStory
-(void)nextStory{
    if ([self.delegate respondsToSelector:@selector(nextStoryForDetailController:story:)]) {
        MMHomeStoryStoryItem *story = [self.delegate nextStoryForDetailController:self story:self.story];
        if (!story) {
            return;
        }
        MMDetailController *vc  = [[MMDetailController alloc]init];
        vc.delegate = self.navigationController.childViewControllers[0];
        vc.story = story;
        vc.view.frame = CGRectMake(0, MMScreenH, MMScreenW, MMScreenH);
        MMNavigationController *nav = (MMNavigationController *)self.navigationController;
        nav.tempVc = vc;
        
        
        [self.view addSubview:vc.view];
        __weakSelf;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -MMScreenH);
        } completion:^(BOOL finished) {
            MMNavigationController *nav = (MMNavigationController *)weakSelf.navigationController;
            MMLog(@"%@",[(MMDetailController *)nav.tempVc story]);
            [weakSelf.navigationController popViewControllerAnimated:NO];
            [nav pushViewController:nav.tempVc animated:NO];
        }];
    }
}

- (void)previoueStory{
    if ([self.delegate respondsToSelector:@selector(previousStoryForDetailController:story:)]) {
        MMHomeStoryStoryItem *story = [self.delegate previousStoryForDetailController:self story:self.story];
        if (!story) {
            return;
        }
        MMDetailController *vc  = [[MMDetailController alloc]init];
        vc.delegate = self.navigationController.childViewControllers[0];
        vc.story = story;
        vc.view.frame = CGRectMake(0, -MMScreenH, MMScreenW, MMScreenH);
        MMNavigationController *nav = (MMNavigationController *)self.navigationController;
        nav.tempVc = vc;
        [self.view addSubview:vc.view];
        __weakSelf;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, MMScreenH);
        } completion:^(BOOL finished) {
            MMNavigationController *nav = (MMNavigationController *)weakSelf.navigationController;
            MMLog(@"%@",[(MMDetailController *)nav.tempVc story]);
            [weakSelf.navigationController popViewControllerAnimated:NO];
            [nav pushViewController:nav.tempVc animated:NO];
        }];
    }
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    MMLog(@"%@",request.URL);
    NSString *str = request.URL.absoluteString;
    if ([str hasPrefix:@"http://daily.zhihu.com/story"] || [str hasPrefix:@"http://mp.weixin.qq.com/s"]) {
//        self.isLoad = YES;
        return YES;
    }else if ([str hasPrefix:@"http://"]){
        MMWebViewController *vc = [[MMWebViewController alloc]init];
        vc.request = request;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}
@end
