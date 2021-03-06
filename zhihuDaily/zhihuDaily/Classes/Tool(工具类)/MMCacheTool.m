//
//  MMCacheTool.m
//  zhihuDaily
//
//  Created by  陈聪 on 16/8/21.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MMCacheTool.h"
#import "FMDB.h"
#import "SYTheme.h"
#import "MMHomeStoryStoryItem.h"
#import "MMHomeStoryItem.h"
#import "MMThemeItem.h"
#import "MMDetailStory.h"
static FMDatabaseQueue *_zhihu_queue;
@implementation MMCacheTool
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dbname = [NSString stringWithFormat:@"%@.cache.sqlite",@"zhihu"];
        NSString *fullPath = [path stringByAppendingPathComponent:dbname];
        _zhihu_queue = [FMDatabaseQueue databaseQueueWithPath:fullPath];
        [_zhihu_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS mm_homelist (id INTEGER PRIMARY KEY AUTOINCREMENT,date INTEGER UNIQUE,storylist BLOB);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS mm_homelatest (date INTEGER PRIMARY KEY,homelatest BLOB);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS mm_themelatest (themeid INTEGER PRIMARY KEY,themelatest BLOB);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS mm_datailstory (id INTEGER PRIMARY KEY AUTOINCREMENT,storyid INTEGER UNIQUE,story BLOB);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS mm_themedatailstory (id INTEGER PRIMARY KEY AUTOINCREMENT,storyid INTEGER UNIQUE,themeid INTEGER,story BLOB);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS mm_themelist (id INTEGER PRIMARY KEY AUTOINCREMENT,themeid INTEGER UNIQUE,theme BLOB)"];
        }];
    });
}
+(FMDatabaseQueue *)queue{
    return _zhihu_queue;
}
+ (void)cacheThemeWithTheme:(SYTheme *)theme{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *sql = @"REPLACE INTO mm_themelist(theme,themeid) VALUES (?,?);";
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theme];
            [db executeUpdate:sql,data,@(theme.id)];
        }];
    });
}
+ (NSArray *)queryThemes{
    __block NSMutableArray *array = [@[] mutableCopy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *sql = @"SELECT theme FROM mm_themelist order by id asc;";
            FMResultSet * result = [db executeQuery:sql];
            while (result.next) {
                NSData *data =[result dataForColumnIndex:0];
                SYTheme *theme = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [array addObject:theme];
            }
        }];
    });
    return array;
}

+(MMHomeStoryItem *)queryStoryListWithDate:(NSString *)dateString{
    __block NSData *data = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:@"SELECT storylist FROM mm_homelist where date = ?;",dateString];
            if (result.next) {
                data = [result dataForColumnIndex:0];
                
            }
            [result close];
        }];
    });
    if (data.length > 0) {
        MMHomeStoryItem *temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        temp.date = dateString;
        return  temp;
    }
    return nil;
}

+ (void)cacheStoryListWithItem:(MMHomeStoryItem *)item{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [[self queue] inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"REPLACE INTO mm_homelist (date,storylist) VALUES (?,?);",item.date,data ];
        }];
    });
}

+(MMHomeStoryItem *)queryStoryLatest{
    __block NSData *data = nil;
    __block NSString *date = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:@"SELECT homelatest,date FROM mm_homelatest order by date desc limit 1;"];
            if (result.next) {
                MMLog(@"%@",[result columnNameToIndexMap]);
                data = [result dataForColumnIndex:0];
                date = [result stringForColumn:@"date"];
                
            }
            [result close];
        }];
    });
    if (data.length > 0) {
        MMHomeStoryItem *item  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        item.date = date;
        MMLog(@"%@",date);
        return  item;
    }
    return nil;
}

+ (void)cacheStoryLatestWithItem:(MMHomeStoryItem *)item {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [[self queue] inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"REPLACE INTO mm_homelatest(date,homelatest) VALUES (?,?);",item.date,data ];
        }];
    });
}

+ (void)cacheThemeLatestWithItem:(MMThemeItem *)item themeid:(int)ID{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [[self queue] inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"REPLACE INTO mm_themelatest(themeid,themelatest) VALUES (?,?);",@(ID),data ];
        }];
    });
}

+ (MMThemeItem *)queryThemeLatestWithThemeid:(int)ID{
    __block NSData *data = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:@"SELECT themelatest FROM mm_themelatest  where themeid = ?;",@(ID) ];
            if (result.next) {
                data = [result dataForColumnIndex:0];

            }
        }];
    });
    if (data.length >0) {
        MMThemeItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return item;
    }
    return nil;
}

+(MMDetailStory *)queryStoryWithID:(long long)ID{
    __block NSData *data = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self queue]inDatabase:^(FMDatabase *db) {
            FMResultSet *result  = [db executeQuery:@"SELECT story FROM mm_datailstory WHERE storyid = ?;",@(ID)];
            if (result.next) {
                data = [result dataForColumnIndex:0];
            }
        }];
    });
    if (data.length >0) {
        return (MMDetailStory *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
    
}

+(void)cacheStoryWithObject:(MMDetailStory *)story{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self queue]inDatabase:^(FMDatabase *db) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:story];
            [db executeUpdate:@"REPLACE INTO mm_datailstory (storyid,story) VALUES (?,?);",@(story.id),data];
        }];
    });
}

+(void)cacheThemeStoryListWithID:(int)themeid story:(MMHomeStoryStoryItem *)story{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSData *data= [NSKeyedArchiver archivedDataWithRootObject:story];
            [db executeUpdate:@"REPLACE INTO mm_themedatailstory (storyid,themeid,story ) VALUES (?,?,?);",@(story.id),@(themeid),data];
            
        }];
    });
}

+(NSMutableArray *)queryThemeStoryListWithMinID:(long long)storyid themeid:(int)themeid{
    __block NSMutableArray *arrayM = [@[] mutableCopy];
    if (storyid == 0) {
        storyid = MAXFLOAT;
    }
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet * result = [db executeQuery:@"SELECT story FROM mm_themedatailstory WHERE storyid < ? AND themeid = ? ORDER BY storyid desc LIMIT 20",@(storyid),@(themeid)];
            while (result.next) {
                NSData *data = [result dataForColumnIndex:0];
                MMHomeStoryStoryItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [arrayM addObject:item];
            }
            [result close];
        }];
    });
    return arrayM;
}
@end
