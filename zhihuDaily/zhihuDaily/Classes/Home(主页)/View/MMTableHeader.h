//
//  MMTableHeader.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/1.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,MMRightViewType) {
    MMRightViewTypeNone = 0,
    MMRightViewTypeArrow = 1,
    MMRightViewTypeMore = 2,
};
@interface MMTableHeader : UIView
@property (nonatomic,strong)NSArray<NSString *> *avatars;
+(instancetype)headerViewWithTitle:(NSString *)title rightViewType:(MMRightViewType)type;
@property (nonatomic,assign)BOOL hideMoreIndicator;
@end
