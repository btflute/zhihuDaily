//
//  MMTableHeader.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/1.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMTableHeader.h"
#import "MMEditor.h"
#import "UIView+LBExtension.h"
#import "UIImageView+WebCache.h"

@interface MMTableHeader ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray<UIImageView *> *editorsImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation MMTableHeader


- (void)awakeFromNib{
    [super awakeFromNib];
    for (UIImageView * imageView in self.editorsImage) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = imageView.bounds;
        maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(imageView.bounds, 2, 2)].CGPath;
        imageView.layer.mask = maskLayer;
    }
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.title.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}

- (void)setAvatars:(NSArray<NSString *> *)avatars{
    _avatars = avatars;
    for (NSUInteger i = 0; i < 5; i++) {
        if (i < avatars.count) {
            [self.editorsImage[i] sd_setImageWithURL:[NSURL URLWithString:avatars[i]]];
        }else{
            self.editorsImage[i].image = nil;
        }
    }
}

+(instancetype)headerViewWithTitle:(NSString *)title rightViewType:(MMRightViewType)type{
    MMTableHeader *header = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    header.title.text = title;
    if (type == MMRightViewTypeArrow) {
        header.rightView.hidden = NO;
        header.moreImage.hidden = YES;
    }else if (type ==  MMRightViewTypeMore){
        header.rightView.hidden = YES;
        header.moreImage.hidden = NO;
    }else{
        header.rightView.hidden = YES;
        header.moreImage.hidden = YES;
    }
    return header;
}

- (void)setHideMoreIndicator:(BOOL)hideMoreIndicator{
    self.moreImage.hidden = YES;
}

@end
