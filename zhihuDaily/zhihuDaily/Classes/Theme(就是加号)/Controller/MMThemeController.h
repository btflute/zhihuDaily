//
//  MMThemeController.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/12.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMStoryListController.h"
@class SYTheme;
@interface MMThemeController : MMStoryListController<MMDetailControllerDelegate>
@property (nonatomic,strong)SYTheme *theme;
@end
