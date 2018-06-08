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
/** 专辑下的微党课indexkey */
static NSString * const LGDidSelectedSubModelIndexKey = @"LGDidSelectedSubModelIndexKey";

/** 跳转类型 */
typedef NS_ENUM(NSUInteger, LGDidSelectedSkipType) {
    /** 微党课单条 */
    LGDidSelectedSkipTypeMicrolessonSingle,
    /** 微党课专辑 */
    LGDidSelectedSkipTypeMicrolessonAlbum,
    /** 党建要闻单条 */
    LGDidSelectedSkipTypeBuildNews,
    /** 数字阅读单条 */
    LGDidSelectedSkipTypeDigitalBook,
};

#endif /* LGDidSelectedNotification_h */
