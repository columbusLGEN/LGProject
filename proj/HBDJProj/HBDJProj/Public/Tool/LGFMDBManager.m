//
//  LGFMDBManager.m
//  FMDBDemo
//
//  Created by Peanut Lee on 2018/9/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGFMDBManager.h"
#import "FMDB.h"

@implementation LGFMDBManager{
    FMDatabase *_db;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        /// open DB
        _db = [FMDatabase databaseWithPath:self.dj_db_path];
        if ([_db open]) {
            NSLog(@"打开成功 -- %@",self.dj_db_path);
        }else{
            NSLog(@"打开数据库失败");
        }
        
        /// 创建表
        BOOL createTable = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL, sex text NOT NULL);"];
        if (createTable) {
            NSLog(@"创建表成功: ");
        }else{
            NSLog(@"创建表失败: ");
        }
        
        /// 插入数据
        NSString *name = [NSString stringWithFormat:@"王子涵%@",@(1)];
        NSString *sex = @"女";
        
        BOOL result = [_db executeUpdate:@"INSERT INTO t_student (name, age, sex) VALUES (?,?,?)",name,@(18),sex];
        
        if (result) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
        
        
    }
    return self;
}

- (NSString *)dj_db_path{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [document stringByAppendingPathComponent:@"dj_db"];
}

CM_SINGLETON_IMPLEMENTION
@end
