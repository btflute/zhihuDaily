//
//  MMSourceTool.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/22.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMSourceTool.h"
#import "MMHomeStoryItem.h"
#import "MMHomeStoryStoryItem.h"
#import "MMHomeStoryTopStoryItem.h"
#import <AFNetworking.h>
#import <MJExtension/MJExtension.h>
@implementation MMSourceTool
+(void)getLatestHomeStoriesWithCompletion:(complete)complete{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        [MMHomeStoryItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"top_stories":[MMHomeStoryTopStoryItem class],
                     @"stories":[MMHomeStoryStoryItem class]
                     };
        }];
        MMHomeStoryItem *temp = [MMHomeStoryItem mj_objectWithKeyValues:responseObject];
        
        [self.homeStories insertObject:temp atIndex:0];
        [self setTopStoryData];
        [self.refreshView endRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.homeTableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
