//
//  MMHomeCell.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/17.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMHomeCell.h"
#import "MMHomeStoryStoryItem.h"
#import "UIImageView+WebCache.h"
@interface MMHomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *multipicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation MMHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.title.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    // Initialization code
}

-(void)setItem:(MMHomeStoryStoryItem *)item{
    _item = item;
    if (item.images.count >=1) {
        self.multipicImageView.hidden = !item.multipic;
        [self.storyImageView sd_setImageWithURL:[NSURL URLWithString:item.images[0]]];
    }else{
        self.multipicImageView.hidden = YES;
    }
    
    self.title.text = item.title;
}


- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
