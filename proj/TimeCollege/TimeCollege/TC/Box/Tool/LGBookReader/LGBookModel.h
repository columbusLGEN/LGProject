//
//  LGBookModel.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/22.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LGBookResourceType) {
    /** epub */
    LGBookResourceTypeEpub,
    /** PDF */
    LGBookResourceTypePDF,
    /** 超媒体 */
    LGBookResourceTypeHyperMedia,
};

@interface LGBookModel : LGBaseModel
/** 资源类型 */
@property (assign,nonatomic) LGBookResourceType resourceType;

@end

NS_ASSUME_NONNULL_END
