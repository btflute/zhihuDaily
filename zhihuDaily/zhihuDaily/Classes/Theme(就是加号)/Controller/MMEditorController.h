//
//  MMEditorController.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMBaseViewController.h"
@class MMEditor;
@interface MMEditorController : MMBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray<MMEditor *> *editors;
@end
