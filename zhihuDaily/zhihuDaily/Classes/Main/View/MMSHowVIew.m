//
//  MMSHowVIew.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/8.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMSHowVIew.h"

@implementation MMSHowVIew

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    MMLog(@"%@",NSStringFromCGRect(self.superview.frame));
    if (self.superview.frame.origin.x > 0 && view &&point.y > 64) {
        MMLog(@"-----%@",view);
        
        view = nil;
        MMLog(@"%@",view);
    }
    return view;
}

@end
