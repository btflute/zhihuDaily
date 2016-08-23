//
//  MMStoryListController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/9.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMStoryListController.h"
#import "MMHomeStoryStoryItem.h"
#import "MMHomeCell.h"
@interface MMStoryListController ()
@property (nonatomic,weak)UITableView *tableView;
@end
static NSString *theme_reuseid = @"theme_reuseid";
@implementation MMStoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MMHomeCell" bundle:nil] forCellReuseIdentifier:theme_reuseid];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MMLog(@"%d",self.stories.count);
    return self.stories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMLog(@"%d",indexPath.row);
    MMHomeCell*cell = [tableView dequeueReusableCellWithIdentifier:theme_reuseid];
    cell.item = self.stories[indexPath.row];
    return cell;
}

#pragma mark - setter && getter

-(UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.frame = CGRectMake(0, 60, MMScreenW, MMScreenH - 60);
        _tableView = tableView;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.rowHeight = 80;
        [self.view addSubview:tableView];
    }
    return _tableView;
}

- (NSArray<MMHomeStoryStoryItem *> *)stories{
    return nil;
}
@end
