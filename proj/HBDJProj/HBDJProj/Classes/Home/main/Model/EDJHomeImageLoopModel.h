//
//  EDJHomeImageLoopModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJDataBaseModel.h"

@interface EDJHomeImageLoopModel : DJDataBaseModel
/** 图片地址 */
@property (strong,nonatomic) NSString *classimg;
/** 详情数据的主键id */
@property (assign,nonatomic) NSInteger newsid;

/** 点击轮播图跳转至音视频会用到 */
@property (strong,nonatomic) DJDataBaseModel *frontNews;


@end
