//
//  MMDetailStory.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/2.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMRecommender;
@interface MMDetailStory : NSObject
@property (nonatomic,copy)NSString *body;
@property (nonatomic,copy)NSString *image_source;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *share_url;
@property (nonatomic,strong)NSArray<MMRecommender *> *recommenders;
@property (nonatomic,assign)long long id;
@property (nonatomic,strong)NSArray *css;
@property (nonatomic,copy)NSString *htmlStr;

@end
