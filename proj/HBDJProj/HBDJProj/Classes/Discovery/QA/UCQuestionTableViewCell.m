//
//  UCQuestionTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCQuestionTableViewCell.h"
#import "LGThreeRightButtonView.h"
#import "UCQuestionModel.h"

#import "DJBanIndicateView.h"

static NSString * const showAll_key = @"showAll";
static NSString * const praiseid_keyPath = @"praiseid";
static NSString * const collectionid_keyPath = @"collectionid";
static NSString * const praisecount_keyPath = @"praisecount";
static NSString * const collectioncount_keyPath = @"collectioncount";

@interface UCQuestionTableViewCell ()<LGThreeRightButtonViewDelegate>

@property (weak,nonatomic) DJBanIndicateView *banin;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel0;
@property (strong, nonatomic) IBOutlet LGThreeRightButtonView *boInterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTextHeight;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *showAll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingNeedsChangeWhenEdit;

@end

@implementation UCQuestionTableViewCell

- (void)setModel:(UCQuestionModel *)model{
    _model = model;
    
    [self displayDataWithModel:model];
    
}

- (void)setCollectModel:(UCQuestionModel *)collectModel{
    [super setCollectModel:collectModel];
    
    if (collectModel.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.question.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        self.seButon.selected = collectModel.select;

        _leadingNeedsChangeWhenEdit.constant = 38;
        
    }else{
        [self.seButon removeFromSuperview];
        
        /// 默认值
        _leadingNeedsChangeWhenEdit.constant = 18;
    }
    
    [self displayDataWithModel:collectModel];
}

- (void)displayDataWithModel:(UCQuestionModel *)qaModel{
    /// 计算 问题 文本的高度
    CGFloat questionHeight = [qaModel.question sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 57, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height;
    NSInteger lines = questionHeight / 19;
    
    _questionTextHeight.constant = lines * 20;
    _question.numberOfLines = lines;
    _question.text = qaModel.question;
    
    _tagLabel0.text = qaModel.tagString;
    
    _content.text = qaModel.answer;
    
    _showAll.selected = qaModel.showAll;
    if (qaModel.showAll) {
        _content.numberOfLines = 0;
        _arrow.transform = CGAffineTransformMakeRotation(-M_PI);
    }else{
        _content.numberOfLines = 3;
        _arrow.transform = CGAffineTransformIdentity;
    }
    
    _boInterView.leftIsSelected = !(qaModel.praiseid <= 0);
    _boInterView.middleIsSelected = !(qaModel.collectionid <= 0);
    
    _boInterView.likeCount = qaModel.praisecount;
    _boInterView.collectionCount = qaModel.collectioncount;
    
    [qaModel addObserver:self forKeyPath:praiseid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [qaModel addObserver:self forKeyPath:collectionid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [qaModel addObserver:self forKeyPath:praisecount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [qaModel addObserver:self forKeyPath:collectioncount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    
    if (qaModel.auditstate == 0) {
        /// 不通过
        _banin.hidden = NO;
    }else{
        _banin.hidden = YES;
        
    }
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
}

- (IBAction)showAllClick:(UIButton *)sender {
    self.model.showAll = !self.model.showAll;
    if ([self.delegate respondsToSelector:@selector(qaCellshowAllClickWith:)]) {
        [self.delegate qaCellshowAllClickWith:self.indexPath];
    }
}

/**
    1.通过代理通知控制器
    2.代理方法携带模型参数，发送请求后，在其回调中修改模型的属性
    3.cell 通过KVO 监听模型的属性变化，修改状态
 */

- (void)leftClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// TODO: liketodo
    /// 提问感谢（点赞）
    if ([self.delegate respondsToSelector:@selector(qaCellLikeWithModel:sender:)]) {
        [self.delegate qaCellLikeWithModel:self.model sender:sender];
    }
}
- (void)middleClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 提问收藏
    if ([self.delegate respondsToSelector:@selector(qaCellCollectWithModel:sender:)]) {
        [self.delegate qaCellCollectWithModel:self.model sender:sender];
    }
}
- (void)rightClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 提问分享
    if ([self.delegate respondsToSelector:@selector(qaCellShareWithModel:sender:)]) {
        [self.delegate qaCellShareWithModel:self.model sender:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    DJBanIndicateView *banin = DJBanIndicateView.new;
    [self.contentView addSubview:banin];
    _banin = banin;
    [banin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.boInterView.mas_bottom);
    }];
    banin.hidden = YES;
    
//    NSLog(@"[_content.font fontName]: %@",[_content.font fontName]);
//    NSLog(@"[_content.font familyName]: %@",[_content.font familyName]);
    
    _question.textColor = [UIColor EDJColor_A2562C];
    _tagLabel0.textColor = [UIColor EDJMainColor];
    _content.textColor = [UIColor EDJGrayscale_33];
    _boInterView.delegate = self;
    [_boInterView setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                    TRConfigImgNameKey:@"uc_icon_ganxie_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_ganxie_red",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_FC4E45]
                                    },
                                  @{TRConfigTitleKey:@"99+",
                                    TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                    },
                                  @{TRConfigTitleKey:@"",
                                    TRConfigImgNameKey:@"uc_icon_fenxiang_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_fenxiang_green",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_8BCA32]
                                    }]];
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:praiseid_keyPath];
    [self.model removeObserver:self forKeyPath:collectionid_keyPath];
    [self.model removeObserver:self forKeyPath:praisecount_keyPath];
    [self.model removeObserver:self forKeyPath:collectioncount_keyPath];
}

@end
