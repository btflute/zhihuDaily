//
//  MMCacheTool.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/21.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYTheme,MMHomeStoryStoryItem,MMHomeStoryItem,MMThemeItem,MMDetailStory;
@interface MMCacheTool : NSObject
+ (void)cacheThemeWithTheme:(SYTheme *)theme;

+ (NSArray *)queryThemes;

+(MMHomeStoryItem *)queryStoryListWithDate:(NSString *)dateString;

+ (void)cacheStoryListWithItem:(MMHomeStoryItem *)item;

+(MMDetailStory *)queryStoryWithID:(long long)ID;

+(void)cacheStoryWithObject:(MMDetailStory *)story;

+(void)cacheThemeStoryListWithID:(int)themeid story:(MMHomeStoryStoryItem *)story;

+(NSMutableArray *)queryThemeStoryListWithMinID:(long long)storyid themeid:(int)themeid;

+(MMHomeStoryItem *)queryStoryLatest;

+ (void)cacheStoryLatestWithItem:(MMHomeStoryItem *)item;

+ (void)cacheThemeLatestWithItem:(MMThemeItem *)item themeid:(int)ID;

+ (MMThemeItem *)queryThemeLatestWithThemeid:(int)ID;
@end
