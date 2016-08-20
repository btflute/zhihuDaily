//
//  MMCommentController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMCommentController.h"
#import "MMCommentParam.h"
#import "MMHomeStoryStoryItem.h"
#import "MMComment.h"
#import "MMCommentPannel.h"
#import "MMCommentCell.h"
#import "MMCommentNav.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
@interface MMCommentController ()<UITableViewDelegate,UITableViewDataSource,MMCommentNavDelegate,MMCommentCellDelegate>
@property (nonatomic,strong)NSMutableArray<NSMutableArray <MMComment *>*> *allComments;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)MMCommentNav *commentNav;
@end
static NSString *ID = @"CommentCell";
@implementation MMCommentController
- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]init];
        _tableView = tableView;
        tableView.frame = CGRectMake(0, MMNAVHeight, MMScreenW, MMScreenH - MMNAVHeight - MMBottomBarH);
        [self.view addSubview:_tableView];
        tableView.rowHeight = 500;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 80;
    }
    return _tableView;
}

- (MMCommentNav *)commentNav{
    if (_commentNav == nil) {
        MMCommentNav *commentNav = [MMCommentNav commentNav];
        _commentNav = commentNav;
        commentNav.frame = CGRectMake(0, MMScreenH - MMBottomBarH, MMScreenW, MMBottomBarH);
        [self.view addSubview:_commentNav];
    }
    return _commentNav;
}

-(NSMutableArray<NSMutableArray<MMComment *> *> *)allComments{
    if (_allComments == nil) {
        _allComments = [@[@[],@[]] mutableCopy];
    }
    return _allComments;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mm_header.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    [self.tableView registerNib:[UINib nibWithNibName:@"MMCommentCell" bundle:nil] forCellReuseIdentifier:ID];
    self.commentNav.delegate = self;
}

#pragma mark - MMCommentNavDelegate
- (void)commentNav:(MMCommentNav *)view indexOfButtonClicked:(NSUInteger)index{
    if (index == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (index == 11){
        MMLog(@"点击了写评论按钮");
    }
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section?self.allComments.lastObject.count : self.allComments.firstObject.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.delegate = self;
    cell.comment = self.allComments[indexPath.section][indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section) {
        return [NSString stringWithFormat:@"%ld条短评论",self.commentParam.short_comments];
    }else{
        return [NSString stringWithFormat:@"%ld条长评论",self.commentParam.long_comments];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    UITableViewHeaderFooterView *hView = (UITableViewHeaderFooterView *)view;
    hView.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMComment *comment = self.allComments[indexPath.section][indexPath.row];
    return comment.cellHeight;
}
#pragma mark - setter
- (void)setCommentParam:(MMCommentParam *)commentParam{
    _commentParam = commentParam;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/long-comments",commentParam.id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        self.allComments[0] = [MMComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MMLog(@"%@",error);
    }];
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/short-comments",commentParam.id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        self.allComments[1] = [MMComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MMLog(@"%@",error);
    }];
}

#pragma mark - MMCommentCellDelegate
- (void)commentCell:(MMCommentCell *)cell teTweetLabelOpened:(BOOL)opened{
    [self.tableView reloadData];
}
@end
