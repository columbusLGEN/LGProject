//
//  ULeaseTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserLeaseTableViewCell.h"

#import "ULeaseBookCollectionViewCell.h"

@interface UserLeaseTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (weak, nonatomic) IBOutlet UILabel *lblLeaseEndTime;  // 包月截止时间
@property (weak, nonatomic) IBOutlet UILabel *lblLeaseContinue; // 包月续费

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imgCover; // 系列封面

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout; // collection layout

@property (strong, nonatomic) NSArray *arrBooks; // 包月的图书

@property (strong, nonatomic) SerialModel *serial; // 系列

@property (assign, nonatomic) CGFloat cellWidth;  // cell宽度
@property (assign, nonatomic) CGFloat cellHeight; // cell高度
@property (assign, nonatomic) CGFloat cellSpace;  // cell间距
@property (assign, nonatomic) NSInteger collectionNum; // cell数量

@end

@implementation UserLeaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configLeaseTableCell];
    [self configCollectionView];
    [self addGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - 配置界面

- (void)configLeaseTableCell
{
    _lblLeaseEndTime.textColor  = [UIColor cm_blackColor_666666_1];
    _lblLeaseContinue.textColor = [UIColor cm_orangeColor_BB7435_1];
    
    _lblLeaseEndTime.font  = [UIFont systemFontOfSize:cFontSize_14];
    _lblLeaseContinue.font = [UIFont systemFontOfSize:cFontSize_14];
    
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = .5f;
    
    _lblLeaseContinue.text = [NSString stringWithFormat:@"%@ >", LOCALIZATION(@"续期")];
    _imgIcon.image = [UIImage imageNamed:@"icon_lease_time"];
}

- (void)configCollectionView
{
    _collectionNum = isPad ? cCollectionNum_Pad : cCollectionNum_Phone;
    _cellSpace     = isPad ? cCollectionSpace_Pad : cCollectionSpace_Phone;
    _cellWidth     = (Screen_Width - (_collectionNum + 1)*_cellSpace)/_collectionNum;
    _cellHeight    = _cellWidth*cCollectionScale;
    _collectionHeightConstraint.constant = _cellHeight + 50.f; // 50 是footerCell中封面距离底部的高度
    _collectionView.scrollEnabled = YES;
    _collectionView.collectionViewLayout = self.layout;

    [_collectionView registerClass:[ULeaseBookCollectionViewCell  class] forCellWithReuseIdentifier:NSStringFromClass([ULeaseBookCollectionViewCell  class])];
}

/** 添加点击跳转续费手势 */
- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tapContinue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(continueSelectedLease:)];
    [_lblLeaseContinue addGestureRecognizer:tapContinue];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [_imgCover addGestureRecognizer:tap];
}

#pragma mark - 更新数据

- (void)dataDidChange
{
    _serial = [SerialModel mj_objectWithKeyValues:self.data];
    _lblLeaseEndTime.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"到期时间"), _serial.endTime];
    [_imgCover sd_setImageWithURL:[NSURL URLWithString:_serial.serialUrl] placeholderImage:nil];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _serial.series.count > 10 ? 10 : _serial.series.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ULeaseBookCollectionViewCell *bookCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ULeaseBookCollectionViewCell class]) forIndexPath:indexPath];
    bookCell.data = _serial.series.count > 0 ? _serial.series[indexPath.row] : nil;
    return bookCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.toSerialBooksListView();
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = _cellSpace;
        _layout.minimumInteritemSpacing = _cellSpace;
        _layout.sectionInset = UIEdgeInsetsZero;
        _layout.itemSize = CGSizeMake(_cellWidth, _collectionHeightConstraint.constant - 1);
    }
    return _layout;
}

#pragma mark - action

- (void)continueSelectedLease:(UITapGestureRecognizer *)tap
{
    [self.delegate continueLeaseWithSerial:self.data];
}

- (void)tapImage
{
    self.toSerialBooksListView();
}

@end
