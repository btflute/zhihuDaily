//
//  SYLeftDrawerController.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYLeftDrawerController.h"
#import "MMAppSettings.h"
#import "SYLeftDrawerCell.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFNetworking.h>
#import "MMSourceTool.h"

@interface SYLeftDrawerController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray<SYTheme *> *themes;

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *offlineButton;
@property (weak, nonatomic) IBOutlet UIButton *dayNightButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) MMAppSettings *setings;
//@property (nonatomic, strong)  SYThemeController *themeController;

@end

@implementation SYLeftDrawerController


#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupDataSource];
    self.setings = [MMAppSettings sharedSettings];
    self.dayNightButton.selected = self.setings.nightMood;
    
//    [kNotificationCenter addObserver:self selector:@selector(setupDataSource) name:NotiLogin object:nil];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
//    [self.profileView addGestureRecognizer:tap];
}

- (void)setupSubviews {
    self.avatarImage.layer.cornerRadius = 18;
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = MMColor(26, 31, 36);
    self.view.window.tintColor = MMColor(26, 31, 36);
    self.tableView.rowHeight = 36;
 }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.width = 180;
    // 更新头像状态
//    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:kAccount.avatar]];
//    self.nameLabel.text = kAccount.name;
//    White_StatusBar;
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}

#pragma mark event handler
//- (IBAction)login {
//    SYAccount *account = [SYAccount sharedAccount];
//    if (account.isLogin) {
//        SYProfileController *pc = [[SYProfileController alloc] init];
//        [self presentViewController:pc animated:YES completion:nil];
//    } else {
//        SYLoginController *lvc = [[SYLoginController alloc] init];
//        
//        [self presentViewController:lvc animated:YES completion:nil];
//    }
//}
- (IBAction)dayNightButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.setings.nightMood = sender.selected;
}

- (void)setupDataSource {
    [MMSourceTool getThemelistWithCompletion:^(NSMutableArray <SYTheme*> * obj) {
        self.themes = obj;

        SYTheme *home = [[SYTheme alloc] init];
        home.name = @"首页";
        [self.themes insertObject:home atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
     
}



//- (NSInteger)locateTheme:(SYTheme *)theme {
//    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
//        if (self.dataSource[i].id == theme.id) {
//            return i;
//        }
//    }
//    return -1;
//}



//- (IBAction)didClickedMenuButton:(UIButton *)sender {
//    if ([sender.currentTitle isEqualToString:@"设置"]) {
//        SYSettingController *sc = [[SYSettingController alloc] init];
//        SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:sc];
//        navi.navigationBar.hidden = YES;
//        [self.mainController setCenterViewController:navi withCloseAnimation:YES completion:nil];
//        return;
//    } else {
//        SYCollectionController *cc = [[SYCollectionController alloc] init];;
//        
//        SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:cc];
//        navi.navigationBar.hidden = YES;
//        [self.mainController setCenterViewController:navi withCloseAnimation:YES completion:nil];
//    }
//}


#pragma mark tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themes.count;
}
- (SYLeftDrawerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SYLeftDrawerCell *cell = [SYLeftDrawerCell cellWithTableView:tableView];
    
    cell.theme = self.themes[indexPath.row];
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//
//    SYTheme *theme = self.dataSource[sourceIndexPath.row];
//    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
//    if (destinationIndexPath.row == 1) {
//        [self.dataSource insertObject:theme atIndex:1];
//    } else {
//        [self.dataSource addObject:theme];
//    }
//
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        [self.mainController setCenterViewController:self.naviHome withCloseAnimation:YES completion:nil];
//    } else {
//        self.themeController.theme = self.dataSource[indexPath.row];
//        [self.mainController setCenterViewController:self.naviTheme withCloseAnimation:YES completion:nil];
//    }
    SYTheme *theme = self.themes[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(LeftDrawerController:menuButtonClicked:)]) {
        [self.delegate LeftDrawerController:self menuButtonClicked:theme];
    }
}

#pragma mark cell delegate
//- (void)didClickedLeftDrawerCell:(SYLeftDrawerCell *)cell {
//    SYTheme *theme = cell.theme;
//    NSInteger locate =  [self locateTheme:theme];
//    if (locate < 0) return;
//    cell.theme.isCollected = YES;
//    
//    NSIndexPath *sip = [NSIndexPath indexPathForRow:locate inSection:0];
//    NSIndexPath *dip = [NSIndexPath indexPathForRow:1 inSection:0];
//    [self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
//    [self tableView:self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
//    
//}


#pragma mark theme controller delegate

//- (void)themeController:(SYThemeController *)themeController theme:(SYTheme*)theme actionType:(SYThemeActionType)type {
//    NSInteger locate =  [self locateTheme:theme];
//    if (locate < 0) return;
//    theme.isCollected = type;
//    
//    NSIndexPath *sip = nil;
//    NSIndexPath *dip = nil;
//    
//    if (type == SYThemeActionTypeCollect) {
//        [SYZhihuTool collectedWithTheme:theme];
//        
//        sip = [NSIndexPath indexPathForRow:locate inSection:0];
//        dip = [NSIndexPath indexPathForRow:1 inSection:0];
//    } else {
//        [SYZhihuTool cancelCollectedWithTheme:theme];
//        sip = [NSIndexPath indexPathForRow:locate inSection:0];
//        dip = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
//    }
//    // 重新设置theme，刷新cell的显示
//    SYLeftDrawerCell *cell = [self.tableView cellForRowAtIndexPath:sip];
//    cell.theme = theme;
//    [self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
//    [self tableView:self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
//    
//}

#pragma mark setter & getter
//- (MMNavigationController *)naviHome {
//    if (!_naviHome) {
//        MMHomeController *home = [[MMHomeController alloc] init];
//        _naviHome = [[MMNavigationController alloc] initWithRootViewController:home];
////        _naviHome.navigationBar.hidden = YES;
//    }
//    return _naviHome;
//}

//- (SYNavigationController *)naviTheme {
//    if (!_naviTheme) {
//        _naviTheme = [[MMNavigationController alloc] initWithRootViewController:self.themeController];
//        _naviTheme.navigationBar.hidden = YES;
//    }
//    return _naviTheme;
//}

//- (SYThemeController *)themeController {
//    if (!_themeController) {
//        _themeController = [[SYThemeController alloc] init];
//        _themeController.view.backgroundColor = [UIColor whiteColor];
//        _themeController.delegate = self;
//    }
//    return _themeController;
//}



@end
