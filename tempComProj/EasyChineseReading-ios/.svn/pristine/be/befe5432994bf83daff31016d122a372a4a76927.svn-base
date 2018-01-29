//
//  ECRBrebAlertView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/26.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRBrebAlertView;
@protocol ECRBrebAlertViewDelegate <NSObject>

- (void)brebAlert:(ECRBrebAlertView *)view clickEvent:(BOOL)isDelete;

@end


@interface ECRBrebAlertView : UIView

@property (assign,nonatomic) NSInteger countForRemove;// 
@property (weak,nonatomic) id<ECRBrebAlertViewDelegate> delegate;// <##>

@end
