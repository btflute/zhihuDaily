//
//  MMHomeStoryItem.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/16.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMHomeStoryStoryItem,MMHomeStoryTopStoryItem;
@interface MMHomeStoryItem : NSObject
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSArray<MMHomeStoryTopStoryItem *> *top_stories;
@property (nonatomic,strong)NSArray<MMHomeStoryStoryItem *> *stories;
@end
