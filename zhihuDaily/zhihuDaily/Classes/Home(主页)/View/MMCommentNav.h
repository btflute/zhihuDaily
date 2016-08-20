//
//  MMCommentNav.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/18.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMCommentNav;
@protocol MMCommentNavDelegate <NSObject>

@optional
-(void)commentNav:(MMCommentNav *)view indexOfButtonClicked:(NSUInteger)index;

@end

@interface MMCommentNav : UIView
@property (nonatomic,weak)id<MMCommentNavDelegate> delegate;
+(instancetype)commentNav;
@end
