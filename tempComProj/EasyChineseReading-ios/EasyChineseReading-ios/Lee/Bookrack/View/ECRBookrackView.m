//
//  ECRBookrackView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

static NSString *reuserID = @"ECRBookrackCollectionViewCell";

#import "ECRBookrackView.h"
#import "ECRSwichView.h"
#import "ECRBookrackFlowLayout.h"
//#import "ECRBaseCollectionFlowLayout.h"

@interface ECRBookrackView ()<
ECRSwichViewDelegate,
UICollectionViewDelegate
>

@property (strong,nonatomic) ECRSwichView *swichView;//

@property (strong,nonatomic) UILongPressGestureRecognizer *longPress;
//@property (strong,nonatomic) ECRBaseCollectionFlowLayout *;// 全部图书layout
@property (strong,nonatomic) ECRBookrackFlowLayout *abLayout;// 全部图书layout
@property (strong,nonatomic) ECRBookrackFlowLayout *brLayout;// 已购买layout

@property (assign,nonatomic) CGFloat svH;//

@end

@implementation ECRBookrackView

- (void)textDependsLauguage{
    NSString *allBook = [LGPChangeLanguage localizedStringForKey:@"全部图书"];
    NSString *buyed = [LGPChangeLanguage localizedStringForKey:@"已购买"];
    _swichView.buttonNames = @[allBook,buyed];
}

#pragma mark - ECRSwichViewDelegate
- (void)ecrSwichView:(ECRSwichView *)view didClick:(NSInteger)click{
    switch (click) {
        case 0:{// 左
            [self.firstFloor setContentOffset:CGPointZero animated:YES];
        }
            break;
            
        case 1:{
            [self.firstFloor setContentOffset:CGPointMake(Screen_Width, 0) animated:YES];
        }
            break;
    }
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(brView:didSelectBookrack:indexPath:)]) {
        [self.delegate brView:self didSelectBookrack:collectionView indexPath:indexPath];
    }
}

#pragma mark - 业务逻辑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_bookrack] || [scrollView isEqual:_allOfBooks]) {
//                CGFloat offsetY = scrollView.contentOffset.y + self.svH + self.abLayout.insetsMarginT;/// 1 配合 self.insets 使用
//                CGFloat dValue  = self.svH + self.abLayout.insetsMarginT - offsetY;/// 1 配合 self.insets 使用
        
        // Y的偏移量
        CGFloat offsetY = scrollView.contentOffset.y;
        // 平移差值
        CGFloat dValue  = self.svH - offsetY;
        
        if (dValue < 0) {
            dValue = 0;
        }
//        NSLog(@"%f",offsetY);
//        NSLog(@"%f",dValue);
        
        if (offsetY > 0) {
            if (dValue >= 0) {
                // 平移
                self.swichView.transform = CGAffineTransformMakeTranslation(0, -offsetY);
            }
        }else{
            // 恢复
            self.swichView.transform = CGAffineTransformIdentity;

        }
    }else if([scrollView isEqual:_firstFloor]){
        // 左右滑动
        if (scrollView.contentOffset.x == 0) {
//            [self.swichView switchSelectedItem:0];
            // 通知代理（控制器）/ 切换到了全部图书
            if ([self.delegate respondsToSelector:@selector(brViewDidSwitch:place:)]) {
                [self.delegate brViewDidSwitch:self place:1];
            }
        }
        if (scrollView.contentOffset.x >= Screen_Width) {
            //            [self.swichView switchSelectedItem:1];
            if ([self.delegate respondsToSelector:@selector(brViewDidSwitch:place:)]) {
                [self.delegate brViewDidSwitch:self place:2];
            }
        }
    }else{
        
    }
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame flowLayout:(ECRBookrackFlowLayout *)flowLayout abLayout:(ECRBookrackFlowLayout *)abLayout{
    self.brLayout = flowLayout;// 该布局参数从控制器传入是为了设置其代理为控制器
    self.abLayout = abLayout;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self        addSubview:self.firstFloor];
        [self        addSubview:self.swichView];
        [self.firstFloor addSubview:self.allOfBooks];// 全部图书
        [self.firstFloor addSubview:self.bookrack];// 已购买
        
        // MAKR: 约束
        [self.swichView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top    .equalTo(self       .mas_top).offset(0);
            make.left   .equalTo(self       .mas_left);
            make.width  .equalTo(@(Screen_Width));
            make.height .equalTo(@(self.svH));
        }];
        [self.firstFloor mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top    .equalTo(_swichView .mas_bottom);
            make.top.equalTo(self.mas_top);
            make.left   .equalTo(self       .mas_left);
            make.bottom .equalTo(self       .mas_bottom).offset(-49);
            make.right  .equalTo(self       .mas_right);
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        CGFloat margin = 26;
        if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        }else{
            margin = 10;
        }
        
