//
//  OLHomeModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, ControllerInitType) {
    ControllerInitTypeCode,
    ControllerInitTypeStoryboard,
};

@interface OLHomeModel : LGBaseModel

/** 获取 “更多” 项 */
+ (instancetype)loadItemOfMore;

/** 1: 默认激活
    0:
    该字段用于后台判断，客户端不处理
 */
@property (assign,nonatomic) BOOL isDefault;
@property (strong,nonatomic) NSString *toolname;
@property (strong,nonatomic) NSString *iconUrl;
/** 孝感党建 加载链接 */
@property (strong,nonatomic) NSString *xiaoganurl;

/// 本地图标name
@property (strong,nonatomic) NSString *locaImage;

@property (assign,nonatomic) OnlineModelType modelType;

@end
