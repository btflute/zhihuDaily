//
//  MMThemeController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/12.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMThemeController.h"
#import "SYTheme.h"
#import "MMThemeItem.h"
#import "MBProgressHUD+YS.h"
#import "MMTableHeader.h"
#import "UIImageView+WebCache.h"
#import "MMEditorController.h"
#import <AFNetworking/AFNetworking.h>
#import "MMHomeStoryStoryItem.h"
#import <MJExtension/MJExtension.h>
#import "MMEditor.h"
#import "MMRefreshView.h"
#import "MMSourceTool.h"
@interface MMThemeController ()
@property (nonatomic,strong)MMThemeItem * themeItem;
@property (nonatomic,weak)UIButton *collectButton;
@property (nonatomic,weak)MMTableHeader *tableHeader;
@end

@implementation MMThemeController
- (MMTableHeader *)tableHeader{
    if (_tableHeader == nil) {
        MMTableHeader *tableHeader = [MMTableHeader headerViewWithTitle:@"主编" rightViewType:MMRightViewTypeArrow];
        _tableHeader = tableHeader;
        _tableHeader.bounds = CGRectMake(0, 0, MMScreenW, 48);
        self.tableView.tableHeaderView = _tableHeader;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClicked)];
        [_tableHeader addGestureRecognizer:tap];
    }
    return _tableHeader;
}
-(UIButton *)collectButton{
    if (_collectButton == nil) {
        UIButton *btn = [[UIButton alloc]init];
        btn.size = CGSizeMake(44, 44);
        btn.center = CGPointMake(MMScreenW - 20, 40);
        [btn addTarget:self action:@selector(didClickedCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"Field_Follow"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Field_Unfollow"] forState:UIControlStateSelected];
        _collectButton = btn;
        [self.mm_header addSubview:_collectButton];
    }
    return _collectButton;
}
#pragma mark - 按钮和手势监听
-(void)headerClicked{
    MMEditorController *vc  = [[MMEditorController alloc]init];
    vc.editors = self.themeItem.editors;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didClickedCollectBtn:(UIButton *)btn{
    btn.selected = !btn.selected;
    btn.selected ?[MBProgressHUD showSuccess:@"已经关注成功"]:[MBProgressHUD showError:@"已经取消关注"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mm_attachScrollView = self.tableView;
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(TEST);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
}
-(void)dealloc{
    MMLog(@"%s",__func__);
}

- (void)setTheme:(SYTheme *)theme{
    _theme = theme;
    self.collectButton.selected = theme.isCollected;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self reload];
}
-(NSArray<MMHomeStoryStoryItem *> *)stories{
    return self.themeItem.stories;
}

#pragma mark - 加载网络数据
-(void)reload{
    __weakSelf;
    [MMSourceTool getLatestThemeStoriesWithThemeid:self.theme.id Completion:^(MMThemeItem * obj) {
        if(!obj) return;
        weakSelf.themeItem = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.title = weakSelf.themeItem.name;
            [weakSelf.mm_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.themeItem.image]];
            [weakSelf.mm_header bringSubviewToFront:self.collectButton];
            NSMutableArray *avatarArray = [@[] mutableCopy];
            for (MMEditor *editor in self.themeItem.editors) {
                [avatarArray addObject:editor.avatar];
            }
            weakSelf.tableHeader.avatars = avatarArray;
            [weakSelf.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mm_refreshView endRefresh];
            });
        }) ;
    }];
    
}

-(void)loadMoreData{
    __weakSelf;
    [MMSourceTool getMoreThemeStoriesWithThemeid:self.theme.id storyid:self.stories.lastObject.id completion:^(NSMutableArray* obj) {
        if (obj.count == 0) {
            return;
        }
        [weakSelf.themeItem.stories addObjectsFromArray:obj];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];

}
#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MMLog(@"row:%d",indexPath.row);
    if (indexPath.row == self.stories.count - 18) {
        [self loadMoreData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMDetailController *vc = [[MMDetailController alloc]init];
    vc.delegate = self;
    vc.story = self.stories[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        CGRect temp =  self.mm_header.frame;
        temp.size.height =  MMNaviBarH - offsetY;
        self.mm_header.frame = temp;
    }
//    MMLog(@"%f",offsetY);
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < MMRefreshHeight) {
        [self reload];
    }
}
#pragma mark - MMDetailControllerDelegate
-(MMHomeStoryStoryItem *)nextStoryForDetailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story{
    NSInteger index = [self indexOfStories:story];
    if (index >= 0 && index < self.stories.count - 1) {
        return self.stories[index + 1];
    }
    return nil;
}
-(MMHomeStoryStoryItem *)previousStoryForDetailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story{
    NSInteger index = [self indexOfStories:story];
    if (index > 0) {
        return self.stories[index - 1];
    }
    return nil;
}
-(MMStoryPositionType)detailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story{
    NSInteger index = [self indexOfStories:story];
    if (index == -1) {
        return MMStoryPositionTypeError;
    }
    if (index ==0) {
        if (self.stories.count == 1) {
            return MMStoryPositionTypeFirstAndLast;
        }else{
            return MMStoryPositionTypeFirst;
        }
    }else if (index == self.stories.count - 1){
        return MMStoryPositionTypeLast;
    }else{
        return MMStoryPositionTypeOther;
    }
}

-(NSInteger)indexOfStories:(MMHomeStoryStoryItem *)story{
    for (NSInteger i = 0; i < self.stories.count; i++) {
        if (self.stories[i].id == story.id) {
            return i;
            break;
        }
    }
    return -1;
}

@end
