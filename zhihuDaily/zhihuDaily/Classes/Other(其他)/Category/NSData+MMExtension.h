//
//  NSData+MMExtension.h
//  MM-Coding
//
//  Created by 赖锦浩 on 16/5/20.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MMExtension)
- (NSDateComponents *)intervalToDate:(NSDate *)date;

- (NSDateComponents *)intervalToNow;

/** 今年 */
- (BOOL)isThisYear;

/** 今天 */
- (BOOL)isToDay;

/** 昨天 */
- (BOOL)isYesterday;

/** 明天 */
- (BOOL)isTomorrow;

@end
