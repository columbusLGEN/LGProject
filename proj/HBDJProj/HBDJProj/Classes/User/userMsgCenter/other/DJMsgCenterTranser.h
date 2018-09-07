//
//  DJMsgCenterTranser.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 本类实例 负责消息中心的详情跳转 分流

#import <Foundation/Foundation.h>
@class UCMsgModel;

@interface DJMsgCenterTranser : NSObject

- (void)msgShowDetailVcWithModel:(UCMsgModel *)model nav:(UINavigationController *)nav;

@end
