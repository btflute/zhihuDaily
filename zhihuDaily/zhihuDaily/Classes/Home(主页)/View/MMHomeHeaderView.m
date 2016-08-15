//
//  MMHomeHeaderView.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/17.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMHomeHeaderView.h"
#import "MMHomeStoryItem.h"
@implementation MMHomeHeaderView


-(void)setItem:(MMHomeStoryItem *)item{
    _item = item ;
    self.textLabel.text = [self getSpecifyDate:item.date];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.center = self.contentView.center;
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(NAV);
    self.textLabel.textColor = [UIColor whiteColor];
   
}

@end
