//
//  MMRecommender.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/2.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMRecommender : NSObject
@property (nonatomic,copy)NSString *bio;
@property (nonatomic,copy)NSString *zhihu_url_token;
@property (nonatomic,assign)long  id;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *name;
@end
