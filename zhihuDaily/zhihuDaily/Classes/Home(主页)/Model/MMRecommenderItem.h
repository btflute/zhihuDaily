//
//  MMRecommenderItem.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMRecommender;
@interface MMRecommenderItem : NSObject
@property (nonatomic,assign)long index;
@property (nonatomic,strong)NSArray<MMRecommender *> *recommenders;
@end
