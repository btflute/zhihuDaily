//
//  UINavigationBar+Color.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/23.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "UINavigationBar+Color.h"
#import <objc/runtime.h>
@implementation UINavigationBar (Color)
static char overlayKey;
- (UIView *)overlay{
    //Returns the value associated with a given object for a given key.
    //The value associated with the key key for object.
    return  objc_getAssociatedObject(self, &overlayKey);
}

-(void)setOverlay:(UIView *)overlay
{
    //Sets an associated value for a given object using a given key and association policy.
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mm_setBackgroundColor:(UIColor *)backgroundColor{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds)+20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)mm_reset{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}
@end
