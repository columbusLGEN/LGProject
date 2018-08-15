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

@interface DCSubStageBaseTableViewCell ()<
UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) UIImageView *icon;/// 头像
@property (strong, nonatomic) UILabel *nick;/// 昵称
@property (strong, nonatomic) UILabel *content;/// 文本内容
@property (strong,nonatomic) UILabel *time;/// 时间
@property (strong, nonatomic) LGThreeRightButtonView *boInterView;/// 底部交互按钮
@property (weak,nonatomic) UIView *bottomRect;/// 如果有评论，则隐藏 bottomRect

@property (strong,nonatomic) UITableView *tbvForComments;
@property (strong,nonatomic) NSArray *comments;

@property (weak,nonatomic) LGTriangleView *triangle;

@end

@implementation DCSubStageBaseTableViewCell

- (void)setModel:(DCSubStageModel *)model{
    _model = model;
//    _time.text = model.;
    _content.text = model.content;
    _icon.image = model.testIcon;
    _nick.text = model.nick;
    
    _comments = model.comments;
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
    
}
- (void)configUI {
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nick];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(marginFifteen);
        make.left.equalTo(self.mas_left).offset(leftOffset);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(marginEight);
        make.centerY.equalTo(self.icon.mas_centerY);
    }];
    
    
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(leftOffset);
        make.right.equalTo(self.mas_right).offset(-marginFifteen);
        make.top.equalTo(self.mas_top).offset(contentTopOffset);
    }];
    
    /// cell底部 矩形分割线
    UIView *bottomRect = [UIView new];
    _bottomRect = bottomRect;
    bottomRect.backgroundColor = [UIColor EDJGrayscale_F3];
    [self.contentView addSubview:bottomRect];
    
    [self.contentView addSubview:self.boInterView];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.tbvForComments];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginTen);
        make.centerY.equalTo(self.boInterView.mas_centerY);
        make.width.mas_equalTo(110);
    }];
    [self.boInterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomRect.mas_top);
        make.left.equalTo(self.time.mas_right).offset(-marginTen);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(45);
    }];
    [bottomRect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(5);
    }];
    
    [self.tbvForComments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(leftOffset);
        make.right.equalTo(self.mas_right).offset(-30);
        make.bottom.equalTo(self.mas_bottom);
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
//        _time.text = @"2018年5月21日";
    }
    return _time;
}
- (LGThreeRightButtonView *)boInterView{
    if (_boInterView == nil) {
        _boInterView = [LGThreeRightButtonView new];
        _boInterView.hideTopLine = YES;
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


@end
