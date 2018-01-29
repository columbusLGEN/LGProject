//
//  UCRBooksSelectedView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRBooksSelectedView.h"

#import "UCRBooksSelectedTableViewCell.h"
#import "UCRecommendBooksVC.h"

@interface UCRBooksSelectedView () <UITableViewDelegate, UITableViewDataSource, UCRBooksSelectedTableViewCellDelegate>

@end

@implementation UCRBooksSelectedView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects{
    return [self initWithFrame:frame withObjects:objects canReorder:NO];
}

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder{
    self = [super initWithFrame:frame];
    if (self) {
        self.objects = [NSMutableArray arrayWithArray:objects];
        [self configBooksSelectedView];
    }
    return self;
}

#pragma mark - 配置界面

- (void)configBooksSelectedView
{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = cHeaderHeight_54;
    _tableView.sectionHeaderHeight = cHeaderHeight_44;
    [self addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCRBooksSelectedTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCRBooksSelectedTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UCRBooksSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCRBooksSelectedTableViewCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.data = [self.objects objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objects count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor cm_lineColor_D9D7D7_1 ];
    
    UIView *verLine = [UIView new];
    verLine.backgroundColor = [UIColor cm_mainColor];
    [header addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.left.equalTo(header.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(3, 14));
    }];
    
    UILabel *lblDesc = [UILabel new];
    lblDesc.textColor = [UIColor cm_blackColor_333333_1];
    lblDesc.text = LOCALIZATION(@"选中图书");
    lblDesc.font = [UIFont systemFontOfSize:cFontSize_14];
    [header addSubview:lblDesc];
    [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verLine.mas_centerY);
        make.left.equalTo(verLine.mas_right).offset(10);
    }];
    
    UIButton *btnClear = [UIButton new];
    [btnClear setTitle:[NSString stringWithFormat:@" %@", LOCALIZATION(@"清空")] forState:UIControlStateNormal];
    [btnClear setTitleColor:[UIColor cm_blackColor_333333_1] forState:UIControlStateNormal];
    [btnClear setImage:[UIImage imageNamed:@"icon_trash"] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(removeAllSelectedBooks) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btnClear];
    [btnClear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verLine.mas_centerY);
        make.right.equalTo(header.mas_right).offset(-25);
    }];
    
    return header;
}

#pragma mark - 发送删除通知 

- (void)removeSelectedBook:(id)book
{
    [self fk_postNotification:kNotificationRemoveSelectedBook object:book];
}

- (void)removeAllSelectedBooks
{
    [self fk_postNotification:kNotificationRemoveAllBooks];
}

@end
