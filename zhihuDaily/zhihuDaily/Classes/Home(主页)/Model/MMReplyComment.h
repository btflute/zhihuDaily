//
//  MMReplyComment.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/14.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMReplyComment : NSObject
@property (nonatomic,copy)NSString *content;
@property (nonatomic,assign)int status;
@property (nonatomic,assign)long id;
@property (nonatomic,copy)NSString *author;
@end
