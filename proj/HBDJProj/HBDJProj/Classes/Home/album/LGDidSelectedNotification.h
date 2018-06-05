//
//  LGDidSelectedNotification.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#ifndef LGDidSelectedNotification_h
#define LGDidSelectedNotification_h

static NSString * const LGDidSelectedNotification = @"LGDidSelectedNotification";
static NSString * const LGDidSelectedModelKey = @"LGDidSelectedModelKey";
static NSString * const LGDidSelectedSkipTypeKey = @"LGDidSelectedSkipTypeKey";

static NSString * const LGDidSelectedIndexKey = @"LGDidSelectedIndexKey";

/// 微党课单条
/// 微党课专辑
/// 党建要闻单条
/// 数字阅读单条
typedef NS_ENUM(NSUInteger, LGDidSelectedSkipType) {
    LGDidSelectedSkipTypeMicrolessonSingle,
    LGDidSelectedSkipTypeMicrolessonAlbum,
    LGDidSelectedSkipTypeBuildNews,
    LGDidSelectedSkipTypeDigitalBook,
};

#endif /* LGDidSelectedNotification_h */
