//
//  MMCommentPannel.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/18.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMCommentPannel;
@protocol MMCommentPannelDelegate <NSObject>

@optional
- (void)commentPannel:(MMCommentPannel *)commentPannel indexOfButtonclicked:(NSUInteger)index;
@end


@interface MMCommentPannel : UIView
+(instancetype)commentPannelWithLiked:(BOOL)liked;

@property (nonatomic,weak)id<MMCommentPannelDelegate> delegate;
@end
