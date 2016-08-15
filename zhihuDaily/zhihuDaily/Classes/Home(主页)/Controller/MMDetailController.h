//
//  MMDetailController.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/1.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMHomeStoryStoryItem,MMDetailController;
typedef NS_ENUM(NSInteger,MMStoryPositionType) {
    MMStoryPositionTypeError = 0,
    MMStoryPositionTypeFirst = 1 << 0,
    MMStoryPositionTypeLast = 1 << 1,
    MMStoryPositionTypeOther = 1 << 2,
    MMStoryPositionTypeFirstAndLast = MMStoryPositionTypeFirst | MMStoryPositionTypeLast,
};
@protocol MMDetailControllerDelegate <NSObject>
- (MMHomeStoryStoryItem *)nextStoryForDetailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story;
- (MMHomeStoryStoryItem *)previousStoryForDetailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story;
- (MMStoryPositionType)detailController:(MMDetailController *)detailController story:(MMHomeStoryStoryItem *)story;
@end
@interface MMDetailController : UIViewController
@property (nonatomic,strong)MMHomeStoryStoryItem *story;
@property (nonatomic,weak)id<MMDetailControllerDelegate> delegate;
@end
