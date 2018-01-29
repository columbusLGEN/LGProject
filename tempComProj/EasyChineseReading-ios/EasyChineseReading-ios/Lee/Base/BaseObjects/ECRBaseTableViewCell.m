//
//  ECRBaseTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/25.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@implementation ECRBaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupObserver];
    [self updateSystemLanguage];
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self updateSystemLanguage];
    }];
}

- (void)updateSystemLanguage
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// --------
- (void)textDependsLauguage{
    
}
- (void)setupObserver{
    [self textDependsLauguage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDependsLauguage) name:LGPChangeLanguageNotification object:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupObserver];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupObserver];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
