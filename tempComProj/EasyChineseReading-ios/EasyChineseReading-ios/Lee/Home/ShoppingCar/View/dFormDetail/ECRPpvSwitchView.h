//
//  ECRPpvSwitchView.h
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRPpvSwitchView;

typedef NS_ENUM(NSUInteger, ECRPpvSwitchViewSwitchTag) {
    ECRPpvSwitchViewSwitchTagFullminus = 101,
    ECRPpvSwitchViewSwitchTagScoreDedu,
};

@protocol ECRPpvSwitchViewDelegate <NSObject>

- (void)ppvsView:(ECRPpvSwitchView *)view offsetPoint:(CGPoint)offsetPoint;

@end


@interface ECRPpvSwitchView : UIView

- (void)switchBtnWithOffsetX:(CGFloat)offsetX;
@property (weak,nonatomic) id<ECRPpvSwitchViewDelegate> delegate;// 

@end
