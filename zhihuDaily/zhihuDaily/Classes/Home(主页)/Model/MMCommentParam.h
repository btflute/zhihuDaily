//
//  MMCommentParam.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCommentParam : NSObject
@property (nonatomic,assign)long long  id;
@property (nonatomic,assign)long long_comments;
@property (nonatomic,assign)long short_comments;
+(instancetype)commentWithId:(long long)storyID longComments:(long)longComment shortComments:(long)shortComment;

@end
