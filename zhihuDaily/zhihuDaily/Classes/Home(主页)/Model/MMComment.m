//
//  MMComment.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/18.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMComment.h"
#import "MMReplyComment.h"

@interface MMComment ()
@property (nonatomic,assign)CGFloat cellHeightWhenOpened;
@property (nonatomic,assign)CGFloat cellHeightWhenClosed;
@end
@implementation MMComment
- (CGFloat)cellHeightWhenClosed{
    if (_cellHeightWhenClosed == 0) {
        _cellHeightWhenClosed += 40;
        CGSize contentSize = CGSizeMake(MMScreenW - 80, MAXFLOAT);
        _cellHeightWhenClosed += [self.content boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height + 10;
        if (self.reply_to) {
            CGFloat oneLineHeight = [@"抱歉，原评论已被删除" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].height;
            if (self.reply_to.author) {
                NSDictionary *nameAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor blackColor]};
                NSString *name = [[@"//" stringByAppendingString:self.reply_to.author] stringByAppendingString:@":"];
                NSMutableAttributedString *author = [[NSMutableAttributedString  alloc]initWithString:name attributes:nameAttr];
                NSDictionary *contentAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor darkGrayColor]};
                NSMutableAttributedString *content = [[NSMutableAttributedString  alloc]initWithString:self.reply_to.content attributes:contentAttr];
                [author appendAttributedString:content];
                CGFloat tempHeight =  [author boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                if (tempHeight > 2 * oneLineHeight) {
                    _cellHeightWhenClosed += 2 * oneLineHeight + 10;
                }else{
                    _cellHeightWhenClosed += tempHeight + 10;
                }
            }else{
                _cellHeightWhenClosed += oneLineHeight + 10;
            }
        }
        _cellHeightWhenClosed += 27;
    }
    return _cellHeightWhenClosed;
}

- (CGFloat)cellHeightWhenOpened{
    if (_cellHeightWhenOpened == 0) {
        _cellHeightWhenOpened += 40;
        CGSize contentSize = CGSizeMake(MMScreenW - 80, MAXFLOAT);
        _cellHeightWhenOpened += [self.content boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height + 10;
        if (self.reply_to) {
            NSDictionary *nameAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor blackColor]};
            NSString *name = [[@"//" stringByAppendingString:self.reply_to.author] stringByAppendingString:@":"];
            NSMutableAttributedString *author = [[NSMutableAttributedString  alloc]initWithString:name attributes:nameAttr];
            NSDictionary *contentAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor darkGrayColor]};
            NSMutableAttributedString *content = [[NSMutableAttributedString  alloc]initWithString:self.reply_to.content attributes:contentAttr];
            [author appendAttributedString:content];
            CGFloat tempHeight =  [author boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
            _cellHeightWhenOpened += tempHeight + 10;
        }
        _cellHeightWhenOpened += 27;
    }
    return _cellHeightWhenOpened;
}

- (CGFloat)cellHeight{
    if (self.isOpen) {
        return self.cellHeightWhenOpened;
    }else{
        return self.cellHeightWhenClosed;
    }
}
@end
