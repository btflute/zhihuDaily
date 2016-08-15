//
//  MMCommentParam.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMCommentParam.h"

@implementation MMCommentParam
+(instancetype)commentWithId:(long long)storyID longComments:(long)longComment shortComments:(long)shortComment{
    MMCommentParam *param = [[self alloc]init];
    param.id = storyID;
    param.long_comments = longComment;
    param.short_comments = shortComment;
    return param;
}
@end
