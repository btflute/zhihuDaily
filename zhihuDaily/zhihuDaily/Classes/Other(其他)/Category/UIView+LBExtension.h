//
//  UIView+LBExtension.h
//  BaiSiBuDeJie
//
//  Created by li  bo on 16/5/10.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE

@interface UIView (LBExtension)
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;

//@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
//@property(nonatomic, assign) IBInspectable UIColor *borderColor;
//@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;


/** 创建当前类的XIb */
+ (instancetype)viewWithXib;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/**
 *  判断是否显示在主窗口上面
 *
 *  @return 是否
 */
- (BOOL)isShowOnWindow;

- (UIViewController *)parentController;
@end
