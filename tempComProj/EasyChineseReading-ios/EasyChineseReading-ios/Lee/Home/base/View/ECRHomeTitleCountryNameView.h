//
//  ECRHomeTitleCountryNameView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/2.
//  Copyright © 2017年 retech. All rights reserved.
//

// 首页定位 浮框

#import "ECRBaseView.h"
@class ECRHomeTitleCountryNameView;

@protocol ECRHomeTitleCountryNameViewDelegate <NSObject>

- (void)htcnViewClose:(ECRHomeTitleCountryNameView *)view;

@end

@interface ECRHomeTitleCountryNameView : ECRBaseView

- (instancetype)initWithCountryName:(NSString *)countryName frame:(CGRect)frame titleFrame:(CGRect)titleFrame;
@property (weak,nonatomic) id<ECRHomeTitleCountryNameViewDelegate> delegate;//

@end
