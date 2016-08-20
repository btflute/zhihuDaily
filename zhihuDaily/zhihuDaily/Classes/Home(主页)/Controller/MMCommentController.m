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
#import "MBProgressHUD+YS.h"
@interface MMCommentController ()<UITableViewDelegate,UITableViewDataSource,MMCommentNavDelegate,MMCommentCellDelegate,MMCommentPannelDelegate>
@property (nonatomic,strong)NSMutableArray<NSMutableArray <MMComment *>*> *allComments;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)MMCommentNav *commentNav;
@property (nonatomic,assign,getter = isLoadingMoreLongComments)BOOL loadingMoreLongComments;
@property (nonatomic,assign,getter = isLoadingMoreShortComments)BOOL loadingMoreShortComments;
@property (nonatomic,weak)MMCommentCell *cell;
@property (nonatomic,weak)MMCommentPannel *pannel;
@end
static NSString *ID = @"CommentCell";
@implementation MMCommentController
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]init];
        _tableView = tableView;
        tableView.frame = CGRectMake(0, MMNAVHeight, MMScreenW, MMScreenH - MMNAVHeight - MMBottomBarH);
        [self.view addSubview:_tableView];
        tableView.rowHeight = 400;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mm_header.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(TEST);
    [self.tableView registerNib:[UINib nibWithNibName:@"MMCommentCell" bundle:nil] forCellReuseIdentifier:ID];
    self.commentNav.delegate = self;
    
    [self setupGesture];
}

- (void)setupGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.tableView addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer *)tapGesture{
    if (self.pannel) {
        [self removePannel];
    }else{
        [self addCommentViewWithLocation:[tapGesture locationInView:self.tableView]];
    }
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.dk_tintColorPicker = DKColorPickerWithKey(BG);
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMComment *comment = self.allComments[indexPath.section][indexPath.row];
    return comment.cellHeight;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.section) {
        if (indexPath.row == self.allComments.firstObject.count - 5 && !self.isLoadingMoreLongComments) {
            [self loadMoreLongComments];
        }
    }else{
        if (indexPath.row == self.allComments.lastObject.count - 5&& !self.isLoadingMoreShortComments) {
            [self loadMoreShortComments];
        }
    }
}

#pragma mark - UIScrollViewDelegate{
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.pannel) {
        [self removePannel];
    }
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

#pragma mark - 加载更多评论
-(void)loadMoreShortComments{
    if (self.commentParam.short_comments == self.allComments.lastObject.count ||self.isLoadingMoreShortComments) {
        return;
    }
    self.loadingMoreShortComments = YES;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/short-comments/before/%ld",self.commentParam.id,self.allComments.lastObject.lastObject.id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.allComments.lastObject addObjectsFromArray:[MMComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]]];
        self.loadingMoreShortComments = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MMLog(@"%@",error);
    }];
    
}
-(void)loadMoreLongComments{
    if (self.commentParam.long_comments == self.allComments.firstObject.count||self.isLoadingMoreLongComments) {
        return;
    }
    self.loadingMoreLongComments = YES;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/long-comments/before/%ld",self.commentParam.id,self.allComments.firstObject.lastObject.id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.allComments.firstObject addObjectsFromArray:[MMComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]]];
        self.loadingMoreLongComments = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MMLog(@"%@",error);
    }];
}

#pragma mark - commentView
- (void)addCommentViewWithLocation:(CGPoint)location{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    self.cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!self.cell) {
        return;
    }
    MMCommentPannel *commentPannel = [MMCommentPannel commentPannelWithLiked:self.cell.comment.isLike];
    commentPannel.delegate = self;
    self.pannel = commentPannel;
    [self.tableView addSubview:commentPannel];
    commentPannel.frame = CGRectMake(location.x, location.y - commentPannel.height, commentPannel.width, commentPannel.height);
    self.pannel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.pannel.alpha = 1;
    }];
}
- (void)removePannel{
    [UIView animateWithDuration:0.2 animations:^{
        self.pannel.alpha = 0;
    } completion:^(BOOL finished) {
        [self.pannel removeFromSuperview];
    }];
    
    self.cell = nil;
}

#pragma mark - MMCommentPannelDelegate
- (void)commentPannel:(MMCommentPannel *)commentPannel indexOfButtonclicked:(NSUInteger)index{
    switch (index) {
        case 0:
            if (self.cell.comment.isLike) {
                self.cell.comment.likes -= 1;
                self.cell.comment.isLike = NO;
                
            }else{
                self.cell.comment.likes += 1;
                self.cell.comment.isLike = YES;
                
            }
            [self removePannel];
            break;
        case 1:
            break;
        case 2:
            [UIPasteboard generalPasteboard].string = self.cell.comment.content;
            [MBProgressHUD showSuccess:@"复制成功"];
            [self removePannel];
            break;
        case 3:
            break;
        default:
            break;
    }
}

@end
