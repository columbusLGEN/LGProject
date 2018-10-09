//
//  DJDsSearchTagView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@interface DJDsSearchTagView : LGBaseView

/** 隐藏 已添加的标签视图 */
- (void)hideSelectLabelViewWithAllHeight:(CGFloat)allHeight;
/** 是否显示上面的容器视图 */
- (void)showFirstItemWith:(BOOL)show selectHeight:(CGFloat)selectHeight allHeight:(CGFloat)allHeight;

/** 第一项标题 */
@property (weak,nonatomic) NSString *firstTitle;
/** 第二项标题 */
@property (weak,nonatomic) NSString *secondTitle;
/** 第一项标签字号 */
@property (assign,nonatomic) NSInteger fontOfFirstTitle;
/** 第二项标签字号 */
@property (assign,nonatomic) NSInteger fontOfSecondTitle;
/** 第一项标题字色 */
@property (weak,nonatomic) UIColor *textColorFirstTitle;
/** 第二项标题字色 */
@property (weak,nonatomic) UIColor *textColorSecondTitle;
/** 第一项的附加标题 */
@property (weak,nonatomic) UILabel *subTitleOfFirstItem;

@property (strong,nonatomic) NSArray *records;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (weak,nonatomic) UIButton *removeHis;
/** 热们标签容器、上容器视图 */
@property (strong,nonatomic) UIView *conHot;
/** 历史记录容器、下容器视图 */
@property (strong,nonatomic) UIView *hisConView;

@end
