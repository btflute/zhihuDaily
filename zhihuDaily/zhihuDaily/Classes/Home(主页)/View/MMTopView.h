//
//  MMTopView.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/2.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMDetailStory;
@interface MMTopView : UIView
@property (nonatomic,strong)MMDetailStory *story;
+(instancetype)topView;
@end
