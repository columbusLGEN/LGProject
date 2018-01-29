//
//  Constants.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

static CGFloat const cButtonHeight_40 = 40;     // 底部按键高度

// -----  header 高度
static CGFloat const cHeaderHeight_44 = 44;
static CGFloat const cHeaderHeight_54 = 54;
static CGFloat const cHeaderHeight_64 = 64;
static CGFloat const cHeaderHeight_88 = 88; // X高度
// -----

static CGFloat const cFooterHeight_44 = 44;
static CGFloat const cFooterHeight_83 = 83; // X tabBar高度

static CGFloat const cAnimationTime = 0.35; // 动画效果时间

// 长度限制 =====
/** 姓名 */
static NSInteger const cMaxNameLength = 24;
/** 密码最短长度 */
static NSInteger const cMinPasswordLength = 8;
/** 密码最长长度 */
static NSInteger const cMaxPasswordLength = 16;
/** 学校名 */
static NSInteger const cMaxSchoolLength = 40;
/** 居住地 */
static NSInteger const cMaxAddressLength = 100;
/** 兴趣爱好 */
static NSInteger const cMaxInterestLength = 200;
/** 意见反馈 */
static NSInteger const cMaxCommentLength = 400;
/** 班级名 */
static NSInteger const cMaxClassNameLength = 40;
/** 班级概况/备注 */
static NSInteger const cMaxClassDescLength = 200;
/** 推荐内容 */
static NSInteger const cMaxRecommendLength = 200;
/** 消息 */
static NSInteger const cMaxMessageLength = 200;
/** 分享内容 */
static NSInteger const cMaxShareLength = 200;
/** 搜索长度 */
static NSInteger const cMaxSearchLength = 40;
/** 学校地址 */
static NSInteger const cMaxSchoolAddressLength = 100;
// ======

static NSString *const cImageSelected   = @"icon_selected";     // 选中
static NSString *const cImageUnSelected = @"icon_selected_no"; // 未选中

static NSInteger const cListNumber_10 = 10;    // 列表每一页的数据量

static NSInteger const cFontSize_18 = 18;  // ipad 默认字体大小
static NSInteger const cFontSize_16 = 16;  // 默认字体大小
static NSInteger const cFontSize_14 = 14;  // 小号字
static NSInteger const cFontSize_12 = 12;  // 价格字号
static NSInteger const cFontSize_10 = 10;
static NSInteger const cFontSize_8  = 8;

// +++++
/** 展示书籍数量 pad */
static NSInteger const cCollectionNum_Pad = 6;
/** 展示书籍数量 phone */
static NSInteger const cCollectionNum_Phone = 4;
/** 间距 pad */
static CGFloat const cCollectionSpace_Pad = 20.f;
/** 间距 phone */
static CGFloat const cCollectionSpace_Phone = 10.f;
/** 图书封面高宽比 1.38 (18/13 = 1.384) */
static CGFloat const cCollectionScale = 1.38;
/** 系列封面高宽比 2.2 (11/5 = 2.2) */
static CGFloat const cSeriesScale = 2.2;
// +++++

#endif /* Constants_h */
