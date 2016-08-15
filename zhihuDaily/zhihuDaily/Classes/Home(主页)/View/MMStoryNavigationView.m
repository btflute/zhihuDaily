//
//  MMStoryNavigationView.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/2.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMStoryNavigationView.h"
#import "MMExtraStory.h"

@interface MMStoryNavigationView ()
@property (weak, nonatomic) IBOutlet UIButton *popularityButton;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UILabel *comentsLabel;

@end
@implementation MMStoryNavigationView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
}
- (IBAction)buttonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(storyNavigationView:didClicked:)]) {
        [self.delegate storyNavigationView:self didClicked:sender.tag];
    }
    if (sender.tag == self.popularityButton.tag) {
        self.popularityButton.selected = !self.popularityButton.selected;
        [self setupPopularity];
    }
}

- (void)setupPopularity{
    self.popularityLabel.textColor = self.popularityButton.selected? MMColor(22, 164, 220):[UIColor lightGrayColor];
    if (self.popularityButton.selected) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = MMColor(22, 164, 220);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 4;
        label.clipsToBounds = YES;
        label.text = self.popularityLabel.text;
        [self.popularityButton addSubview:label];
        CGSize buttonSize = self.popularityButton.frame.size;
        label.frame = CGRectMake(buttonSize.width * 0.5, buttonSize.height * 0.5, 0, 0);
        
        [UIView animateWithDuration:0.2 animations:^{
            label.frame = CGRectMake(0, -15, buttonSize.width, 15);
        } completion:^(BOOL finished) {
            NSDictionary *textAttribute = @{NSFontAttributeName:label.font};
            CGFloat textWidth = [label.text sizeWithAttributes:textAttribute].width;
            
            UIView *textView = [[UIView alloc]init];
            textView.backgroundColor = label.backgroundColor;
            [label addSubview:textView];
            int needToChange = [self needToChange:label.text.intValue];
            CGFloat x = label.frame.size.width * 0.5 + textWidth * 0.5 - needToChange *textWidth / label.text.length;
            CGFloat width = needToChange * textWidth / label.text.length;
            textView.frame = CGRectMake(x-0.5, 0, width, label.frame.size.height);
            
            NSString *oldStr = [label.text substringWithRange:NSMakeRange(label.text.length - needToChange, needToChange)];
            NSString *newStr = [NSString stringWithFormat:@"%d",oldStr.integerValue + 1];
            
            UILabel *oldLabel = [[UILabel alloc]init];
            oldLabel.text = oldStr;
            oldLabel.textColor = label.textColor;
            [oldLabel sizeToFit];
            oldLabel.center = CGPointMake(textView.center.x, label.frame.origin.y + textView.center.y);
            [self.popularityButton addSubview:oldLabel];
            
            UILabel *newLabel = [[UILabel alloc]init];
            newLabel.text = newStr;
            newLabel.textColor = label.textColor;
            [newLabel sizeToFit];
            newLabel.center = CGPointMake(textView.center.x, label.frame.origin.y + textView.center.y + 30);
            [self.popularityButton addSubview:newLabel];
            newLabel.alpha = 0;
            
            [UIView animateWithDuration:0.8 animations:^{
                CGPoint temp = oldLabel.center;
                temp.y -= 30;
                oldLabel.center = temp;
                oldLabel.alpha = 0;
                
                newLabel.center = CGPointMake(textView.center.x, label.frame.origin.y + textView.center.y);
                newLabel.alpha = 1;
                self.popularityLabel.text = [NSString stringWithFormat:@"%d", self.popularityLabel.text.intValue+1];
            }];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                label.text = [NSString stringWithFormat:@"%d",[self.popularityLabel.text integerValue] + 1];
//                self.popularityLabel.text = label.text;
//            });
//            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [label removeFromSuperview];
                [newLabel removeFromSuperview];
                [oldLabel removeFromSuperview];
            });
        }];
    }else{
        self.popularityLabel.text = [NSString stringWithFormat:@"%d",[self.popularityLabel.text integerValue] - 1];
    }
}


- (int)needToChange:(int)number{
    int count = 1;
    while (number > 0) {
        if (number % 10 == 9) {
            count++;
        }
        else{
            break;
        }
        number /= 10;
    }
    return count;
}
- (void)setExtraStory:(MMExtraStory *)extraStory{
    _extraStory = extraStory;
    self.popularityLabel.text = [NSString stringWithFormat:@"%ld",extraStory.popularity];
    self.comentsLabel.text = [NSString stringWithFormat:@"%ld",extraStory.comments];
}

+(instancetype)storyNaviView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


@end
