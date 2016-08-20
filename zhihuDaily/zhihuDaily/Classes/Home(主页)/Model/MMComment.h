//
//  MMComment.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/18.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMReplyComment;
@interface MMComment : NSObject
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,strong)MMReplyComment *reply_to;
@property (nonatomic,assign)long time;
@property (nonatomic,assign)long likes;
@property (nonatomic,assign)BOOL isLong;
@property (nonatomic,assign)BOOL isLike;
@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,assign)CGFloat cellHeight;
@end
