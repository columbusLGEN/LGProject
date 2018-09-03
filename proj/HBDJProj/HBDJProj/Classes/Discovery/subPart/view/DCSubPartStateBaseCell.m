//
//  DCSubPartStateBaseCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateBaseCell.h"
#import "DCSubPartStateModel.h"
#import "LGThreeRightButtonView.h"

static NSString * const praiseid_keyPath = @"praiseid";
static NSString * const collectionid_keyPath = @"collectionid";
static NSString * const praisecount_keyPath = @"praisecount";
static NSString * const collectioncount_keyPath = @"collectioncount";
static NSString * const select_keyPath = @"select";

@interface DCSubPartStateBaseCell ()<
LGThreeRightButtonViewDelegate>

@end

@implementation DCSubPartStateBaseCell

- (void)setModel:(DCSubPartStateModel *)model{
    _model = model;
    
    [self displayDataWithModel:model];
    
}

- (void)setBranchCollectModel:(DCSubPartStateModel *)branchCollectModel{
    _branchCollectModel = branchCollectModel;
    [self displayDataWithModel:branchCollectModel];
    if (branchCollectModel.edit) {
        self.boInterView.userInteractionEnabled = NO;
    }else{
        self.boInterView.userInteractionEnabled = YES;
    }
    [branchCollectModel addObserver:self forKeyPath:select_keyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)displayDataWithModel:(DJUcMyCollectBranchModel *)branchModel{
    _timeLabel.text = [branchModel.timestamp timestampToDate_nyr];
    
    _boInterView.leftIsSelected = !(branchModel.praiseid <= 0);
    _boInterView.middleIsSelected = !(branchModel.collectionid <= 0);
    _boInterView.rightIsSelected = branchModel.iscomment;
    
    _boInterView.likeCount = branchModel.praisecount;
    _boInterView.collectionCount = branchModel.collectioncount;
    _boInterView.commentCount = branchModel.frontComments.count;
    
    [branchModel addObserver:self forKeyPath:praiseid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [branchModel addObserver:self forKeyPath:collectionid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [branchModel addObserver:self forKeyPath:praisecount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [branchModel addObserver:self forKeyPath:collectioncount_keyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.model) {
        if ([keyPath isEqualToString:praiseid_keyPath]) {
            _boInterView.leftIsSelected = !(self.model.praiseid <= 0);
        }
        if ([keyPath isEqualToString:collectionid_keyPath]) {
            _boInterView.middleIsSelected = !(self.model.collectionid <= 0);
        }
        if ([keyPath isEqualToString:praisecount_keyPath]) {
            _boInterView.likeCount = self.model.praisecount;
        }
        if ([keyPath isEqualToString:collectioncount_keyPath]) {
            _boInterView.collectionCount = self.model.collectioncount;
        }
    }
    if (object == self.branchCollectModel) {
        if ([keyPath isEqualToString:select_keyPath]) {
            self.seButon.selected = self.branchCollectModel.select;
        }
    }
}

- (void)leftClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// TODO: liketodo
    /// 支部动态点赞
    if ([self.delegate respondsToSelector:@selector(branchLikeWithModel:sender:)]) {
        [self.delegate branchLikeWithModel:self.model sender:sender];
    }
}
- (void)middleClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 支部动态收藏
    if ([self.delegate respondsToSelector:@selector(branchCollectWithModel:sender:)]) {
        [self.delegate branchCollectWithModel:self.model sender:sender];
    }
}
- (void)rightClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 支部动态评论
    if ([self.delegate respondsToSelector:@selector(branchCommentWithModel:sender:)]) {
        [self.delegate branchCommentWithModel:self.model?self.model:self.branchCollectModel sender:sender];
    }
}

+ (NSString *)cellReuseIdWithModel:(DCSubPartStateModel *)model{
    switch (model.imgCount) {
        case 0:
            return withoutImgCell;
            break;
        case 1:
            return oneImgCell;
            break;
        case 3:
            return threeImgCell;
            break;
        default:
            return withoutImgCell;
            break;
    }
    return withoutImgCell;
}

- (void)setupUI{
    UIView *rect = [UIView new];
    rect.backgroundColor = [UIColor EDJGrayscale_F3];
    [self.contentView addSubview:rect];
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.boInterView];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        make.bottom.equalTo(self.boInterView.mas_top).offset(-marginFifteen);
        make.height.mas_equalTo(17);
    }];
    [self.boInterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rect.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(45);
    }];
    [rect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(5);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];

}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = UILabel.new;
        _timeLabel.textColor = UIColor.EDJGrayscale_A4;
    }
    return _timeLabel;
}

- (LGThreeRightButtonView *)boInterView{
    if (_boInterView == nil) {
        _boInterView = [LGThreeRightButtonView new];
        _boInterView.delegate = self;
        [_boInterView setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_like_normal",
                                        TRConfigSelectedImgNameKey:@"dc_like_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_6CBEFC]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                        TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_discuss_normal",
                                        TRConfigSelectedImgNameKey:@"dc_discuss_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_CEB0E7]
                                        }]];
    }
    return _boInterView;
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:praiseid_keyPath];
    [self.model removeObserver:self forKeyPath:collectionid_keyPath];
    [self.model removeObserver:self forKeyPath:praisecount_keyPath];
    [self.model removeObserver:self forKeyPath:collectioncount_keyPath];
    [self.branchCollectModel removeObserver:self forKeyPath:select_keyPath];
}

@end
