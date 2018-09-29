//
//  DCSubStageBaseTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageBaseTableViewCell.h"
#import "LGThreeRightButtonView.h"
#import "DCSubStageModel.h"
#import "DCSubStageCommentsModel.h"
#import "DCSubStageCommentsCell.h"
#import "LGTriangleView.h"
#import "DJUcMyCollectPYQModel.h"
#import "DJBanIndicateView.h"

#define tbvWidth (kScreenWidth - 45)

static NSString * const praiseid_keyPath = @"praiseid";
static NSString * const collectionid_keyPath = @"collectionid";
static NSString * const praisecount_keyPath = @"praisecount";
static NSString * const collectioncount_keyPath = @"collectioncount";

@interface DCSubStageBaseTableViewCell ()<
UITableViewDelegate,
UITableViewDataSource,
LGThreeRightButtonViewDelegate>
@property (strong, nonatomic) UILabel *nick;/// 昵称
@property (strong,nonatomic) UILabel *time;/// 时间

@property (weak,nonatomic) UIView *bottomRect;/// 如果有评论，则隐藏 bottomRect

@property (strong,nonatomic) UITableView *tbvForComments;
@property (strong,nonatomic) NSArray *comments;

@property (weak,nonatomic) LGTriangleView *triangle;
@property (weak,nonatomic) DJBanIndicateView *banin;

@end

@implementation DCSubStageBaseTableViewCell{
    
//    CGFloat tbvWidth;
}

- (void)setModel:(DCSubStageModel *)model{
    _model = model;
    
    [self assiCommenDataWithModel:model];
}

- (void)setMc_pyq_model:(DJUcMyCollectPYQModel *)mc_pyq_model{
    _mc_pyq_model = mc_pyq_model;
    
    [mc_pyq_model addObserver:self forKeyPath:select_key options:NSKeyValueObservingOptionNew context:nil];
    
    [self assiCommenDataWithModel:mc_pyq_model];
    
    if (mc_pyq_model.auditstate == 0) {
        /// 未通过
        _banin.hidden = NO;
        [self.contentView bringSubviewToFront:_banin];
    }else{
        _banin.hidden = YES;
    }
    
    if (mc_pyq_model.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.icon.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        self.seButon.selected = mc_pyq_model.select;
        
        [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
            make.left.equalTo(self.seButon.mas_right).offset(marginEight);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        self.boInterView.userInteractionEnabled = NO;
        [self.contentView bringSubviewToFront:self.seButon];
        
    }else{
        [self.seButon removeFromSuperview];
        
        /// 默认值
        [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
            make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        self.boInterView.userInteractionEnabled = YES;
    }
    
}

- (void)assiCommenDataWithModel:(DCSubStageModel *)model{
    
    _time.text = [model.timestamp timestampToDate_nyr];
    _content.text = model.content;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:DJHeadIconPImage];
    _nick.text = model.uploader;
    
    _comments = model.frontComments;
    [_tbvForComments reloadData];
    
    if (_comments.count) {
        _bottomRect.hidden = YES;
        _triangle.hidden = NO;
        
        CGFloat commentTextTotalHeight = 0;
        for (DCSubStageCommentsModel *commentModel in model.frontComments) {
            NSString *needCalHeightString = commentModel.fullCommentString.string;
            CGFloat singleCommentTextHeight = [needCalHeightString sizeOfTextWithMaxSize:CGSizeMake(tbvWidth - 10, MAXFLOAT) font:[UIFont systemFontOfSize:14]].height;
            commentTextTotalHeight += singleCommentTextHeight;
//            NSLog(@"%@ :height %f,tbvWidth: %f",needCalHeightString,singleCommentTextHeight,tbvWidth);
        }
        
        [self.boInterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tbvForComments.mas_top);
            make.left.equalTo(self.time.mas_right).offset(-marginTen);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(45);
        }];
        
        [self.tbvForComments mas_updateConstraints:^(MASConstraintMaker *make) {
            /// 10 * _comments.count 为每个cell 上下间距各 5
            make.height.mas_equalTo(commentTextTotalHeight + (10 * _comments.count));
        }];
        
    }else{
        _bottomRect.hidden = NO;
        _triangle.hidden = YES;
        
        [self.tbvForComments mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.boInterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomRect.mas_top);
            make.left.equalTo(self.time.mas_right).offset(-marginTen);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(45);
        }];
    }
    
    _boInterView.leftIsSelected = !(model.praiseid <= 0);
    _boInterView.middleIsSelected = !(model.collectionid <= 0);
    _boInterView.rightIsSelected = model.iscomment;
    
    _boInterView.likeCount = model.praisecount;
    _boInterView.collectionCount = model.collectioncount;
    _boInterView.commentCount = model.frontComments.count;
    
    [model addObserver:self forKeyPath:praiseid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:collectionid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:praisecount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:collectioncount_keyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.icon cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:self.icon.height * 0.5];

}

