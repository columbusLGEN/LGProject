//
//  LGThreeRightButtonView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickRequestSuccess)(NSInteger id,NSInteger count);
typedef void(^ClickRequestFailure)(void);

@protocol LGThreeRightButtonViewDelegate;

static NSString * const TRConfigTitleKey = @"TRConfigTitleKey";
static NSString * const TRConfigTitleColorNormalKey = @"TRConfigTitleColorNormalKey";
static NSString * const TRConfigTitleColorSelectedKey = @"TRConfigTitleColorSelectedKey";
static NSString * const TRConfigImgNameKey = @"TRConfigImgNameKey";
static NSString * const TRConfigSelectedImgNameKey = @"TRConfigSelectedImgNameKey";

@interface LGThreeRightButtonView : UIView

@property (assign,nonatomic) BOOL leftIsSelected;
@property (assign,nonatomic) BOOL middleIsSelected;
@property (assign,nonatomic) NSInteger likeCount;
@property (assign,nonatomic) NSInteger collectionCount;

@property (weak,nonatomic) NSArray<NSDictionary *> *btnConfigs;
/** 分割线是否顶头 */
@property (assign,nonatomic) BOOL bothSidesClose;

/** 隐藏 上分割线 */
@property (assign,nonatomic) BOOL hideTopLine;

/**  */
@property (weak,nonatomic) id<LGThreeRightButtonViewDelegate> delegate;

@end

@protocol LGThreeRightButtonViewDelegate <NSObject>
@optional
- (void)leftClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure;
- (void)middleClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure;
- (void)rightClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure;

@end
