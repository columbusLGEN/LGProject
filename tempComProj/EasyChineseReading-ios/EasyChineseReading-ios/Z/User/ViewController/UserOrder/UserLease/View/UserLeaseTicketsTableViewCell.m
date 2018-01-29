//
//  UserLeaseTicketsTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserLeaseTicketsTableViewCell.h"
#import "ULeaseBookCollectionViewCell.h"

@interface UserLeaseTicketsTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblLeaseEndTime;  // 截止时间
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout; // collection layout

@property (strong, nonatomic) NSArray *arrBooks;

@property (strong, nonatomic) TicketBookModel *ticket;

@property (assign, nonatomic) CGFloat cellWidth;  // cell宽度
@property (assign, nonatomic) CGFloat cellHeight; // cell高度
@property (assign, nonatomic) CGFloat cellSpace;  // cell间距
@property (assign, nonatomic) NSInteger collectionNum; // cell数量

@end

@implementation UserLeaseTicketsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configLeaseTableCell];
    [self configCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 配置界面

- (void)configLeaseTableCell
{
    _imgIcon.image = [UIImage imageNamed:@"icon_lease_time"];
    _lblLeaseEndTime.textColor  = [UIColor cm_blackColor_666666_1];
    _lblLeaseEndTime.font  = [UIFont systemFontOfSize:cFontSize_14];
    
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = .5f;
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

#pragma mark - 更新数据

- (void)dataDidChange
{
    _ticket = [TicketBookModel mj_objectWithKeyValues:self.data];
    _lblLeaseEndTime.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"到期时间"), _ticket.endTime];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _ticket.books.count > 10 ? 10 : _ticket.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ULeaseBookCollectionViewCell *bookCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ULeaseBookCollectionViewCell class]) forIndexPath:indexPath];
    bookCell.data = _ticket.books.count > 0 ? _ticket.books[indexPath.row] : nil;
    return bookCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.toTicketsBooksListView();
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

@end
