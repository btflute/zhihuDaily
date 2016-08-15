//
//  MMTopView.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/2.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMTopView.h"
#import "MMDetailStory.h"
#import "UIImageView+WebCache.h"
@interface MMTopView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;


@end
@implementation MMTopView
- (void)setStory:(MMDetailStory *)story{
    _story = story;
    if (story.image) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:story.image]];
        self.titleLabel.text = story.title;
        
        self.sourceLabel.text = [@"来源 " stringByAppendingString:story.image_source? story.image_source :@"null"] ;
    }
    [self setNeedsLayout];
}

+(instancetype)topView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self ) owner:nil options:nil].firstObject;
}

@end
