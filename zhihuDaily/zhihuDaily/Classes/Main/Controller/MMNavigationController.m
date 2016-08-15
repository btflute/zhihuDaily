//
//  MMNavigationController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/11.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMNavigationController.h"

@interface MMNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation MMNavigationController
//+(void)load{
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
}




#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (self.childViewControllers.count > 1) {
        return YES;
    }
    return NO;
}
@end
