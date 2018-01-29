//
//  ECRMoreBooksFooterView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRMoreBooksFooterView.h"
#import "ECRRequestFailuredView.h"

@interface ECRMoreBooksFooterView ()
/** 空数据 */
@property (strong,nonatomic) ECRRequestFailuredView *rrfv;

@end

@implementation ECRMoreBooksFooterView

- (void)setOpenType:(ECRMoreBookOpenType)openType{
    _openType = openType;
    [self.contentView addSubview:self.rrfv];
    [self.rrfv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
}

- (ECRRequestFailuredView *)rrfv{
    if (_rrfv == nil) {
        _rrfv = [ECRRequestFailuredView new];
        if (self.openType == ECRMoreBookOpenTypeDefault) {
            _rrfv.emptyType = ECRRFViewEmptyTypeClassifyNoData;
        }else{
            _rrfv.emptyType = ECRRFViewEmptyTypeNoAccess;
        }
    }
    return _rrfv;
}

@end
