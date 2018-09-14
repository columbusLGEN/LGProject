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

/** 是否为默认工具,如果是默认工具，则跳转时不需要判断 过期时间 */
@property (assign,nonatomic) BOOL isDefault;
@property (strong,nonatomic) NSString *toolname;
@property (strong,nonatomic) NSString *iconUrl;
/** 孝感党建 加载链接 */
@property (strong,nonatomic) NSString *xiaoganurl;

/// 本地图标name
@property (strong,nonatomic) NSString *locaImage;

@property (assign,nonatomic) OnlineModelType modelType;
/** 工具过期时间 */
@property (strong,nonatomic) NSString *toolendtime;

@end
