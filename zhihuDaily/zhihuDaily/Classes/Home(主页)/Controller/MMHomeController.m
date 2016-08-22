//
//  MMHomeController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/11.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMHomeController.h"
#import "MMRefreshView.h"
#import <AFNetworking/AFNetworking.h>
#import "MMHomeStoryItem.h"
#import <MJExtension/MJExtension.h>
#import "MMHomeStoryStoryItem.h"
#import "MMHomeCell.h"
#import "MMHomeHeaderView.h"
#import "MMDetailController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MMHomeStoryTopStoryItem.h"
#import "UINavigationBar+Color.h"
#import "ParallaxHeaderView.h"
#import "MMSourceTool.h"
@interface MMHomeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,MMDetailControllerDelegate>

@property (nonatomic,weak)MMRefreshView *refreshView;
@property (nonatomic,weak)SDCycleScrollView *homeScrollView;
@property (nonatomic,weak)UIView *headerView;
@property (nonatomic,strong)NSMutableArray *homeStories;
@property (nonatomic,weak)UILabel *textLabel;
@property (nonatomic,weak)UILabel *titleLabel;
@end
static NSString *CELLID = @"CELLID";
static NSString *HEADID = @"HEADID";
@implementation MMHomeController
- (NSMutableArray *)homeStories{
    if (_homeStories == nil) {
        _homeStories = [NSMutableArray array];
    }
    return _homeStories;
}



-(UITableView *)homeTableView{
    if (_homeTableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, MMScreenW, MMScreenH -20 ) style:UITableViewStylePlain];
//        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 80;
        
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        _homeTableView = tableView;
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, MMScreenW, 200);
        tableView.tableHeaderView = view;
        
        
        [self.view bringSubviewToFront:self.homeScrollView];
        MMRefreshView *refreshView = [MMRefreshView refreshViewWithScrollView:tableView];
        refreshView.center = CGPointMake(MMScreenW * 0.5 - 50, 42);
        [self.view addSubview:refreshView];
        self.refreshView = refreshView;
    }
    return _homeTableView;
}

- (SDCycleScrollView *)homeScrollView{
    if (_homeScrollView == nil) {
        SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MMScreenW, 220) delegate:self placeholderImage:nil];
        _homeScrollView = scrollView;
        scrollView.infiniteLoop = YES;
        scrollView.showPageControl = YES;
        scrollView.hidesForSinglePage = YES;
        scrollView.autoScrollTimeInterval = 6.0;
        scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        scrollView.titleLabelBackgroundColor = [UIColor clearColor];
        scrollView.titleLabelTextFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:21];
        scrollView.titleLabelTextColor = [UIColor lightGrayColor];
        scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        scrollView.titleLabelHeight = 90;
        [self.view addSubview: scrollView];
    }
    return _homeScrollView;
}

-(UIView *)headerView{
    if (_headerView == nil) {
        UIView *headerView = [[UIView alloc]init];
        headerView.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
        [self.view addSubview:headerView];
        headerView.frame = CGRectMake(0, 0, MMScreenW, MMNAVHeight);
        _headerView = headerView;
        _headerView.alpha = 0;
        [self.view bringSubviewToFront:self.refreshView];
        [self setupLeftButton];
    }
    return _headerView;
}

- (UILabel *)textLabel{
    if (_textLabel == nil) {
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.text  = @"今日要闻";
        _textLabel = textLabel;
        [self.view addSubview:_textLabel];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:18];
        [_textLabel sizeToFit];
        
        _textLabel.center = CGPointMake(0.5 * MMScreenW, 40);
    }
    return _textLabel;
}
- (void)setupLeftButton{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(10, 20, 30, 30);
    [button addTarget:self action:@selector(clickLeftBarButton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
    [self.view addSubview:button];
}
#pragma mark - clickLeftBarButton
- (void)clickLeftBarButton{
    [kNotificationCenter postNotificationName:OpenDrawer object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTodayData];
    [self setUpNavigationItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.homeTableView.dk_backgroundColorPicker = DKColorPickerWithKey(TEST);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(night_updateColor) name:DKNightVersionThemeChangingNotificaiton object:nil];
    
    [self.homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MMHomeCell class]) bundle:nil] forCellReuseIdentifier:CELLID];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    [self.homeTableView registerClass:[MMHomeHeaderView class] forHeaderFooterViewReuseIdentifier:HEADID];
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.homeTableView.delegate = self;
    [self scrollViewDidScroll:self.homeTableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.homeTableView.delegate = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DKNightVersionThemeChangingNotificaiton object:nil];
}

- (void)setUpNavigationItem{
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(NAV);
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"今日要闻";
    [titleLabel sizeToFit];
    self.titleLabel = titleLabel;
    self.navigationItem.titleView = titleLabel;
}

- (void)setTopStoryData{
    MMHomeStoryItem *storyItem =self.homeStories[0];
    NSArray *TopStoryArray = storyItem.top_stories;
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    for (MMHomeStoryTopStoryItem *item in TopStoryArray) {
        [images addObject:item.image];
        [titles addObject:item.title];
    }
    self.homeScrollView.titlesGroup = titles;
    self.homeScrollView.imageURLStringsGroup = images;
}


