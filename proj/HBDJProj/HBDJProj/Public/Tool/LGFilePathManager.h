//
//  LGFilePathManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LGFilePathRootPath) {
    /** 目标保存根目录为 document */
    LGFilePathRootPathDocument,
    /** 目标保存根目录为 library */
    LGFilePathRootPathLibrary
};

@interface LGFilePathManager : NSObject

@property (assign,nonatomic) LGFilePathRootPath rootPath;

- (NSString *)dj_testFileNamePathWithTestid:(NSInteger)testid;

///** 创建文件,指定根目录rootpath,传入二级目录名和文件名 */
//- (NSString *)createFilePathWithRootPath:(LGFilePathRootPath)rootPath directryName:(NSString *)directryName fileName:(NSString *)fileName;

+ (instancetype)sharedInstance;
@end
