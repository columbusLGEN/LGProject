//
//  ECRBoomRecomment.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECRBoomRecomment : UIView
@property (strong,nonatomic) UICollectionView *collectionView;// 
@property (strong,nonatomic) UICollectionViewFlowLayout *brFlowLayout;//boomRecomment 布局参数
- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height;

@end
