//
//  ECRBookClassSortHeader.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBookClassSortHeader.h"
#import "ECRBookSortButtonView.h"
#import "ECRSortTableViewController.h"

@interface ECRBookClassSortHeader ()<ECRBookSortButtonViewDelegate>
/** 销量 */
@property (weak, nonatomic) IBOutlet ECRBookSortButtonView *sale;
/** 价格 */
@property (weak, nonatomic) IBOutlet ECRBookSortButtonView *price;
/** 好评 */
@property (weak, nonatomic) IBOutlet ECRBookSortButtonView *score;
@property (weak, nonatomic) IBOutlet UIView *filterContainer;
@property (weak, nonatomic) IBOutlet UIView *lineBottom;
/** 恢复默认 */
@property (weak, nonatomic) IBOutlet UIButton *hfDefault;

@end

@implementation ECRBookClassSortHeader

- (void)setNoFilterData:(BOOL)noFilterData{
    _noFilterData = noFilterData;
    if (noFilterData == YES) {
        /// 添加空数据view
        
    }
}

/** 恢复默认点击事件 */
- (IBAction)defaultSort:(UIButton *)sender {
    self.sale.selected = NO;
    self.price.selected = NO;
    self.score.selected = NO;
    if ([self.delegate respondsToSelector:@selector(bcsHeader:tag:isDesOrder:)]) {
        [self.delegate bcsHeader:self tag:-1 isDesOrder:YES];
    }
}

- (void)setRowModels:(NSArray *)rowModels{
    _rowModels = rowModels;
    self.stvc.dataArray = rowModels;
}

#pragma mark - ECRBookSortButtonViewDelegate
- (void)bsbView:(ECRBookSortButtonView *)view selected:(BOOL)selected{
    // 0销量,1价格,2好评论
    NSInteger type = -1;
    if (selected) {
        if ([view isEqual:self.sale]) {
            type = 0;
            self.price.selected = NO;
            self.score.selected = NO;
        }
        if ([view isEqual:self.price]) {
            type = 1;
            self.sale.selected = NO;
            self.score.selected = NO;
        }
        if ([view isEqual:self.score]) {
            type = 2;
            self.sale.selected = NO;
            self.price.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(bcsHeader:tag:)]) {
        [self.delegate bcsHeader:self tag:type];
    }
}
- (void)bsbView:(ECRBookSortButtonView *)view isDesOrder:(BOOL)isDesOrder{
    NSInteger type = -1;
    if ([view isEqual:self.sale]) {
        type = 0;
    }
    if ([view isEqual:self.price]) {
        type = 1;
    }
    if ([view isEqual:self.score]) {
        type = 2;
    }
    if ([self.delegate respondsToSelector:@selector(bcsHeader:tag:isDesOrder:)]) {
        [self.delegate bcsHeader:self tag:type isDesOrder:isDesOrder];
    }
}

- (void)textDependsLauguage{
    self.sale.name = [LGPChangeLanguage localizedStringForKey:@"销量"];
    self.price.name = [LGPChangeLanguage localizedStringForKey:@"价格"];
    self.score.name = [LGPChangeLanguage localizedStringForKey:@"好评"];
    [self.hfDefault setTitle:[LGPChangeLanguage localizedStringForKey:@"恢复默认"] forState:UIControlStateNormal];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self textDependsLauguage];
    self.sale.delegate = self;
    self.price.delegate = self;
    self.score.delegate = self;
    
    [self.filterContainer addSubview:self.stvc.view];
    [self.stvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterContainer.mas_top);
        make.left.equalTo(self.filterContainer.mas_left);
        make.bottom.equalTo(self.filterContainer.mas_bottom);
        make.right.equalTo(self.filterContainer.mas_right);
    }];
    
    _lineBottom.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
}

- (ECRSortTableViewController *)stvc{
    if (_stvc == nil) {
        _stvc = [[ECRSortTableViewController alloc] init];
    }
    return _stvc;
}

@end
