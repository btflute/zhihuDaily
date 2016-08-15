//
//  UIBarButtonItem+Extend.h
//  小小小阿博er
//
//  Created by li  bo on 15/9/10.
//  Copyright (c) 2015年 lb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extend)
+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage title:(NSString *)title;

+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage;
@end
