//
//  UCHelpFadebackTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCHelpFadebackTableViewCell.h"
#import "UCHelpFadebackModel.h"

static CGFloat marginLeft = 19;
static CGFloat marginTop = 21;
static CGFloat timeWidth = 85;

@interface UCHelpFadebackTableViewCell ()
@property (weak,nonatomic) UILabel *question;
@property (weak,nonatomic) UILabel *answer;
@property (weak,nonatomic) UILabel *time;
@property (weak,nonatomic) UIView *line;

@end

@implementation UCHelpFadebackTableViewCell

- (void)setModel:(UCHelpFadebackModel *)model{
    _model = model;
    
//    model.title = @"推送的流程是这样的，程序运行起来以后，会判断是否这个程序要推送，如果要的话会需要将手机和推送证书生成的一个唯一标识字符串（decice token）传到我们自己的服务器去，服务器根据这个token和一个服务器端的证书文件一起将配合，将一个推送消息发给苹果的apns服务器，苹果根据这个token发送给指定的设备。所以只要你在服务器端将登录的用户的用户信息和这个token做一个关联，完全可以指定发给某一个人，而不是发给所有人。--某位网友";
//    model.answer = @"推送的流程是这样的，程序运行起来以后，会判断是否这个程序要推送，如果要的话会需要将手机和推送证书生成的一个唯一标识字符串（decice token）传到我们自己的服务器去，服务器根据这个token和一个服务器端的证书文件一起将配合，将一个推送消息发给苹果的apns服务器，苹果根据这个token发送给指定的设备。所以只要你在服务器端将登录的用户的用户信息和这个token做一个关联，完全可以指定发给某一个人，而不是发给所有人。--某位网友";
    
    NSString *questionString = [@"问: " stringByAppendingString:model.title];
    CGFloat questionWidth = kScreenWidth - marginLeft * 2;
    
    CGFloat oneLineTitleHeight = 20.3;
    
    CGFloat questionHeight = [questionString sizeOfTextWithMaxSize:CGSizeMake(questionWidth, MAXFLOAT) font:[UIFont systemFontOfSize:17]].height;
    
    CGFloat lines = questionHeight / oneLineTitleHeight;
    
    NSInteger numberOfLines = ceil(lines);
    
    _question.numberOfLines = numberOfLines;

    [_question mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(marginLeft);
        make.right.equalTo(self.contentView.mas_right).offset(-marginLeft);
        make.top.equalTo(self.contentView.mas_top).offset(marginTop);
        make.height.mas_equalTo(numberOfLines * oneLineTitleHeight);
    }];
    
    
    _question.text = questionString;
    _answer.text = [@"答: " stringByAppendingString:model.answer];
    
    if (model.showTimeLabel) {
        
//        [_question mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(marginLeft);
//            make.right.equalTo(self.time.mas_left).offset(-marginEight);
//            make.top.equalTo(self.contentView.mas_top).offset(marginTop);
//            make.height.mas_equalTo(lines * 20);
//        }];
        
        /// 显示 时间lable
        _time.text = [model.createdtime substringToIndex:length_timeString_1];
        [self.answer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.question.mas_bottom).offset(marginTen);
            make.left.equalTo(self.question);
            make.right.equalTo(self.contentView.mas_right).offset(-marginLeft);
        }];
    }else{
        [self.time removeFromSuperview];
        [self.answer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.question.mas_bottom).offset(marginTen);
            make.left.equalTo(self.question);
            make.right.equalTo(self.contentView.mas_right).offset(-marginLeft);
            make.bottom.equalTo(_line.mas_top).offset(-marginEight);
        }];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *question = [[UILabel alloc] initWithFrame:CGRectZero];
        question.numberOfLines = 1;
        question.textColor = [UIColor EDJColor_9B1212];
        question.font = [UIFont systemFontOfSize:17];
        question.text = @"问: 讲习不能刷新加载怎么办";
        [self.contentView addSubview:question];
        _question = question;
        
        UILabel *time = [UILabel new];
        time.textColor = [UIColor EDJGrayscale_33];
        time.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:time];
        _time = time;
        
        UILabel *answer = [[UILabel alloc] initWithFrame:CGRectZero];
        answer.numberOfLines = 0;
        answer.textColor = [UIColor EDJGrayscale_33];
        answer.font = [UIFont systemFontOfSize:14];
        answer.text = @"答: 您好,请先清理缓存";
        [self.contentView addSubview:answer];
        _answer = answer;
        
        /// TODO: 添加展开收起按钮
        
        /// TODO: 时间标签放在答案下面
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor EDJGrayscale_F3];
        [self.contentView addSubview:line];
        _line = line;

        [question mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginLeft);
            make.right.equalTo(self.contentView.mas_right).offset(-marginLeft);
            make.top.equalTo(self.contentView.mas_top).offset(marginTop);
            make.height.mas_equalTo(20);
        }];

        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.answer);
            make.top.equalTo(self.answer.mas_bottom).offset(marginEight);
            make.width.mas_equalTo(timeWidth);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(line.mas_top).offset(-marginEight);
        }];
        
        [answer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.question.mas_bottom).offset(marginTen);
            make.left.equalTo(self.question);
            make.right.equalTo(self.contentView.mas_right).offset(-marginLeft);
//            make.bottom.equalTo(line.mas_top).offset(-marginEight);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        _question = question;
        _time     = time;
        _answer   = answer;
        _line     = line;
        
    }
    return self;
}

@end
