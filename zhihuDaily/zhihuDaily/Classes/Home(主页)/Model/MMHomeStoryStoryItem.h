//
//  MMHomeStoryStoryItem.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/16.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMHomeStoryStoryItem : NSObject
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,assign)BOOL multipic;
@property (nonatomic,strong)NSString *ga_prefix;
@property (nonatomic,assign)long long id;
@end
