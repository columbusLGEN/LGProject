//
//  ECRSearchTitleView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECRSearchTitleView;

@protocol ECRSearchTitleViewDelegate <NSObject>

// 关闭
- (void)stViewClose:(ECRSearchTitleView *)view;

@optional
// 搜索
- (void)stView:(ECRSearchTitleView *)view content:(NSString *)content;// content 搜索内容

@end

@interface ECRSearchTitleView : UIView

@property (copy,nonatomic) NSString *lg_placeHolder;// 占位文字
@property (weak,nonatomic) id<ECRSearchTitleViewDelegate> delegate;

- (void)lg_becomResponser;
- (void)setWhiteLine;

@end
