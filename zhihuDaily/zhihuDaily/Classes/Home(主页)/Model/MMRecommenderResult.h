//
//  MMRecommenderResult.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMRecommenderItem,MMEditor;
@interface MMRecommenderResult : NSObject
@property (nonatomic,strong)NSArray<MMEditor *> *editors;
@property (nonatomic,strong)NSArray<MMRecommenderItem *> *items;
@end
