//
//  MMBaseViewController.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMBaseViewController.h"
#import "MMRefreshView.h"
#import "Masonry.h"
@interface MMBaseViewController ()
@property (nonatomic,weak) UIImageView * mm_headerBackgroundView;
@property (nonatomic,weak)UILabel * mm_titleLabel;
@property (nonatomic,weak)UIButton *mm_backButton;
@property (nonatomic,weak)MMRefreshView *refreshView;
@end

@implementation MMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mm_header;
    self.mm_backButton;
    
}

- (void)mm_back{
    if (self.navigationController) {
        if (self.navigationController.childViewControllers.count == 1) {
            [kNotificationCenter postNotificationName:OpenDrawer object:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.mm_titleLabel.text = title;
}

-(UIView *)mm_header{
    if (_mm_header == nil) {
        UIView *header = [[UIView alloc]init];
        header.frame = CGRectMake(0, 0, MMScreenW, 64);
        header.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        header.clipsToBounds = YES;
        _mm_header = header;
        [self.view addSubview:_mm_header];
        
        
        
        
        
    }
    return _mm_header;
}


- (UIImageView *)mm_headerBackgroundView{
    if(_mm_headerBackgroundView == nil){
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeCenter;
        _mm_headerBackgroundView = imageView;
        [self.mm_header addSubview:_mm_headerBackgroundView];
        __weakSelf;
        [_mm_headerBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(weakSelf.mm_header).offset(-40);
            make.right.mas_equalTo(weakSelf.mm_header).offset(40);
            make.bottom.mas_equalTo(weakSelf.mm_header);
        }];
        [self.mm_header bringSubviewToFront:self.mm_titleLabel];
        [self.mm_header bringSubviewToFront:self.refreshView];
        [self.mm_header bringSubviewToFront:self.mm_backButton];
    }
    return _mm_headerBackgroundView;
}

- (UILabel *)mm_titleLabel{
    if (_mm_titleLabel == nil) {
        UILabel *label = [[UILabel alloc]init];
        _mm_titleLabel = label;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.mm_header addSubview:_mm_titleLabel];
        __weakSelf;
        [_mm_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mm_header.mas_top).offset(42);
            make.centerX.mas_equalTo(weakSelf.mm_header);
            make.width.mas_lessThanOrEqualTo(MMScreenW - 88);
        }];
    }
    return _mm_titleLabel;
}
- (UIButton *)mm_backButton{
    if (_mm_backButton == nil) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"Field_Back"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(mm_back) forControlEvents:UIControlEventTouchUpInside];
        _mm_backButton = btn;
        [self.mm_header addSubview:_mm_backButton];
        _mm_backButton.frame = CGRectMake(0, 20, 44, 44);
    }
    return _mm_backButton;
}

- (void)setMm_attachScrollView:(UIScrollView *)mm_attachScrollView{
    if (mm_attachScrollView == nil) {
        return;
    }
    if (_mm_attachScrollView) {
        return;
    }
    _mm_attachScrollView = mm_attachScrollView;
    MMRefreshView *refreshView =[MMRefreshView refreshViewWithScrollView:mm_attachScrollView];
    _refreshView = refreshView;
    [self.mm_header addSubview:refreshView];
    
    __weakSelf;
//    weakSelf.mm_titleLabel;
    MMLog(@"%@,%@",refreshView.superview,self.mm_titleLabel.superview);
    [refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mm_titleLabel);
        make.right.mas_equalTo(self.mm_titleLabel.mas_left).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}

- (UIImageView *)mm_backgroundImageView{
    return self.mm_headerBackgroundView;
}

- (MMRefreshView *)mm_refreshView{
    return self.refreshView;
}
@end
