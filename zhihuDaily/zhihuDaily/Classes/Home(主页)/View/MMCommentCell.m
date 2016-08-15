//
//  MMCommentCell.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMCommentCell.h"

@interface MMCommentCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *conTentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

@end
@implementation MMCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
