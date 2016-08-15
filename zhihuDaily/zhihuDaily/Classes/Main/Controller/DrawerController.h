//
//  DrawerController.h
//  第8组,牛逼哄哄
//
//  Created by  陈聪 on 16/5/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSHowVIew.h"
@interface DrawerController : UIViewController
/**
 *  主view
 */
@property (weak ,nonatomic)UIView *mainView;
/**
 *  左边的view
 */
@property (weak ,nonatomic)UIView *leftView;
///**
// *  主view的控制器
// */
//@property (weak ,nonatomic)UIViewController *mainViewController;
///**
// *  左边的view的控制器
// */
//@property (weak ,nonatomic)UIViewController *leftViewController;
@property (strong,nonatomic)UIViewController *contentViewController;
@property (strong,nonatomic)UIViewController *leftMenuViewController;
- (void)closeDrawerWithAnimateDuration:(NSTimeInterval)duration;
- (void)openDrawerWithAnimateDuration:(NSTimeInterval)duration;
- (instancetype)initWithContentViewController:(UIViewController *)contentViewController
                       leftMenuViewController:(UIViewController *)leftMenuViewController;
- (void)setMyContentViewController:(UIViewController *)contentViewController;
@end
