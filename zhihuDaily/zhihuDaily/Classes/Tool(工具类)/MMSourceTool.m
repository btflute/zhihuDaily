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
#import "MMCacheTool.h"
#import "SYTheme.h"
#import "Reachability.h"

@interface MMSourceTool ()
//@property (nonatomic,strong) Reachability* reachability;
@end

@implementation MMSourceTool

+(void)getLatestHomeStoriesWithCompletion:(complete)complete{

    if (![[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        complete([MMCacheTool queryStoryLatestWithDate:[self getDate]]);
        return;
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        [MMHomeStoryItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"top_stories":[MMHomeStoryTopStoryItem class],
                     @"stories":[MMHomeStoryStoryItem class]
                     };
        }];
        MMHomeStoryItem *temp = [MMHomeStoryItem mj_objectWithKeyValues:responseObject];
        [MMCacheTool cacheStoryLatestWithItem:temp];
        complete(temp);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
        NSLog(@"%@",error);
    }];
}

+(void)getThemelistWithCompletion:(complete)complete{
    MMLog(@"%ld",(long)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);
    MMLog(@"cc%d",[[Reachability reachabilityForInternetConnection] currentReachabilityStatus]);
    if (![[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        complete([MMCacheTool queryThemes]);
        return;
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:@"http://news-at.zhihu.com/api/4/themes" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSArray *temp = [SYTheme mj_objectArrayWithKeyValuesArray:responseObject[@"others"]];
        for (SYTheme *theme in temp) {
            [MMCacheTool cacheThemeWithTheme:theme];
        }
        complete(temp);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
        NSLog(@"%@",error);
    }];
    
}
@end
