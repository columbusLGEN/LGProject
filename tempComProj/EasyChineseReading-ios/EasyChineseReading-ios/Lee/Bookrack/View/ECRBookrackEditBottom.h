//
//  ECRBookrackEditBottom.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/26.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRBookrackEditBottom;

@protocol ECRBookrackEditBottomDelegate <NSObject>

- (void)brebDeleteClick:(ECRBookrackEditBottom *)view;

@end

@interface ECRBookrackEditBottom : UIView

@property (weak,nonatomic) id<ECRBookrackEditBottomDelegate> delegate;// 

@end
