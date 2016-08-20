//
//  MMCommentCell.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMCommentCell.h"
#import "MMComment.h"
#import "UIImageView+WebCache.h"
#import "MMReplyComment.h"
@interface MMCommentCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *conTentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (assign,nonatomic,getter=isAnimating)BOOL animating;

@end
@implementation MMCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.conTentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.timeLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.timeLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}
- (IBAction)didCleckedExpandBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.comment.isOpen = sender.selected;
    if ([self.delegate respondsToSelector:@selector(commentCell:teTweetLabelOpened:)]) {
        [self.delegate commentCell:self teTweetLabelOpened:self.comment.isOpen];
    }
    
}

-(void)setComment:(MMComment *)comment{
//    [_comment removeObserver:self forKeyPath:@"isLike"];
    _comment = comment;
    [comment addObserver:self forKeyPath:@"isLike" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:comment.avatar]];
    self.conTentLabel.text = comment.content;
    self.nameLabel.text = comment.author;
    if (comment.reply_to) {
        if (!comment.reply_to.author) {
            NSDictionary *contentAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor darkGrayColor]};
            NSMutableAttributedString *content = [[NSMutableAttributedString  alloc]initWithString:@"抱歉，原评论已被删除" attributes:contentAttr];
            self.retweetLabel.attributedText = content;
            self.retweetLabel.backgroundColor = [UIColor lightGrayColor];
            self.retweetLabel.hidden = NO;
            self.expandBtn.hidden = YES;
        }else{
            self.retweetLabel.backgroundColor = [UIColor clearColor];
            NSDictionary *nameAttr = nil;
            if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
                nameAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor whiteColor]};
            }else{
                nameAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor blackColor]};
            }
            
            NSString *name = [[@"//" stringByAppendingString:comment.reply_to.author] stringByAppendingString:@":"];
            NSMutableAttributedString *author = [[NSMutableAttributedString  alloc]initWithString:name attributes:nameAttr];
            NSDictionary *contentAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor grayColor]};
            NSMutableAttributedString *content = [[NSMutableAttributedString  alloc]initWithString:comment.reply_to.content attributes:contentAttr];
            [author appendAttributedString:content];
            self.retweetLabel.attributedText = author;
            self.retweetLabel.hidden = NO;
            self.retweetLabel.numberOfLines = comment.isOpen?0:2;
            [self.retweetLabel sizeToFit];
            CGFloat height = [author boundingRectWithSize:CGSizeMake(MMScreenW - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.height;
            
            if (height > self.retweetLabel.frame.size.height||comment.isOpen) {
                self.expandBtn.hidden = NO;
                self.expandBtn.selected = comment.isOpen;
            }else{
                self.expandBtn.hidden = YES;
            }
            
            
            
        }
        
        
    }else{
        self.retweetLabel.hidden = YES;
        self.expandBtn.hidden = YES;
    }
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",comment.likes];
    if (comment.isLike) {
        self.likeImageView.image = [UIImage imageNamed:@"Comment_Voted"];
        self.likeCountLabel.textColor = MMColor(48, 127, 255);
    }else{
        self.likeImageView.image = [UIImage imageNamed:@"Comment_Vote"];
        self.likeCountLabel.textColor = MMColor(128, 128, 128);
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:comment.time];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}

- (void)startLikeAnimation{
    if (self.isAnimating) {
        return;
    }
    self.animating = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"+1"]];
    imageView.frame = CGRectMake(-30, -24, 30, 24);
    [self.likeImageView addSubview:imageView];
    [UIView animateWithDuration:0.48 animations:^{
        imageView.frame = CGRectMake(0, 0, 5, 4);
    } completion:^(BOOL finished) {
        self.animating = NO;
        [imageView removeFromSuperview];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    BOOL isLike = [change[@"new"] boolValue];
    if (isLike) {
        [self startLikeAnimation];
        self.likeImageView.image = [UIImage imageNamed:@"Comment_Voted"];
        self.likeCountLabel.textColor = MMColor(48, 127, 255);
    }else{
        self.likeImageView.image = [UIImage imageNamed:@"Comment_Vote"];
        self.likeCountLabel.textColor = MMColor(128, 128, 128);
    }
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)prepareForReuse{
    if (self.comment) {
        [self.comment removeObserver:self forKeyPath:@"isLike"];
    }
    [super prepareForReuse];
}
-(void)dealloc{
    if (self.comment) {
        [self.comment removeObserver:self forKeyPath:@"isLike"];
    }
    
}

@end
