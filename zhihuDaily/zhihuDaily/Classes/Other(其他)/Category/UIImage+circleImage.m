//
//  UIImage+circleImage.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/20.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "UIImage+circleImage.h"

@implementation UIImage (circleImage)
- (UIImage *)circleMyImage{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    CGContextAddPath(currentContext, path.CGPath);
    CGContextClip(currentContext);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
