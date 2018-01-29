//
//  ECRBoomRecomment.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

//static CGFloat itemW = 72;
//static CGFloat itemH = 194;
//static CGFloat insetsLR = 11;
static CGFloat margin = 10;

#import "ECRBoomRecomment.h"
#import "ECRHeadlineView.h"
#import "ECRMultiObject.h"

@interface ECRBoomRecomment ()
/** collectionview cell 高 */
@property (assign,nonatomic) CGFloat itemH;
/** collectionview cell 宽 */
@property (assign,nonatomic) CGFloat itemW;
@property (assign,nonatomic) CGFloat headLineHeight;//
@property (strong,nonatomic) ECRHeadlineView *headLine;// 标题
/** 容器视图 */
@property (strong,nonatomic) UIView *lg_containerView;

@end


@implementation ECRBoomRecomment

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height{
    // height 230 ,ipad 240
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {// 6个 间距20
        self.itemW = (Screen_Width - 7 * [ECRMultiObject homeBookCoverSpace]) / 6;
        /// 书籍封面高度
        CGFloat imgHeight = self.itemW / [ECRMultiObject homebcwhRate];
        self.itemH = imgHeight + 65;
    }else{// 4个 间距10
        self.itemW = (Screen_Width - 5 * [ECRMultiObject homeBookCoverSpace]) / 4;

        CGFloat imgHeight = self.itemW / [ECRMultiObject homebcwhRate];
        self.itemH = imgHeight + 60;
    }

    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.headLine];
        [self.headLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(self.headLineHeight));
        }];
        [self addSubview:self.lg_containerView];
        [self.lg_containerView addSubview:self.collectionView];
        
        [self.lg_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headLine.mas_bottom);//.offset(5);
            make.left.equalTo(self.mas_left).offset(margin);
            make.right.equalTo(self.mas_right).offset(-margin);
            make.bottom.equalTo(self.mas_bottom).offset(-margin);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lg_containerView.mas_top);
            make.left.equalTo(self.lg_containerView.mas_left);
            make.right.equalTo(self.lg_containerView.mas_right);
            make.bottom.equalTo(self.lg_containerView.mas_bottom);
        }];
        [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
    }
    return self;
}
- (void)setBgWithColor:(UIColor *)color{
    self.backgroundColor = color;
}
- (void)skinWithType:(ECRHomeUIType)type{
    switch (type) {
        case ECRHomeUITypeDefault:{
            [self setBgWithColor:[UIColor whiteColor]];
        }
            break;
        case ECRHomeUITypeAdultTwo:{
            [self setBgWithColor:[UIColor clearColor]];
            self.collectionView.layer.borderColor = [LGSkinSwitchManager homeBorderColor].CGColor;
            self.collectionView.layer.borderWidth = 1;
        }
            break;
        case ECRHomeUITypeKidOne:{
            self.backgroundColor = [UIColor clearColor];
            CGFloat cr = 28;
            self.lg_containerView.layer.cornerRadius = cr;
            self.lg_containerView.layer.masksToBounds = YES;
            self.collectionView.layer.cornerRadius = cr;
            self.collectionView.layer.masksToBounds = YES;
            _headLine.iconImgName = @"icon_headline_duck";
            [self.lg_containerView unifySetShadow];
        }
            break;
        case ECRHomeUITypeKidtwo:{
            [self setBgWithColor:[UIColor whiteColor]];
        }
            break;
    }
    _headLine.iconImgName = @"icon_home_boom";
}
- (ECRHeadlineView *)headLine{
    if (_headLine == nil) {
        _headLine = [[ECRHeadlineView alloc] init];
        _headLine.headTitle = @"重磅推荐";
        _headLine.showMore = NO;
    }
    return _headLine;
}
- (UIView *)lg_containerView{
    if (_lg_containerView == nil) {
        _lg_containerView = [UIView new];
        _lg_containerView.backgroundColor = [UIColor whiteColor];
        _lg_containerView.clipsToBounds = YES;
    }
    return _lg_containerView;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.brFlowLayout];
        [_collectionView setContentInset:UIEdgeInsetsMake(0, self.insetsLR, 0, self.insetsLR)];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)brFlowLayout{
    if (_brFlowLayout == nil) {
        _brFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _brFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _brFlowLayout.itemSize = CGSizeMake(self.itemW, self.itemH);
        _brFlowLayout.minimumLineSpacing = [ECRMultiObject homeBookCoverSpace];// 横向,一行,控制每个之间的空间
        _brFlowLayout.minimumInteritemSpacing = 0;
    }
    return _brFlowLayout;
}
- (CGFloat)headLineHeight{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 46;
    }else{
        return 36;
    }
}
- (CGFloat)insetsLR{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return 11;
    }else{
        return 5;
    }
}


@end
