//
//  UCRecommendBooksVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendBooksVC.h"

#import "UCRBooksShopCarView.h"

#import "UCRecommendBooksTableViewCell.h"
#import "ECRBookListModel.h"

#import "UCRecommendStudentsVC.h"
#import "UCImpowerManagerVC.h"

@interface UCRecommendBooksVC () <UCRBooksShopCarViewDelegate>

@property (strong, nonatomic) UCRBooksShopCarView *shopCarView; // 购物车（图书）
@property (strong, nonatomic) NSMutableArray *arrSelectedBooks; // 选中的图书

@end

@implementation UCRecommendBooksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _recommendType == ENUM_RecommendTypeRecommend ? LOCALIZATION(@"推荐阅读") : LOCALIZATION(@"授权阅读");
}

#pragma mark - 配置界面

- (void)setSubView
{
    // 购物车 添加选中的书籍
    CGFloat shopCarY = [IPhoneVersion deviceVersion] == iphoneX ? Screen_Height - cHeaderHeight_54 - cFooterHeight_83 : Screen_Height - cHeaderHeight_54 - cHeaderHeight_64;
    _shopCarView = [[UCRBooksShopCarView alloc] initWithFrame:CGRectMake(0, shopCarY, CGRectGetWidth(self.view.bounds), cHeaderHeight_54) inView:self.view recommendType:_recommendType];
    _shopCarView.delegate = self;
    [self.view addSubview:_shopCarView];
    
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationRemoveSelectedBook usingBlock:^(NSNotification *note) {
        [weakself updateWithNotification:note];
    }];
    [self fk_observeNotifcation:kNotificationRemoveAllBooks usingBlock:^(NSNotification *note) {
        [weakself removeAllSelectedBooks:note];
    }];
}

#pragma mark 继承 tableView 代理方法

- (UITableViewCell *)reTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCRecommendBooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCRecommendBooksTableViewCell class])];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCRecommendBooksTableViewCell class]) bundle:nil]
        forCellReuseIdentifier:NSStringFromClass([UCRecommendBooksTableViewCell class])];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCRecommendBooksTableViewCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (self.array.count)
        cell.data = self.array[indexPath.row];
    
    return cell;
}

- (void)reTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCRecommendBooksTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BookModel *book = self.array[indexPath.row];
    book.isSelected = !book.isSelected;
    cell.isSelected = book.isSelected;
    if (book.isSelected)
        [self.arrSelectedBooks addObject:book];
    else
        [self.arrSelectedBooks removeObject:book];

    [self updateRecommendBooksView];
}

#pragma mark - UCRBooksShopCarViewDelegate

/** 下一步 */
- (void)nextStep
{
    // 推荐书籍直接跳转到选择学生界面
    if (_recommendType == ENUM_RecommendTypeRecommend) {
        UCRecommendStudentsVC *recommendStudentVC = [[UCRecommendStudentsVC alloc] init];
        recommendStudentVC.arrBooks = _arrSelectedBooks;
        [self.navigationController pushViewController:recommendStudentVC animated:YES];
    }
    // 授权书籍
    else {
        NSString *strBookIds = @"";
        // 将图书和选中的人数组组成的字符串, 用逗号分隔
        for (NSInteger i = 0; i < _arrSelectedBooks.count; i ++) {
            ECRBookListModel *book = _arrSelectedBooks[i];
            strBookIds = [strBookIds stringByAppendingString:[NSString stringWithFormat:@"%ld,", book.ownId]];
        }
        // 去掉最后一个逗号
        strBookIds = [strBookIds substringToIndex:strBookIds.length - 1];
        WeakSelf(self)
        // 授权时间审核, 查看选中的图书的授权时间是否有交叉范围, 如果没有则不能授权
        [[ClassRequest sharedInstance] verifyImpowerBookTimeRangeWithOwnIds:strBookIds completion:^(id object, ErrorModel *error) {
            if (error) {
                [weakself presentFailureTips:error.message];
            }
            else {
                UCImpowerManagerVC *impowerManageVC = [[UCImpowerManagerVC alloc] init];
                impowerManageVC.arrBooks = _arrSelectedBooks;
                [weakself.navigationController pushViewController:impowerManageVC animated:YES];
            }
        }];
    }
}

#pragma mark - 设置购物车动画

- (void)animationDidFinish
{
    [UIView animateWithDuration:0.1 animations:^{
        _shopCarView.btnShowSelectedBooks.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _shopCarView.btnShowSelectedBooks.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - 删除选中的书

- (void)updateWithNotification:(NSNotification *)notification
{
    if ([_arrSelectedBooks containsObject:notification.object])
        [_arrSelectedBooks removeObject:notification.object];
    
    [self updateRecommendBooksView];
}

- (void)removeAllSelectedBooks:(NSNotification *)notification
{
    [_arrSelectedBooks removeAllObjects];
    [self updateRecommendBooksView];
}

#pragma mark - 更新购物车中的数据

- (void)updateRecommendBooksView {
    _shopCarView.bookSelectedView.objects = _arrSelectedBooks;
    //设置数量
    [_shopCarView setSelectedBooksNumber:_arrSelectedBooks.count];
    //设置高度。
    [_shopCarView updateFrame:_shopCarView.bookSelectedView];
    [_shopCarView.bookSelectedView.tableView reloadData];
    //重新设置数据源
    [self.tableView reloadData];
}

#pragma mark - 属性

- (NSMutableArray *)arrSelectedBooks
{
    if (_arrSelectedBooks == nil) {
        _arrSelectedBooks = [NSMutableArray array];
    }
    return _arrSelectedBooks;
}

@end
