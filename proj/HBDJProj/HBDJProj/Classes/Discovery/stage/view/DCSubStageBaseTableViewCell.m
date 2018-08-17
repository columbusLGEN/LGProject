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

static NSString * const praiseid_keyPath = @"praiseid";
static NSString * const collectionid_keyPath = @"collectionid";
static NSString * const praisecount_keyPath = @"praisecount";
static NSString * const collectioncount_keyPath = @"collectioncount";

@interface DCSubStageBaseTableViewCell ()<
UITableViewDelegate,
UITableViewDataSource,
LGThreeRightButtonViewDelegate>

@property (strong, nonatomic) UIImageView *icon;/// 头像
@property (strong, nonatomic) UILabel *nick;/// 昵称
@property (strong,nonatomic) UILabel *time;/// 时间

@property (weak,nonatomic) UIView *bottomRect;/// 如果有评论，则隐藏 bottomRect

@property (strong,nonatomic) UITableView *tbvForComments;
@property (strong,nonatomic) NSArray *comments;

@property (weak,nonatomic) LGTriangleView *triangle;

@end

@implementation DCSubStageBaseTableViewCell

- (void)setModel:(DCSubStageModel *)model{
    _model = model;
    _time.text = [model.timestamp timestampToDate_nyr];
    _content.text = model.content;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:DJHeadIconPImage];
    _nick.text = model.uploader;
    
    _comments = model.frontComments;
    [_tbvForComments reloadData];
    
    if (_comments.count) {
        _bottomRect.hidden = YES;
        _triangle.hidden = NO;
        
        [self.boInterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tbvForComments.mas_top);
            make.left.equalTo(self.time.mas_right).offset(-marginTen);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(45);
        }];
        [self.tbvForComments mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.commentsTbvHeight);
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
            make.right.equalTo(self.mas_right);
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

- (void)leftClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 党员舞台点赞
    if ([self.delegate respondsToSelector:@selector(pyqLikeWithModel:)]) {
        [self.delegate pyqLikeWithModel:self.model];
    }
}
- (void)middleClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 党员舞台收藏
    if ([self.delegate respondsToSelector:@selector(pyqCollectWithModel:)]) {
        [self.delegate pyqCollectWithModel:self.model];
    }
}
- (void)rightClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 党员舞台评论
    if ([self.delegate respondsToSelector:@selector(pyqCommentWithModel:)]) {
        [self.delegate pyqCommentWithModel:self.model];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:self.icon.height * 0.5];
}

- (void)configUI {
    
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
        make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
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
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(marginTen);
        make.centerY.equalTo(self.boInterView.mas_centerY);
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
        make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.bottom.equalTo(self.contentView.mas_bottom);
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
        _time.font = [UIFont systemFontOfSize:15];
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
        _tbvForComments.rowHeight = commentsCellHeight;
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
}

@end
