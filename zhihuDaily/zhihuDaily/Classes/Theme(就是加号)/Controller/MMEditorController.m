//
//  MMEditorController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMEditorController.h"
#import "MMEditorDetailController.h"
#import "MMEditor.h"
#import "MMEditorCell.h"
#import "MMRefreshView.h"
#import "MMEditorDetailController.h"
@interface MMEditorController ()
@property (nonatomic,weak)UITableView *tableView;
@end
static NSString *ID = @"EditorCell";
@implementation MMEditorController
-(UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MMNAVHeight, MMScreenW, MMScreenH - MMNAVHeight)];
        _tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 56;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mm_header.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.tableView registerNib:[UINib nibWithNibName:@"MMEditorCell" bundle:nil] forCellReuseIdentifier:ID];
    self.mm_attachScrollView = self.tableView;
    [self.mm_refreshView removeFromSuperview];
}
- (void)setEditors:(NSArray<MMEditor *> *)editors{
    _editors = editors;
    self.mm_header;
    self.title = @"主编";
    [self.tableView reloadData];
}


#pragma mark - UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.editors.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMEditorCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    MMEditor *editor = self.editors[indexPath.row];
    cell.editor = editor;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMEditor *editor = self.editors[indexPath.row];
    MMEditorDetailController *vc = [[MMEditorDetailController alloc]initWithNibName:@"MMEditorDetailController" bundle:nil] ;
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.editor  = editor;
}

@end
