//
//  ECRThemeAera.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRThematicModel,ECRThemeAera;

@protocol ECRThemeAeraDelegate <NSObject>

- (void)taView:(ECRThemeAera *)view model:(ECRThematicModel *)model;

@end

@interface ECRThemeAera : UIView

@property (strong,nonatomic) NSArray<ECRThematicModel *> *models;//
@property (weak,nonatomic) id<ECRThemeAeraDelegate> delegate;//
- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height;
@end
