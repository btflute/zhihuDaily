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
@end
