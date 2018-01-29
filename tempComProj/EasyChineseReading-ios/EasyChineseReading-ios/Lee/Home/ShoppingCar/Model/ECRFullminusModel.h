//
//  ECRFullminusModel.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/10.
//  Copyright © 2017年 retech. All rights reserved.
//

static NSString *ECRFullminusJuanViewClickNotification = @"ECRFullminusJuanViewClickNotification";

#import <Foundation/Foundation.h>

@interface ECRFullminusModel : NSObject
/** 满减卷描述 */
@property (copy,nonatomic) NSString *memo;
/** 满减卷英文描述 */
@property (copy,nonatomic) NSString *en_memo;
/** 减 金额 */
@property (strong,nonatomic) NSNumber *minusMoney;
/** 满减类型 */
@property (strong,nonatomic) NSNumber *fullminusType;
/** 满足金额 */
@property (strong,nonatomic) NSNumber *fullMoney;
@property (assign,nonatomic) CGFloat abtPrice;// 符合该满减卷的 书籍总价
/** eg:满10减5 */
@property (copy,nonatomic) NSString *fullminusTypeName;
/** eg:10 minud 5 */
@property (copy,nonatomic) NSString *en_fullminusTypeName;
/**
 1 可用
 0 不可用
 控制cell的背景图显示类型，和是否可点击
 0 显示灰色背景，且不可点击
 
 */
@property (assign,nonatomic) NSInteger isAva;

@property (assign,nonatomic) BOOL isSelected;// 是否选中
@property (copy,nonatomic) NSString *bgImgName;//

@property (strong,nonatomic) NSNumber *status;// 状态？
@property (strong,nonatomic) NSNumber *activeStatus;// 可用状态？
@property (strong,nonatomic) NSNumber *fullminuscode;// 满减卷code
@property (copy,nonatomic) NSString *endtime;// 满减结束日期
@property (copy,nonatomic) NSString *starttime;// 满减开始日期
@property (strong,nonatomic) NSNumber *fullminusNum;// 满减觉号码
@property (strong,nonatomic) NSNumber *seqid;// 满减卷id
@property (strong,nonatomic) NSNumber *activateuser;// 用户id

@end