//        CGFloat covW = Screen_Width;/// 配合 self.insets 1 使用
        CGFloat covW = Screen_Width - 2 * margin;
        
        [self.allOfBooks mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.bookrack.mas_top);/// 配合 self.insets 1 使用
//            make.left   .equalTo(self.firstFloor.mas_left);/// 配合 self.insets 1 使用
//            make.right  .equalTo(self.bookrack.mas_left);/// 配合 self.insets 1 使用
            
            make.top    .equalTo(self.firstFloor.mas_top);
            make.left   .equalTo(self.firstFloor.mas_left).offset(margin);
            make.right  .equalTo(self.bookrack.mas_left).offset(-2 * margin);
            
            make.bottom .equalTo(self.firstFloor.mas_bottom);
            make.width  .equalTo(@(covW));
            make.height .equalTo(@(_firstFloor.height - 49));
        }];
        [self.bookrack mas_makeConstraints:^(MASConstraintMaker *make) {

//            make.right  .equalTo(self.firstFloor.mas_right);/// 配合 self.insets 使用
            
            make.right  .equalTo(self.firstFloor.mas_right).offset(margin);
            
            make.top    .equalTo(self.firstFloor.mas_top).offset(0);
            make.bottom .equalTo(self.firstFloor.mas_bottom);
            make.width  .equalTo(@(covW));
            make.height .equalTo(self.allOfBooks.mas_height);
        }];
        
        [self textDependsLauguage];
        
    }
    return self;
}

- (ECRBookrackFlowLayout *)abLayout{
    if (_abLayout == nil) {
        // 全部图书列表布局参数
        _abLayout.itemSize;// 必须执行
        _abLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _abLayout.minimumInteritemSpacing = _abLayout.minimunBookSpace;
//        _abLayout.sectionInset = self.insets;
    }
    return _abLayout;
}
- (ECRBookrackFlowLayout *)brLayout{
    if (_brLayout == nil) {
        // 已购买布局参数
        _brLayout.itemSize;// 必须执行
        _brLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _brLayout.minimumInteritemSpacing = _brLayout.minimunBookSpace;
//        _brLayout.sectionInset = self.insets;
    }
    return _brLayout;
}
- (ECRSwichView *)swichView{
    if (_swichView == nil) {
        _swichView  = [[ECRSwichView alloc] initWithFrame:CGRectZero height:self.svH];
        _swichView.delegate = self;
        _swichView.backgroundColor = [UIColor whiteColor];
    }
    return _swichView;
}
- (UIScrollView *)firstFloor{
    if (_firstFloor == nil) {
        _firstFloor = [[UIScrollView alloc] init];
        _firstFloor.delegate = self;
        _firstFloor.pagingEnabled = YES;
        _firstFloor.scrollEnabled = NO;
    }
    return _firstFloor;
}
- (UICollectionView *)bookrack{
    if (_bookrack == nil) {
        _bookrack   = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.brLayout];
//        _bookrack.showsVerticalScrollIndicator = NO;
        _bookrack.delegate        = self;
        _bookrack.backgroundColor = [UIColor whiteColor];
        [_bookrack registerNib:[UINib nibWithNibName:reuserID bundle:nil] forCellWithReuseIdentifier:reuserID];
        
        [_bookrack setContentInset:self.insets];
        
        _bookrack.showsVerticalScrollIndicator = NO;
        
    }
    return _bookrack;
}
- (UICollectionView *)allOfBooks{
    if (_allOfBooks == nil) {

        _allOfBooks = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.abLayout];
//        _allOfBooks.showsVerticalScrollIndicator = NO;
        _allOfBooks.delegate = self;
        _allOfBooks.backgroundColor = [UIColor whiteColor];
        [_allOfBooks registerNib:[UINib nibWithNibName:reuserID bundle:nil] forCellWithReuseIdentifier:reuserID];

        [_allOfBooks setContentInset:self.insets];
        _allOfBooks.showsVerticalScrollIndicator = NO;
    }
    return _allOfBooks;
}

- (CGFloat)svH{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return 44;
    }else{
        return 44;
    }
}
- (UIEdgeInsets)insets{
    return UIEdgeInsetsMake(self.abLayout.insetsMarginT + self.svH, 0, self.abLayout.insetsMarginT, 0);/// 0
//    return UIEdgeInsetsMake(self.abLayout.insetsMarginT + self.svH, _abLayout.insetsMarginLR, 0, self.abLayout.insetsMarginLR);/// 1
}

@end


