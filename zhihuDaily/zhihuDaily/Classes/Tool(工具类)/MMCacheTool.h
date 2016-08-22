//
//  MMCacheTool.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/21.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYTheme,MMHomeStoryStoryItem,MMHomeStoryItem;
@interface MMCacheTool : NSObject
+ (void)cacheThemeWithTheme:(SYTheme *)theme;
+(NSArray *)queryStoryListWithDate:(NSString *)dateString;
+ (void)cacheStoryListWithArray:(NSArray *)array date:(NSString *)dateString;
+(MMHomeStoryStoryItem *)queryStoryWithID:(long long)ID;
+(void)cacheStoryWithObject:(MMHomeStoryStoryItem *)story;
+(void)cacheThemeStoryListWithID:(int)themeid storyArray:(NSArray *)array;
+(NSArray *)queryThemeStoryListWithMinID:(long long)storyid themeid:(int)themeid;
+(MMHomeStoryItem *)queryStoryLatestWithDate:(NSString *)dateString;
+ (void)cacheStoryLatestWithArray:(MMHomeStoryItem *)item;
@end
