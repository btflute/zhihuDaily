//
//  DrawerController.m
//  第8组,牛逼哄哄
//
//  Created by  陈聪 on 16/5/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "DrawerController.h"
#import "MMHomeController.h"

@interface DrawerController ()<UIGestureRecognizerDelegate>
#define maxX (0.8 * MMScreenW)
#define centerX (0.5 * MMScreenW)
#define leftControllerOriginX -180
@property (assign ,nonatomic, getter=isSubViewUserInteractionEnabled) BOOL subViewuserInteractionEnabled;
@property (nonatomic, weak)  MMSHowVIew* centerContainerView;
@end

@implementation DrawerController
-(UIView*)mainView{
    if(_mainView == nil){
        CGRect childContainerViewFrame = self.view.bounds;
        UIView * mainView = [[UIView alloc] initWithFrame:childContainerViewFrame];
        _mainView = mainView;
        [_mainView setBackgroundColor:[UIColor clearColor]];
        [_mainView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:_mainView];
       
        
    }
    return _mainView;
}
-(void)setContentViewController:(UIViewController *)contentViewController{
    if ([self.contentViewController isEqual:contentViewController]) {
        return;
    }
    
    if (_centerContainerView == nil) {
        
        CGRect centerFrame = self.mainView.bounds;
        if(_centerContainerView == nil){
            MMSHowVIew *view = [[MMSHowVIew alloc] initWithFrame:centerFrame];
            _centerContainerView = view;
            [self.centerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            [self.centerContainerView setBackgroundColor:[UIColor clearColor]];
            [self.mainView addSubview:self.centerContainerView];
        }
    }
    
    UIViewController * oldCenterViewController = self.contentViewController;
    if(oldCenterViewController){
        [oldCenterViewController willMoveToParentViewController:nil];
        [oldCenterViewController beginAppearanceTransition:NO animated:NO];
        [oldCenterViewController.view removeFromSuperview];
        [oldCenterViewController endAppearanceTransition];
        [oldCenterViewController removeFromParentViewController];
    }
    
    _contentViewController = contentViewController;
    
    [self addChildViewController:self.contentViewController];
    [self.contentViewController.view setFrame:self.mainView.bounds];
    [self.centerContainerView addSubview:self.contentViewController.view];
    [self.mainView bringSubviewToFront:self.centerContainerView];
    [self.contentViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    if(self.view.window) {
            [self.contentViewController beginAppearanceTransition:YES animated:NO];
            [self.contentViewController endAppearanceTransition];
    }
    [self.contentViewController didMoveToParentViewController:self];

}
- (instancetype)initWithContentViewController:(UIViewController *)contentViewController leftMenuViewController:(UIViewController *)leftMenuViewController{
    if (self = [super init]) {
        self.contentViewController = contentViewController;
        
        self.leftMenuViewController = leftMenuViewController;
        leftMenuViewController.view.frame = CGRectMake(leftControllerOriginX, 0, MMScreenW, MMScreenH);
        self.leftView = leftMenuViewController.view;
        [self.view addSubview:self.leftView];
        [self.view addSubview:self.mainView];
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.subViewuserInteractionEnabled = YES;
    [self addGesture];
    
}


#pragma mark - Gesture
- (void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
}

- (void)tap:(UIPanGestureRecognizer *)tap{
    if (self.mainView.x == 0) {
        tap.cancelsTouchesInView = NO;
    }
    [self closeDrawerWithAnimateDuration:0.3  ] ;
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGFloat offsetX = [pan translationInView:self.mainView].x;
    [self setTransform:offsetX];
    //复位
    [pan setTranslation:CGPointZero inView:self.mainView];
    CGFloat target = 0.0;
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.mainView.frame.origin.x > -leftControllerOriginX * 0.5) {
            target =  -leftControllerOriginX ;
        }
        offsetX = target - self.mainView.frame.origin.x;
        [UIView animateWithDuration:0.3 animations:^{
            [self setTransform:offsetX];
        }];
    }
}

- (void)setTransform:(CGFloat)offsetX{
    CGFloat tempX = self.mainView.frame.origin.x;
    tempX +=  offsetX;
    if (tempX < 0.0 || tempX > -leftControllerOriginX) {
        
    }else{
        CGRect temp = self.mainView.frame;
        temp.origin.x = tempX;
        self.mainView.frame = temp;
        CGRect temp1 = self.leftView.frame;
        temp1.origin.x += offsetX;
        self.leftView.frame = temp1;
    }
}

#pragma mark - 关闭抽屉
- (void)closeDrawerWithAnimateDuration:(NSTimeInterval)duration
{
    if (!duration)  duration = 0.3;
    [UIView animateWithDuration:duration animations:^{
        [self setTransform:leftControllerOriginX ];
    } completion:nil];
}
#pragma mark - 打开抽屉
- (void)openDrawerWithAnimateDuration:(NSTimeInterval)duration
{
    if (!duration)  duration = 0.3;
    [UIView animateWithDuration:duration animations:^{
        [self setTransform:-leftControllerOriginX ];
    } completion:nil];
    
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    MMLog(@"------------");
    MMLog(@"%@",NSStringFromCGPoint([touch locationInView:self.leftView]));
    MMLog(@"------------");
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [touch locationInView:self.leftView].x <=180) {
        return NO;
    }
    if (self.contentViewController.childViewControllers.count == 1) {
        return YES;
    }
    return NO;
}


@end
