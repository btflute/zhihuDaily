//
//  MMMainViewController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/11.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMMainViewController.h"
#import "SYTheme.h"
#import "MMHomeController.h"
#import "MMNavigationController.h"
#import "MMThemeController.h"
@interface MMMainViewController ()
@property (strong,nonatomic)MMNavigationController *homeNav;
@end

@implementation MMMainViewController
- (instancetype)initWithContentViewController:(UIViewController *)contentViewController leftMenuViewController:(UIViewController *)leftMenuViewController{
    MMMainViewController *vc = [super initWithContentViewController:contentViewController leftMenuViewController:leftMenuViewController];
    self.homeNav = (MMNavigationController *)contentViewController;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [kNotificationCenter addObserver:self selector:@selector(openDrawer) name:OpenDrawer object:nil];
    [kNotificationCenter addObserver:self selector:@selector(closeDrawer) name:CloseDrawer object:nil];
    [kNotificationCenter addObserver:self selector:@selector(toggleDrawer) name:ToggleDrawer object:nil];


}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}


#pragma mark - 事件处理
- (void)openDrawer{
    if (self.mainView.frame.origin.x >0) {
        [self closeDrawerWithAnimateDuration:0.3];
    }else{
        [self openDrawerWithAnimateDuration:0.3];
    }
}

- (void)closeDrawer{
//    [self hideMenuViewController];
    [self closeDrawerWithAnimateDuration:0.3];
}

- (void)toggleDrawer{
    
}
#pragma mark - SYLeftDrawerControllerDelegate
- (void)LeftDrawerController:(SYLeftDrawerController *)leftDrawerController menuButtonClicked:(SYTheme *)theme{
    if ([theme.name isEqualToString:@"首页"]) {
        if (self.homeNav) {
            self.contentViewController = self.homeNav;
        }else{
            MMNavigationController *nav =[[MMNavigationController alloc]initWithRootViewController:[[MMHomeController alloc]init]];
            self.homeNav = nav;
            self.contentViewController =nav;
        }
    
    }else{
        MMThemeController *themevc = [[MMThemeController alloc]init];
        themevc.theme = theme;
        MMNavigationController *nav =[[MMNavigationController alloc]initWithRootViewController:themevc];
        self.contentViewController =nav;

        
    }
    [self closeDrawer];
}

@end
