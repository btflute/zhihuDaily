//
//  MMStoryListController.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/9.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMBaseViewController.h"
#import "MMDetailController.h"
@class MMHomeStoryStoryItem;
@interface MMStoryListController : MMBaseViewController<UITableViewDelegate,UITableViewDataSource>
- (NSArray<MMHomeStoryStoryItem *>*)stories;
- (UITableView *)tableView;
@end
