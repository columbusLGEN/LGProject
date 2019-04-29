//
//  TCBookDownloadModel.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCBookDownloadModel : LGBaseModel

/** 书籍的下载状态
    1.通过详情页 ”立即阅读进入的“，为已下载状态
    2.未下载的是哪种 情况?
 */

/** 书架的编辑状态，默认为NO */
@property (assign,nonatomic) BOOL editState;

@end

NS_ASSUME_NONNULL_END
