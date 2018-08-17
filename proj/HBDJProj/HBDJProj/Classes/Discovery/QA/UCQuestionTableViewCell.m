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

static NSString * const showAll_key = @"showAll";
static NSString * const praiseid_keyPath = @"praiseid";
static NSString * const collectionid_keyPath = @"collectionid";
static NSString * const praisecount_keyPath = @"praisecount";
static NSString * const collectioncount_keyPath = @"collectioncount";

@interface UCQuestionTableViewCell ()<LGThreeRightButtonViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel0;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (strong, nonatomic) IBOutlet LGThreeRightButtonView *boInterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTextHeight;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *showAll;

@end

@implementation UCQuestionTableViewCell

- (void)setModel:(UCQuestionModel *)model{
    _model = model;
    
    /// 计算 问题 文本的高度
    CGFloat questionHeight = [model.question sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 57, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height;
    NSInteger lines = questionHeight / 19;
    
    _questionTextHeight.constant = lines * 20;
    _question.numberOfLines = lines;
    _question.text = model.question;
    
    _tagLabel0.text = model.tag0;
    _tagLabel1.text = model.tag1;
    _tagLabel2.text = model.tag2;
    
    _content.text = model.answer;

    _showAll.selected = model.showAll;
    if (model.showAll) {
        _content.numberOfLines = 0;
        _arrow.transform = CGAffineTransformMakeRotation(-M_PI);
    }else{
        _content.numberOfLines = 3;
        _arrow.transform = CGAffineTransformIdentity;
    }
    
    _boInterView.leftIsSelected = !(model.praiseid <= 0);
    _boInterView.middleIsSelected = !(model.collectionid <= 0);

    _boInterView.likeCount = model.praisecount;
    _boInterView.collectionCount = model.collectioncount;
    
    [model addObserver:self forKeyPath:praiseid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:collectionid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:praisecount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:collectioncount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    
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

- (void)leftClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 提问感谢（点赞）
    if ([self.delegate respondsToSelector:@selector(qaCellLikeWithModel:)]) {
        [self.delegate qaCellLikeWithModel:self.model];
    }
}
- (void)middleClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 提问收藏
    if ([self.delegate respondsToSelector:@selector(qaCellCollectWithModel:)]) {
        [self.delegate qaCellCollectWithModel:self.model];
    }
}
- (void)rightClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 提问分享
    if ([self.delegate respondsToSelector:@selector(qaCellShareWithModel:)]) {
        [self.delegate qaCellShareWithModel:self.model];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    NSLog(@"[_content.font fontName]: %@",[_content.font fontName]);
//    NSLog(@"[_content.font familyName]: %@",[_content.font familyName]);
    
    _question.textColor = [UIColor EDJColor_A2562C];
    _tagLabel0.textColor = [UIColor EDJMainColor];
    _tagLabel1.textColor = [UIColor EDJMainColor];
    _tagLabel2.textColor = [UIColor EDJMainColor];
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
