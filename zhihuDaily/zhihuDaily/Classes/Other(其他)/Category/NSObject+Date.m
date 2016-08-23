//
//  NSObject+Date.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/17.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "NSObject+Date.h"

@implementation NSObject (Date)
-(NSString *)getDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:date];
}
+(NSString *)getDate{
    return [[[self alloc]init] getDate];
}

+(NSString *)getYesterdayWithDate:(NSString *)date{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *temp = [dateFormatter dateFromString:date];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:- 24 * 60 * 60 sinceDate:temp]];
}

-(NSString *)getSpecifyDate:(NSString *)specifyDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:specifyDate];
    dateFormatter.dateFormat = @"M月d日 EEEE";
    return [dateFormatter stringFromDate:date];
    
}
@end
