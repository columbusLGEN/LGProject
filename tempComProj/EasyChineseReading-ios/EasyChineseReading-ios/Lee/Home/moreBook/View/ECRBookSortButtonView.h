//
//  ECRBookSortButtonView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECRBookSortButtonView;

@protocol ECRBookSortButtonViewDelegate <NSObject>

- (void)bsbView:(ECRBookSortButtonView *)view selected:(BOOL)selected;
- (void)bsbView:(ECRBookSortButtonView *)view isDesOrder:(BOOL)isDesOrder;

@end

@interface ECRBookSortButtonView : UIView

@property (copy,nonatomic) NSString *name;// <##>
@property (assign,nonatomic) BOOL selected;// 
@property (weak,nonatomic) id<ECRBookSortButtonViewDelegate> delegate;//

@end
