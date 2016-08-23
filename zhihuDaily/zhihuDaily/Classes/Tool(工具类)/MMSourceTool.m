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
#import "MMThemeItem.h"
#import "MMEditor.h"
#import "MMDetailStory.h"
#import "MMRecommender.h"
@interface MMSourceTool ()
//@property (nonatomic,strong) Reachability* reachability;
@end

@implementation MMSourceTool
+(void)getLatestThemeStoriesWithThemeid:(int)ID Completion:(complete)complete{
    if (![[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        complete([MMCacheTool queryThemeLatestWithThemeid:ID]);
        return;
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%d",ID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        [MMThemeItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"editors":[MMEditor class],
                     @"stories":[MMHomeStoryStoryItem class]
                     };
        }];
        MMThemeItem *item =[MMThemeItem mj_objectWithKeyValues:responseObject];
        complete(item);
        for (MMHomeStoryStoryItem *temp in item.stories) {
            [MMCacheTool cacheThemeStoryListWithID:ID story:temp];
        }
        [MMCacheTool cacheThemeLatestWithItem:item themeid:ID];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
        MMLog(@"%@",error);
    }];

}


+(void)getLatestHomeStoriesWithCompletion:(complete)complete{

    if (![[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        complete([MMCacheTool queryStoryLatest]);
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
+(void)getMoreThemeStoriesWithThemeid:(int)themeID storyid:(long long)storyid completion:(complete)complete{
    NSMutableArray *arrayM =  [MMCacheTool queryThemeStoryListWithMinID:storyid themeid:themeID];
    if (arrayM.count) {
        complete(arrayM);
        return;
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%d/before/%lld",themeID,storyid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSArray *temp =  responseObject[@"stories"];
        NSMutableArray *target = [MMHomeStoryStoryItem mj_objectArrayWithKeyValuesArray:temp];
        for (MMHomeStoryStoryItem *item in target) {
            [MMCacheTool cacheThemeStoryListWithID:themeID story:item];
        }
        complete(target);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
        MMLog(@"%@",error);
    }];

}

+(void)getBeforeHomeStoriesWithDate:(NSString*)date Completion:(complete)complete{
    
    NSString *temp =[self getYesterdayWithDate:date];
    MMHomeStoryItem *item =  [MMCacheTool queryStoryListWithDate:temp];
    if (item) {
        complete(item);
        return;
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:[NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@",date] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        [MMHomeStoryItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"top_stories":[MMHomeStoryTopStoryItem class],
                     @"stories":[MMHomeStoryStoryItem class]
                     };
        }];
        MMHomeStoryItem *temp = [MMHomeStoryItem mj_objectWithKeyValues:responseObject];
        [MMCacheTool cacheStoryListWithItem:temp];
        complete(temp);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
        NSLog(@"%@",error);
    }];
}

+(void)getThemelistWithCompletion:(complete)complete{
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

+(void)getStoryWithID:(long long)ID completion:(complete)complete{
    MMDetailStory *ds = [MMCacheTool queryStoryWithID:ID];
    if (ds) {
        complete(ds);
        return;
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%lld",ID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        [MMDetailStory mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"recommenders":[MMRecommender class]};
        }];
        MMDetailStory *ds = [MMDetailStory mj_objectWithKeyValues:responseObject];
        [MMCacheTool cacheStoryWithObject:ds];
        complete(ds);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
        MMLog(@"%@",error);
    }];
}
@end
