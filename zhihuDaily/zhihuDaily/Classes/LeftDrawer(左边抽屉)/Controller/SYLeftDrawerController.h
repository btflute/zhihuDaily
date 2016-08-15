//
//  SYLeftDrawerController.h
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYLeftDrawerController;
@class SYTheme;
@protocol SYLeftDrawerControllerDelegate <NSObject>

-(void)LeftDrawerController:(SYLeftDrawerController *)leftDrawerController menuButtonClicked:(SYTheme *)theme;

@end

@interface SYLeftDrawerController : UIViewController
@property (nonatomic,weak)id<SYLeftDrawerControllerDelegate> delegate;
//@property (nonatomic, strong) MMNavigationController *naviHome;
//
//@property (nonatomic, weak) MMMainViewController *mainController;


@end
