//
//  ECRSeriesBooksView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRSeriesModel;
@interface ECRSeriesBooksView : UIView

@property (copy,nonatomic) NSString *imgName;//
@property (strong,nonatomic) UICollectionView *collectionView;// <##>

@property (strong,nonatomic) ECRSeriesModel *model;//
- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height;

@end
