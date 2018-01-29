//
//  ECRSwichView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRSwichView;

@protocol ECRSwichViewDelegate <NSObject>

// 点击回调
- (void)ecrSwichView:(ECRSwichView *)view didClick:(NSInteger)click;//0 = 左

@end

@interface ECRSwichView : UIView

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height;

@property (weak,nonatomic) id<ECRSwichViewDelegate> delegate;

@property (strong,nonatomic) NSArray<NSString *> *buttonNames;


/**
 切换选择按钮

 @param item 0: 左; 1: 右
 */
- (void)switchSelectedItem:(NSInteger)item;

// 使用纯代码创建时,在initheight中指定self的高度
// xib创建时,该值为0,且在xib中需要指定self的高度
@property (assign,nonatomic) CGFloat customHeight;//

@end