- (void)configUI {
    
    DJBanIndicateView *banin = DJBanIndicateView.new;
    [self.contentView addSubview:banin];
    _banin = banin;
    banin.hidden = YES;
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nick];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
        make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(marginEight);
        make.centerY.equalTo(self.icon.mas_centerY);
    }];
    
    
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
        make.top.equalTo(self.contentView.mas_top).offset(contentTopOffset);
    }];
    
    /// cell底部 矩形分割线
    UIView *bottomRect = [UIView new];
    _bottomRect = bottomRect;
    _bottomRect.backgroundColor = [UIColor EDJGrayscale_F3];
    [self.contentView addSubview:_bottomRect];
    
    [self.contentView addSubview:self.boInterView];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.tbvForComments];
    
    [banin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.boInterView.mas_bottom);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_left);
        make.centerY.equalTo(self.boInterView.mas_centerY).offset(3);
        make.width.mas_equalTo(120);
    }];
    [self.boInterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomRect.mas_top);
        make.left.equalTo(self.time.mas_right).offset(-marginTen);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(45);
    }];
    [_bottomRect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(5);
    }];
    
    [self.tbvForComments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_left);
//        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.mas_equalTo(tbvWidth);
        
        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.mas_equalTo(25);
    }];
    
    LGTriangleView *triangle = [LGTriangleView new];
    [self.contentView addSubview:triangle];
    [triangle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tbvForComments.mas_top);
        make.right.equalTo(self.tbvForComments.mas_right).offset(-36);
        make.width.mas_equalTo(marginTwelve);
        make.height.mas_equalTo(marginEight);
    }];
    _triangle = triangle;
    
    
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
    if (object == self.mc_pyq_model && [keyPath isEqualToString:select_key]) {
        self.seButon.selected = self.mc_pyq_model.select;
    }
}

- (void)leftClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 党员舞台点赞
    if ([self.delegate respondsToSelector:@selector(pyqLikeWithModel:sender:)]) {
        [self.delegate pyqLikeWithModel:self.model?self.model:self.mc_pyq_model sender:sender];
    }
}
- (void)middleClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 党员舞台收藏
    if ([self.delegate respondsToSelector:@selector(pyqCollectWithModel:sender:)]) {
        [self.delegate pyqCollectWithModel:self.model?self.model:self.mc_pyq_model sender:sender];
    }
}
- (void)rightClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 党员舞台评论
    if ([self.delegate respondsToSelector:@selector(pyqCommentWithModel:sender:)]) {
        [self.delegate pyqCommentWithModel:self.model?self.model:self.mc_pyq_model sender:sender];
    }
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.clipsToBounds = YES;
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}
- (UILabel *)nick{
    if (!_nick) {
        _nick = [UILabel new];
        _nick.font = [UIFont systemFontOfSize:17];
        _nick.textColor = [UIColor EDJGrayscale_66];
    }
    return _nick;
}

- (UILabel *)time{
    if (!_time) {
        _time = [UILabel new];
        _time.textColor = [UIColor EDJGrayscale_66];
        _time.font = [UIFont systemFontOfSize:13];
    }
    return _time;
}
- (LGThreeRightButtonView *)boInterView{
    if (_boInterView == nil) {
        _boInterView = [LGThreeRightButtonView new];
        _boInterView.hideTopLine = YES;
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
- (UILabel *)content{
    if (!_content) {
        _content = [UILabel new];
        _content.font = [UIFont systemFontOfSize:15];
        _content.textColor = [UIColor EDJGrayscale_11];
        _content.numberOfLines = 0;
    }
    return _content;
}

- (UITableView *)tbvForComments{
    if (!_tbvForComments) {
        _tbvForComments = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbvForComments.dataSource = self;
        _tbvForComments.delegate = self;
        _tbvForComments.estimatedRowHeight = 100.0f;
        _tbvForComments.scrollEnabled = NO;
        _tbvForComments.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tbvForComments registerClass:[DCSubStageCommentsCell class] forCellReuseIdentifier:stageCommentsCell];
    }
    return _tbvForComments;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _comments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSubStageCommentsModel *model = _comments[indexPath.row];
    DCSubStageCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:stageCommentsCell];
    cell.model = model;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

+ (NSString *)cellReuseIdWithModel:(DCSubStageModel *)model{
    switch (model.modelType) {
        case StageModelTypeDefault:
        case StageModelTypeMoreImg:
            return threeImgCell;
            break;
        case StageModelTypeAImg:{
            return oneImgCell;
        }
            break;
        case StageModelTypeAudio:
            return audioCell;
            break;
        case StageModelTypeVideo:
            return oneImgCell;
            break;
    }
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:praiseid_keyPath];
    [self.model removeObserver:self forKeyPath:collectionid_keyPath];
    [self.model removeObserver:self forKeyPath:praisecount_keyPath];
    [self.model removeObserver:self forKeyPath:collectioncount_keyPath];
    [self.mc_pyq_model removeObserver:self forKeyPath:select_key];
}

@end
