//
//  DJOnlineUploadTableModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, OLUploadTableModelClass) {
    OLUploadTableModelClassTextInput,   /// 文本输入
    OLUploadTableModelClassSelectTime,  /// 选择时间
    OLUploadTableModelClassSelectPeople,/// 选择人员
    OLUploadTableModelClassSelectImage, /// 选择图片
    OLUploadTableModelClassSelectCover  /// 选择封面
};

@interface DJOnlineUploadTableModel : LGBaseModel
/** 项目名 */
@property (strong,nonatomic) NSString *itemName;
/** 项目类型 */
@property (assign,nonatomic) OLUploadTableModelClass itemClass;

@end
