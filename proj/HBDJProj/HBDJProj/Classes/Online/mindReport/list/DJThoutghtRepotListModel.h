//
//  DJThoutghtRepotListModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 思想汇报 & 述职述廉 列表模型

#import "LGBaseModel.h"

@interface DJThoutghtRepotListModel : LGBaseModel

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *createdtime;
@property (strong,nonatomic) NSString *uploader;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *fileurl;

@end
