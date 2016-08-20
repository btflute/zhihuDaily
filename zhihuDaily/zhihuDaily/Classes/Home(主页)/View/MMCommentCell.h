//
//  MMCommentCell.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMComment,MMCommentCell;
@protocol MMCommentCellDelegate <NSObject>

@optional
- (void)commentCell:(MMCommentCell *)cell teTweetLabelOpened:(BOOL)opened;
@end

@interface MMCommentCell : UITableViewCell
@property (nonatomic,strong)MMComment *comment;
@property (nonatomic,weak)id<MMCommentCellDelegate> delegate;
@end
