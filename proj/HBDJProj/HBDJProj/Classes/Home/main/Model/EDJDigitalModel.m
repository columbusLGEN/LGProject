//
//  EDJDigitalModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJDigitalModel.h"
#import "LGLocalFileManager.h"

@implementation EDJDigitalModel

- (NSString *)progressForUI{
    return [NSString stringWithFormat:@"上次阅读进度：%.0f%@",self.progress,@"%"];
}

- (CGFloat)progress{
//    _progress = 0.57;
    return _progress * 100;
}

- (NSString *)localUrl{
    if (!_localUrl) {
        _localUrl = [[LGLocalFileManager sharedLocalFileManager].filePath stringByAppendingString:[NSString stringWithFormat:@"/DJDigital_%@.epub",[NSString stringWithFormat:@"%ld",self.seqid]]];
    }
    return _localUrl;
}

@end
