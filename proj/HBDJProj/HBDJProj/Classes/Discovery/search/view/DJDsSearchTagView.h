//
//  DJDsSearchTagView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@interface DJDsSearchTagView : LGBaseView

@property (strong,nonatomic) NSArray *records;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (weak,nonatomic) UIButton *removeHis;
/** 热们标签容器 */
@property (strong,nonatomic) UIView *conHot;
/** 历史记录容器 */
@property (strong,nonatomic) UIView *hisConView;

@end
