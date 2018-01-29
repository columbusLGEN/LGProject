//
//  ECRBookClasses.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//
//static CGFloat bcHeight = 126;// 分类

#import "ECRBookClasses.h"

@interface ECRBookClasses ()
@property (assign,nonatomic) CGFloat bcHeight;//

@end

@implementation ECRBookClasses

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height{
    self.bcHeight = height;
    return [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.collectionView.backgroundColor = [UIColor redColor];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.bcFlowLayout];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)bcFlowLayout{
    if (_bcFlowLayout == nil) {
        _bcFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bcFlowLayout.itemSize = CGSizeMake((Screen_Width / 4), self.bcHeight);
        _bcFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bcFlowLayout.minimumLineSpacing = 0;
        _bcFlowLayout.minimumInteritemSpacing = 0;
    }
    return _bcFlowLayout;
}



@end
