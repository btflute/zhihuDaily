//
//  MMRefreshView.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/7/31.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMRefreshView.h"

@interface MMRefreshView ()
@property (nonatomic,strong)UIScrollView* scrollView;
@property (nonatomic,weak)CAShapeLayer* progressLayer;
@property (nonatomic,weak)UIActivityIndicatorView *indicatorView;
@property (nonatomic,assign)CGFloat refreshFlag;
@property (nonatomic,assign,getter=isRefreshing)CGFloat refreshing;

@end

@implementation MMRefreshView

+(instancetype)refreshViewWithScrollView:(UIScrollView *)scrollview{
    MMRefreshView *refreshView = [[self alloc]init];
    refreshView.bounds = CGRectMake(0, 0, 18, 18);
    refreshView.scrollView = scrollview;
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    [refreshView.layer addSublayer:progressLayer];
    refreshView.progressLayer = progressLayer;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    progressLayer.strokeEnd = 0.0;
    progressLayer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
    progressLayer.lineWidth = 2.0;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]init];
    indicatorView.bounds = CGRectMake(0, 0, 18, 18);
    [refreshView addSubview:indicatorView];
    refreshView.indicatorView = indicatorView;
    
    [refreshView.scrollView addObserver:refreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    return refreshView;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 2, 2)].CGPath;
}

- (void)layoutSubviews{
    self.indicatorView.frame = self.bounds;
}

- (void)dealloc{
    MMLog(@"%s",__func__);
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (self.refreshing) return;
    CGFloat offsetY =  [change[@"new"] CGPointValue].y;
//    MMLog(@"%f",offsetY);
    CGFloat scale;
    if (offsetY >=0) {
        scale = 0;
    }else if (offsetY>=MMRefreshHeight){
        scale = offsetY / MMRefreshHeight;
    }else{
        scale = 1;
        
    }
    if (!self.scrollView.isDragging && scale == 1) {
        self.refreshing = YES;
        self.progressLayer.hidden = YES;
        [self.indicatorView startAnimating];
    }else{
        self.progressLayer.strokeEnd = scale;
    }
    
}

-(void)endRefresh{
    
    
    self.progressLayer.strokeEnd = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshing = NO;
        self.progressLayer.hidden = NO;
        [self.indicatorView stopAnimating];
    });
    
    
}

@end
