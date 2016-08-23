//
//  NSObject+Date.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/17.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Date)
-(NSString *)getDate;
+(NSString *)getDate;
+(NSString *)getYesterdayWithDate:(NSString *)date;
-(NSString *)getSpecifyDate:(NSString *)specifyDate;
@end
