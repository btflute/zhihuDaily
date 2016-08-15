//
//  MMThemeItem.h
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/10.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMHomeStoryStoryItem,MMEditor;
@interface MMThemeItem : NSObject
@property (nonatomic,strong)NSMutableArray<MMHomeStoryStoryItem *> *stories;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *background;
@property (nonatomic,assign)long color;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,strong)NSArray<MMEditor*> *editors;
@property (nonatomic,copy)NSString *image_source;
@end
