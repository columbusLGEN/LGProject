//
//  DJOnlineUplaodAddImgCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 添加会议图片的cell，带九宫格选则图片

#import "DJOnlineUplaodBaseCell.h"

@class HXPhotoView;

static NSString * addImgCell = @"DJOnlineUplaodAddImgCell";

@interface DJOnlineUploadAddImgCell : DJOnlineUplaodBaseCell
/** 该view 由控制器创建 set给cell */
@property (weak,nonatomic) HXPhotoView *photoView;

@end
