//
//  LGNineImgView.h
//  nineImgDemo
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat niMargin = 7;/// 图片间距
static CGFloat niImgWidth = 84;/// (266 - 2 * 7) / 3 , height = width

typedef void(^NineImgTapBlock)(NSInteger index, NSArray *dataSource);

@interface LGNineImgView : UIView

/** 元素为 UIImage 实例 或者 网络URL */
@property (strong,nonatomic) NSArray *dataSource;

@property (copy,nonatomic) NineImgTapBlock tapBlock;

@end
