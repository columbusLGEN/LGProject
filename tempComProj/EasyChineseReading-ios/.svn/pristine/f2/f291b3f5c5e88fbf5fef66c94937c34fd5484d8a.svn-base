//
//  ECRBaseCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/25.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseCollectionViewCell.h"

@implementation ECRBaseCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self updateSystemLanguage];
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self updateSystemLanguage];
    }];
}

- (void)updateSystemLanguage
{
    
}

// --------
- (void)textDependsLauguage{
    
}
- (void)setupObserver{
    [self textDependsLauguage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDependsLauguage) name:LGPChangeLanguageNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