- (void)loadTodayData{
    
    [MMSourceTool getLatestHomeStoriesWithCompletion:^(MMHomeStoryItem* obj) {
        if (self.homeStories.count) {
            MMHomeStoryItem *item = self.homeStories[0];
            NSString *date = [self getDate];
            if ([date isEqualToString:item.date]) {
                [self.homeStories removeObjectAtIndex:0];
            }
        }
        [self.homeStories insertObject:obj atIndex:0];
        [self setTopStoryData];
        [self.refreshView endRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.homeTableView reloadData];
        });
    }];
    
    
}


- (void)loadBeforeData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    MMHomeStoryItem * item = [self.homeStories lastObject];
    if (!item) {
        return;
    }
    [mgr GET:[NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@",item.date] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        [MMHomeStoryItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"top_stories":[MMHomeStoryTopStoryItem class],
                     @"stories":[MMHomeStoryStoryItem class]
                     };
        }];
        MMHomeStoryItem *temp = [MMHomeStoryItem mj_objectWithKeyValues:responseObject];
        [self.homeStories addObject:temp];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.homeTableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    MMHomeStoryItem *story = self.homeStories[indexPath.section];
    MMHomeStoryStoryItem *item = story.stories[indexPath.row];
    cell.item = item;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MMHomeStoryItem *item = self.homeStories[section];
    return item.stories.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.homeStories.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MMHomeHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADID];
    view.item = self.homeStories[section];
    return section ?view :nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ? MMNAVHeight - MMStatusBarHeight : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        self.headerView.height = MMNAVHeight;
        self.textLabel.alpha = 1;
    }
    if (section == self.homeStories.count - 1) {
        [self loadBeforeData];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(nonnull UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        self.headerView.height = MMStatusBarHeight;
        self.textLabel.alpha = 0;
    }
}

#pragma mark - UITableViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = self.homeTableView.contentOffset.y;
    MMLog(@"%f",offsetY);
    CGFloat alpha = 0;

    CGRect temp = self.homeScrollView.frame;
    if (offsetY < 0) {
        
        temp.size.height = 220-offsetY;
        self.homeScrollView.frame = temp;
    }else{
        
        temp.origin.y = - offsetY;
        self.homeScrollView.frame = temp;
    }
    if (offsetY < 75) {
        
    }else if (offsetY < 165){
        alpha = (offsetY - 75) / (165.0 - 75);
    }else{
        alpha = 0.99;
    }
    self.headerView.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    self.headerView.alpha = alpha;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMDetailController *vc = [[MMDetailController alloc]init];
    vc.delegate = self;
    MMHomeStoryItem *story = self.homeStories[indexPath.section];
    MMHomeStoryStoryItem *item = story.stories[indexPath.row];
    vc.story = item;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < MMRefreshHeight) {
        [self loadTodayData];
    }
}


#pragma mark - night_updateColor
-(void)night_updateColor{
    [self scrollViewDidScroll:self.homeTableView];
}



#pragma mark - MMDetailControllerDelegate
- (MMHomeStoryStoryItem *)nextStoryForDetailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story{
    MMHomeStoryStoryItem *result;
    for (MMHomeStoryItem *item  in self.homeStories) {
        for (MMHomeStoryStoryItem *temp in item.stories) {
            if (story.id == temp.id) {
                NSUInteger index = [item.stories indexOfObject:temp];
                NSUInteger index1 = [self.homeStories indexOfObject:item];
                if (index < item.stories.count - 1) {
                    result =  item.stories[index + 1];
                }else{
                    
                    result =  [((MMHomeStoryItem *)self.homeStories[index1+1]) stories][0];
                }
                
                if (index1 == self.homeStories.count - 1 ) {
                    [self loadBeforeData];
                }
                
                break;
            }
        }
    }
    return result;
}

- (MMHomeStoryStoryItem *)previousStoryForDetailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story{
    MMHomeStoryStoryItem *result;
    for (MMHomeStoryItem *item  in self.homeStories) {
        for (MMHomeStoryStoryItem *temp in item.stories) {
            if (story.id == temp.id) {
                NSUInteger index = [item.stories indexOfObject:temp];
                NSUInteger index1 = [self.homeStories indexOfObject:item];
                if (index > 0) {
                    result =  item.stories[index - 1];
                }else{
                    if (index1 > 0) {
                        result =  [[((MMHomeStoryItem *)self.homeStories[index1-1]) stories] lastObject];
                    }
                    
                }
                
                break;
            }
        }
    }
    return result;

}

- (MMStoryPositionType)detailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story{
    MMHomeStoryItem *firstItem = self.homeStories[0];
    MMHomeStoryItem *lastItem = [self.homeStories lastObject];
    if (story == firstItem.stories[0]) {
        return MMStoryPositionTypeFirst;
    }else if (story == [lastItem.stories lastObject]){
        return MMStoryPositionTypeLast;
    }else{
        return MMStoryPositionTypeOther;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MMHomeStoryItem *secton = self.homeStories[0];
    MMHomeStoryStoryItem *item = secton.top_stories[index];
    MMDetailController *vc = [[MMDetailController alloc]init];
    vc.delegate = self;
    vc.story = item;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
