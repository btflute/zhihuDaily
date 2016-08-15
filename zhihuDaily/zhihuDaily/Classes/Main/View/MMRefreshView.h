//
//  MMRefreshView.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/7/31.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRefreshView : UIView
+(instancetype)refreshViewWithScrollView:(UIScrollView *)scrollview;

- (void)endRefresh;
@end
