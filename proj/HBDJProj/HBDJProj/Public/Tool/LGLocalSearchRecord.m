//
//  LGLocalSearchRecord.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

/**
    搜索记录文件数据结构：
        [{key:value},{key:value}]
 */

#import "LGLocalSearchRecord.h"

@interface LGLocalSearchRecord ()
@property (strong,nonatomic) NSString *rootDirectory;
@property (strong,nonatomic) NSString *filePath;
@property (strong,nonatomic) NSString *directoryPath;
@property (strong,nonatomic) NSFileManager *manager;

@property (assign,nonatomic) SearchRecordExePart currentExePart;

@end

@implementation LGLocalSearchRecord

/** 删除本地所有数据 */
+ (void)removeLocalRecord{
    [[self sharedInstance] removeLocalRecord];
}
- (void)removeLocalRecord{
    /// 1.判断、创建目录 --> 判断、创建 文件
    [self createDirectoryPath];
    
    /// 2.写入数据
    /// 获取本地文件
    NSArray *recordArray = [NSArray arrayWithContentsOfFile:self.filePath];
    
    NSMutableArray *recordMutable = [NSMutableArray arrayWithArray:recordArray];
    [recordMutable removeAllObjects];
    
    BOOL write = [recordMutable writeToFile:self.filePath atomically:YES];
    if (write) {
        NSArray *recordArray = [NSArray arrayWithContentsOfFile:self.filePath];
        NSLog(@"清空成功 -- %d: %@",write,recordArray);
    }
}

+ (NSArray *)getLocalRecordWithPart:(SearchRecordExePart)part{
    return [[self sharedInstance] getLocalRecordWithPart:part];
}
- (NSArray *)getLocalRecordWithPart:(SearchRecordExePart)part{
    _currentExePart = part;
    
    NSArray *record = [NSArray arrayWithContentsOfFile:self.filePath];
    NSLog(@"userid: %@,:%@,lg_record: %@",self.userId,[self currentExePartWith:part],record);
    
    return record;
}
/**
 添加新的历史记录（向本地文件中）

 @param content 用户输入的内容
 @param part 当前模块，首页：home
 */
+ (void)addNewRecordWithContent:(NSString *)content part:(SearchRecordExePart)part{
    [[self sharedInstance] addNewRecordWithContent:content part:part];
}
- (void)addNewRecordWithContent:(NSString *)content part:(SearchRecordExePart)part{
    _currentExePart = part;
    
    /// 1.判断、创建目录 --> 判断、创建 文件
    [self createDirectoryPath];
    
    /// 2.写入数据
    /// 获取本地文件
    NSArray *recordArray = [NSArray arrayWithContentsOfFile:self.filePath];
    
    /// 写入之前 先判断 是否 重复
    BOOL repeat = NO;
    for (NSString *localContent in recordArray) {
        if ([content isEqualToString:localContent]) {
            repeat = YES;
        }
    }
    if (!repeat) {
        /// 建立新的数组
        NSMutableArray *recordMutable = [NSMutableArray arrayWithArray:recordArray];
        /// 插入
        [recordMutable insertObject:content atIndex:0];
        /// 写入
        BOOL write = [recordMutable writeToFile:self.filePath atomically:YES];
        if (write) {
            NSArray *recordArray = [NSArray arrayWithContentsOfFile:self.filePath];
            NSLog(@"写入成功 -- %d: %@",write,recordArray);
        }
    }else{
        NSLog(@"重复数据: 不写入");
    }
}

- (void)createDirectoryPath{
    /// 先创建目录，再创建文件
    BOOL isDirectory;
    BOOL directoryExist = [self.manager fileExistsAtPath:self.directoryPath isDirectory:&isDirectory];
    /// 判断目录是否存在，如果存在，直接创建文件
    
    if (directoryExist) {
        [self createFilePath];
    }else{
        /// 否则 先创建目录，再创建文件
        NSError *error;
        BOOL createDirectory = [self.manager createDirectoryAtPath:self.directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (createDirectory) {
            NSLog(@"创建路径成功: %@",self.directoryPath);
            [self createFilePath];
        }else{
            NSLog(@"创建路径失败: %@",error);
        }
    }
}
- (void)createFilePath{
    if (![self isExist:self.filePath]) {
        BOOL createPath = [self.manager createFileAtPath:self.filePath contents:nil attributes:nil];
        NSLog(@"创建本地搜索记录文件，1成功，0失败-- %d",createPath);
    }else{
        NSLog(@"本地搜索记录文件已存在，路径为 -- %@",self.filePath);
    }
}

-(NSString *)rootDirectory{
    if (!_rootDirectory) {
        _rootDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _rootDirectory;
}
/// directoryPath 和 filePath 可能会变化，所以不能懒加载，而是每次都生成新的值
- (NSString *)directoryPath{
    return [self.rootDirectory stringByAppendingString:[NSString stringWithFormat:@"/lg_search_record/%@",self.userId]];
}
- (NSString *)filePath{
    /// 路径为：library/record/"userid"/home.plist 或者 library/record/"userid"/discovery.plist
    return [self.directoryPath stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",[self currentExePartWith:_currentExePart]]];
}
- (NSFileManager *)manager{
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    return _manager;
}

- (NSString *)currentExePartWith:(SearchRecordExePart)part{
    switch (part) {
        case SearchRecordExePartHome:
            return @"home";
            break;
        case SearchRecordExePartDiscovery:
            return @"discovery";
            break;
        case SearchRecordExePartOnline:
            return @"online";
            break;
    }
    
}

/**
 搜索记录的key
 /// userid,模块_index
 /// 例如: userid == 123, 模块为首页,index == 0 key: userid_123,home_1;

 @param userid 当前用户id
 @param part 搜索模块，首页，发现等
 @param index 此条记录的索引
 @return 返回目标key值
 */
- (NSString *)recordKeyWithUserid:(NSString *)userid part:(SearchRecordExePart)part index:(NSInteger)index{
    return [NSString stringWithFormat:@"userid_%@,%@_%ld",userid,[self currentExePartWith:part],index];
}
- (BOOL)isExist:(NSString *)path{
    return [self.manager fileExistsAtPath:path];
}

- (NSString *)userId{
    return [DJUser sharedInstance].userid;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
@end
