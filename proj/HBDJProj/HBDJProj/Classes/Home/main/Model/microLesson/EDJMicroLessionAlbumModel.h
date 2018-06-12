//
//  EDJMicroLessionAlbumModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"
@class DJDataBaseModel;

@interface EDJMicroLessionAlbumModel : LGBaseModel

/// 专辑数据的 sort == 0表示普通展示，== 1 表示header第一个展示，== 2表示header 第二个展示

/** 专辑id */
@property (assign,nonatomic) NSInteger classid;
/** 专辑封面 */
@property (strong,nonatomic) NSString *classimg;
/** 专辑名 */
@property (strong,nonatomic) NSString *classname;
/** classlist */
@property (strong,nonatomic) NSArray<DJDataBaseModel *> *classlist;

///
/** 展示类型
 0 在cell中展示
 1 头部第一个展示
 2 头部第二个展示
 */
@property (assign,nonatomic) NSInteger showType;

@end
