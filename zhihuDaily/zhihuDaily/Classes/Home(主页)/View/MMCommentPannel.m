//
//  MMCommentPannel.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/18.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMCommentPannel.h"

@interface MMCommentPannel ()
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end
@implementation MMCommentPannel
+(instancetype)commentPannelWithLiked:(BOOL)liked{
    MMCommentPannel *commentPannel = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
    [commentPannel.likeBtn setTitle:liked?@"取消点赞":@"点赞" forState:UIControlStateNormal];
    if (liked) {
        CGRect bounds =  commentPannel.bounds ;
        bounds.size.width += 30;
        commentPannel.bounds = bounds;
    }
    
    
    return commentPannel;
}
- (IBAction)btnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentPannel:indexOfButtonclicked:)]) {
        [self.delegate commentPannel:self indexOfButtonclicked:sender.tag];
    }
}


@end
