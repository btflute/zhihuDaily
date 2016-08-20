//
//  MMCommentNav.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/18.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMCommentNav.h"

@implementation MMCommentNav
- (IBAction)btnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentNav:indexOfButtonClicked:)]) {
        [self.delegate commentNav:self indexOfButtonClicked:sender.tag];
    }
}

+(instancetype)commentNav{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

@end
