//
//  MMBaseViewController.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMRefreshView;
@interface MMBaseViewController : UIViewController
@property (nonatomic,weak)UIView *mm_header;
@property (nonatomic,weak)UIScrollView *mm_attachScrollView;
- (UIImageView *)mm_backgroundImageView;
- (MMRefreshView *)mm_refreshView;
@end
