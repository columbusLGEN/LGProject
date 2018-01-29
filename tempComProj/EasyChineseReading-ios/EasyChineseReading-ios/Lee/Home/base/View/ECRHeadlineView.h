//
//  ECRHeadlineView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseView.h"

@interface ECRHeadlineView : ECRBaseView

@property (copy,nonatomic) NSString *headTitle;//
@property (assign,nonatomic) BOOL showMore;// 1 = 显示更多按钮，
@property (strong,nonatomic) UIButton *more;//
@property (copy,nonatomic) NSString *iconImgName;//


@end
