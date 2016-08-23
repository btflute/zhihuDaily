//
//  MMSourceTool.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/22.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^complete)(id obj);
@interface MMSourceTool : NSObject
+(void)getLatestHomeStoriesWithCompletion:(complete)complete;
+(void)getBeforeHomeStoriesWithDate:(NSString*)date Completion:(complete)complete;
+(void)getThemelistWithCompletion:(complete)complete;

+(void)getLatestThemeStoriesWithThemeid:(int)ID Completion:(complete)complete;

+(void)getMoreThemeStoriesWithThemeid:(int)themeID storyid:(long long)storyid completion:(complete)complete;

+(void)getStoryWithID:(long long)ID completion:(complete)complete;

@end
