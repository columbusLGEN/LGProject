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

- (NSString *)localUrl{
    if (!_localUrl) {
        _localUrl = [[LGLocalFileManager sharedLocalFileManager].filePath stringByAppendingString:[NSString stringWithFormat:@"/DJDigital_%@.epub",[NSString stringWithFormat:@"%ld",self.seqid]]];
    }
    return _localUrl;
}

@end
