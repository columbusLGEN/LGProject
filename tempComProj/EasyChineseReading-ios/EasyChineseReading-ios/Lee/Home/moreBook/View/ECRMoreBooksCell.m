//
//  ECRMoreBooksCell.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRMoreBooksCell.h"
#import "BookModel.h"

@interface ECRMoreBooksCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *bName;
@property (weak, nonatomic) IBOutlet UILabel *bAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bSynopsis;
@property (weak, nonatomic) IBOutlet UIView *starView;
/** 新评价view */
@property (strong,nonatomic) ZStarView *nsView;
@property (weak, nonatomic) IBOutlet UILabel *bMoney;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *bMoneyNum;
@property (weak, nonatomic) IBOutlet UIImageView *icon_coin;


@end

@implementation ECRMoreBooksCell

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

- (void)setModel:(BookModel *)model{
    _model = model;
    
    [_cover sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil];
    
    NSString *ass = LOCALIZATION(@"作者");/// author solid string
    NSString *jss = LOCALIZATION(@"简介");/// 简介 solid string
    
    _bName.text     = [NSString stringWithFormat:@"%@",model.bookName];
    _bAuthor.text   = [NSString stringWithFormat:@"%@：%@",ass,model.author];
    if (model.contentValidity == nil) {// 如果不处理,会出现 (null) 情况
        _bSynopsis.text = [NSString stringWithFormat:@"%@：",jss];
    }else{
        _bSynopsis.text = [NSString stringWithFormat:@"%@：%@",jss,model.contentValidity];
    }
    [self.nsView setScore:model.score withAnimation:NO];
//    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
//        _bName.text     = [NSString stringWithFormat:@"%@",model.en_bookName];
//        _bAuthor.text   = [NSString stringWithFormat:@"作者：%@",model.en_author];
//        _bSynopsis.text = [NSString stringWithFormat:@"简介：%@",model.en_contentValidity];
//    }else{
//    }
    
    _bMoneyNum.text = [NSString stringWithFormat:@"%.2f",model.price];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _cover.clipsToBounds = YES;
    UIColor *lColor = [UIColor colorWithHexString:@"e3e3e3"];
    _line.backgroundColor = lColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nsView = [[ZStarView alloc] initWithFrame:CGRectMake(0, 0, 20*5, 20) numberOfStar:5];
    [self.starView addSubview:self.nsView];
    [_icon_coin setImage:[UIImage imageNamed:@"icon_virtual_currency"]];
}


@end


