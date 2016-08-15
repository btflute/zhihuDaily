//
//  MMAppSettings.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMAppSettings : NSObject
+(instancetype)sharedSettings;
@property (nonatomic,assign)BOOL nightMood;
@end
