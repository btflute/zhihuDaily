//
//  MMAppSettings.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/6/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMAppSettings.h"

static NSString *const kNightMoodKey = @"kNightMoodKey";
@interface MMAppSettings ()
@property (nonatomic,strong)NSUserDefaults *userDefaults;
@end
@implementation MMAppSettings
+(instancetype)sharedSettings{
    static MMAppSettings *_settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [[MMAppSettings alloc]init];
    });
    return _settings;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        self.nightMood = [self.userDefaults boolForKey:kNightMoodKey];
        self.dk_manager.themeVersion = self.nightMood? DKThemeVersionNight : DKThemeVersionNormal;
    }
    return self;
}

-(void)setNightMood:(BOOL)nightMood{
    _nightMood = nightMood;
    [self.userDefaults setBool:nightMood forKey:kNightMoodKey];
    MMLog(@"%d",[self.userDefaults boolForKey:kNightMoodKey]);
    self.dk_manager.themeVersion = nightMood? DKThemeVersionNight : DKThemeVersionNormal;
}
@end
