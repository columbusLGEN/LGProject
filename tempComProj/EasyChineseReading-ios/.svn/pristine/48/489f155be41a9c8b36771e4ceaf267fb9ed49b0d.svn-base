//
//  UCRBooksShopCarView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"
#import "UCRecommendMaskingView.h"
#import "UCRBooksSelectedView.h"

@class UCRBooksShopCarView;

@protocol UCRBooksShopCarViewDelegate <NSObject>

- (void)nextStep;

@end

@interface UCRBooksShopCarView : ECRBaseView

@property (weak, nonatomic) id<UCRBooksShopCarViewDelegate> delegate;

@property (strong, nonatomic) UCRBooksSelectedView *bookSelectedView;    //选择的订单列表

@property (assign, nonatomic) ENUM_RecommendType recommendType; // 推荐类型

@property (strong, nonatomic) UIButton *btnShowSelectedBooks;           // 查看选中的书籍
@property (strong, nonatomic) UIButton *btnNextSelectedStudents;        // 下一步选择学生

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)parentView recommendType:(ENUM_RecommendType)type;
- (void)dismissWithAnimated:(BOOL)animated;
- (void)setSelectedBooksNumber:(NSInteger)number;
- (void)updateFrame:(UCRBooksSelectedView *)bookSelectedView;

@end
