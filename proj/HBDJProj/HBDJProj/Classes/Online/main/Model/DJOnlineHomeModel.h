//
//  DJOnlineHomeModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@class OLHomeModel;

@interface DJOnlineHomeModel : LGBaseModel

/** 已经激活 */
@property (strong,nonatomic) NSArray<OLHomeModel *> *activation;
/** 未激活 */
@property (strong,nonatomic) NSArray<OLHomeModel *> *notactive;

/** 在线首页顶部图片链接 */
@property (strong,nonatomic) NSString *headlineImg;

@end
