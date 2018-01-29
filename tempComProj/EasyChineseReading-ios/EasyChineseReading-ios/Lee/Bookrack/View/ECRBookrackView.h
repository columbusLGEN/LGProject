//
//  ECRBookrackView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"

@class ECRBookrackModel,ECRBookrackView,ECRBookrackFlowLayout;

@protocol ECRBookrackViewDelegate <NSObject>

- (void)brView:(ECRBookrackView *)brViiew didSelectBookrack:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (void)brViewDidSwitch:(ECRBookrackView *)brViiew place:(NSInteger)place;// place:1=全部图书 2=已购买

@end

@interface ECRBookrackView : ECRBaseView

- (instancetype)initWithFrame:(CGRect)frame flowLayout:(ECRBookrackFlowLayout *)flowLayout abLayout:(ECRBookrackFlowLayout *)abLayout;

@property (strong,nonatomic) UIScrollView *firstFloor;// 容器
@property (strong,nonatomic) UICollectionView *allOfBooks;// 书架 已购买列表
@property (strong,nonatomic) UICollectionView *bookrack;// 书架 已购买列表
@property (weak,nonatomic) id<ECRBookrackViewDelegate> delegate;
@property (assign,nonatomic) UIEdgeInsets insets;//

@end
