//
//  ECRFloderView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/9.
//  Copyright © 2017年 lee. All rights reserved.
//


static CGFloat trDoneTopOffset = 25;
static CGFloat trDoneRightOffset = 15;
//static CGFloat fntOffset = 100;// floder name top
static CGFloat cTopOffset = 15;// collection view leave flodername.bottom
//static CGFloat margin = 10;// collection item 间距
static CGFloat insetsMargin = 10;// collection view insets edge

#import "ECRFloderView.h"
#import "ECRBookFloderLayout.h"

@interface ECRFloderView ()
@property (strong, nonatomic) UIVisualEffectView *effectView;// 毛玻璃
@property (strong,nonatomic) ECRBookrackFlowLayout *brLayout;//
@property (strong,nonatomic) UIButton *trDone;// top right done -- 编辑状态下显示
@property (strong,nonatomic) UIButton *tbClose;// 关闭floder 按钮
@property (strong,nonatomic) UIButton *asButto;// 全选按钮 all select,--> 编辑状态下显示

@property (assign,nonatomic) CGFloat fntOffset;//

@end

@implementation ECRFloderView

// MARK: 全选
- (void)asButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(floderViewAllSelect:)]) {
        [self.delegate floderViewAllSelect:self];
    }
}

- (void)closeFloder:(UIButton *)sender {
    // 通知代理, 关闭文件夹
    if ([self.delegate respondsToSelector:@selector(floderViewClose:)]) {
        [self.delegate floderViewClose:self];
    }
}

- (void)trDoneClick:(UIButton *)button{
    // 退出编辑状态
    if ([self.delegate respondsToSelector:@selector(floderViewEndEdit:)]) {
        [self.delegate floderViewEndEdit:self];
    }
//    [self rg_collectionViewReload];
}

- (void)setBookModels:(NSMutableArray *)bookModels{
    _bookModels = bookModels;
    _brLayout.itemSize;// 不能删
    _brLayout.minimumInteritemSpacing = _brLayout.minimunBookSpace;
    [self.collectionView reloadData];
}

- (void)setFileName:(NSString *)fileName{
    _fileName = fileName;
    _floderName.text = fileName;
}
- (void)setIsEdit_br:(BOOL)isEdit_br{
    _isEdit_br = isEdit_br;
    self.asButto.hidden = !isEdit_br;
    self.trDone.hidden = !isEdit_br;
}
- (instancetype)initWithFrame:(CGRect)frame flowLayout:(ECRBookFloderLayout *)flowLayout{
    self.brLayout = flowLayout;
    return [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIBlurEffect *effectBg = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effectBg];
        [self addSubview:_effectView];
        [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom).offset(-49);
            make.right.equalTo(self.mas_right);
        }];
        
        _tbClose = [[UIButton alloc] init];
        [_effectView.contentView addSubview:_tbClose];
        [_tbClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
        [_tbClose addTarget:self action:@selector(closeFloder:) forControlEvents:UIControlEventTouchUpInside];
        
        _asButto = [[UIButton alloc] init];
        [_asButto setTitle:LOCALIZATION(@"全选") forState:UIControlStateNormal];
        [_asButto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _asButto.titleLabel.font = [UIFont systemFontOfSize:16];
        [_asButto addTarget:self action:@selector(asButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_effectView.contentView addSubview:_asButto];
        [_asButto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_effectView.mas_top).offset(trDoneTopOffset);
            make.left.equalTo(_effectView.mas_left).offset(trDoneRightOffset);
        }];
//        _asButto.hidden = self.isEdit_br;
        
        _trDone = [[UIButton alloc] init];
        [_trDone setTitle:LOCALIZATION(@"完成") forState:UIControlStateNormal];
        [_trDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _trDone.titleLabel.font = [UIFont systemFontOfSize:16];
        [_trDone addTarget:self action:@selector(trDoneClick:) forControlEvents:UIControlEventTouchUpInside];
        [_effectView.contentView addSubview:_trDone];
        [_trDone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_effectView.mas_top).offset(trDoneTopOffset);
            make.right.equalTo(_effectView.mas_right).offset(-trDoneRightOffset);
        }];
        
        _floderName = [[UITextField alloc] init];
        _floderName.returnKeyType = UIReturnKeyDone;
        _floderName.textAlignment = NSTextAlignmentCenter;
        [_effectView.contentView addSubview:_floderName];
        [_floderName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(self.fntOffset);
//            make.centerX.equalTo(self.mas_centerX);
//            make.width.equalTo(@(self.width));
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];

//        _brLayout.minimumInteritemSpacing = margin;
//        _brLayout.minimumLineSpacing = margin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_brLayout];
        
        _collectionView.backgroundColor = [UIColor colorWithRGB:0xff alpha:0.68];
        [_collectionView setContentInset:UIEdgeInsetsMake(0, insetsMargin, 0, insetsMargin)];
        [_effectView.contentView addSubview:_collectionView];
        NSString *reuserID = @"ECRBookrackCollectionViewCell";
        [_collectionView registerNib:[UINib nibWithNibName:reuserID bundle:nil] forCellWithReuseIdentifier:reuserID];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(Screen_Width));
            make.top.equalTo(_floderName.mas_bottom).offset(cTopOffset);
            make.height.equalTo(@(Screen_Height * 0.5));
            
            // test
//            make.top.equalTo(self.mas_top);//.offset(cTopOffset);
//            make.height.equalTo(@(Screen_Height - 49));//equalTo(@(Screen_Height * 0.5));
        }];
        
        _collectionView.contentInset = UIEdgeInsetsMake(_brLayout.insetsMarginT, _brLayout.insetsMarginLR, 0, _brLayout.insetsMarginLR);
        
    }
    return self;
}
- (void)rg_collectionViewReload{
    [UIView animateWithDuration:0 animations:^{
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadData];
        } completion:nil];
    }];
}

- (CGFloat)fntOffset{
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 150;
    }
    return 100;
}

@end
