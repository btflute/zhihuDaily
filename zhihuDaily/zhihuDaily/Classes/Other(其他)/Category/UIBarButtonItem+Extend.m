//
//  UIBarButtonItem+Extend.m
//  小小小阿博er
//
//  Created by li  bo on 15/9/10.
//  Copyright (c) 2015年 lb. All rights reserved.
//

#import "UIBarButtonItem+Extend.h"

@implementation UIBarButtonItem (Extend)
+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage title:(NSString *)title
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightimage] forState:UIControlStateHighlighted];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    [button sizeToFit];


    return [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightimage] forState:UIControlStateHighlighted];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    [button sizeToFit];
    button.bounds = CGRectMake(0, 0, 20, 20);

    return [[UIBarButtonItem alloc]initWithCustomView:button];

}
@end
