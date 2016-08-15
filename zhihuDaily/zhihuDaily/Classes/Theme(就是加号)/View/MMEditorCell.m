//
//  MMEditorCell.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/13.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMEditorCell.h"
#import "MMEditor.h"
#import "UIImageView+WebCache.h"
@interface MMEditorCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end
@implementation MMEditorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dk_backgroundColorPicker  = DKColorPickerWithKey(BG);
}

- (void)setEditor:(MMEditor *)editor{
    _editor = editor;
    editor.avatar?[self.iconImageView sd_setImageWithURL:[NSURL URLWithString:editor.avatar]]:nil;
    self.nameLabel.text = editor.name;
    self.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
    self.bioLabel.text = editor.bio;
//    self.bioLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}

//- (void)setFrame:(CGRect)frame{
//    frame.size.height -= 1;
//    [super setFrame:frame];
//    
//}
@end
