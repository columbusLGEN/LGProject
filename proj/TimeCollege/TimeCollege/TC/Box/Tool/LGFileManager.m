//
//  LGFileManager.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/20.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGFileManager.h"

@implementation LGFileManager

+ (void)removeFile:(NSString *)path{
    NSError *error;
    
    BOOL remove = [self.defaultManager removeItemAtPath:path error:&error];
    if (remove) {
        NSLog(@"removeFile_success ");
    }else{
        NSLog(@"removeFile_error: %@",error);
    }
}

@end
