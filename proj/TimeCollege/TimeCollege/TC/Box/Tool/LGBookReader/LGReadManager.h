//
//  LGReadManager.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/22.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 功能:
 根据模型 打开不同类型的 阅读器
 
 epub   LGBookResourceTypeEpub
 pdf    LGBookResourceTypePDF
 超媒体  LGBookResourceTypeHyperMedia
 
 
 */

@class TCMyBookrackModel;

@interface LGReadManager : NSObject

- (void)openBookWithModel:(TCMyBookrackModel *)model vc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
