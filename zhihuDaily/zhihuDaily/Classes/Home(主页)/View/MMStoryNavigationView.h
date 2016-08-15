//
//  MMStoryNavigationView.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/2.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMExtraStory,MMStoryNavigationView;
@protocol MMStoryNavigationViewDelegate <NSObject>

- (void)storyNavigationView:(MMStoryNavigationView *)naviView didClicked:(NSInteger)index;

@end

@interface MMStoryNavigationView : UIView
@property (nonatomic,strong)MMExtraStory *extraStory;
@property (nonatomic,weak)id<MMStoryNavigationViewDelegate> delegate;

+(instancetype)storyNaviView;
@end
