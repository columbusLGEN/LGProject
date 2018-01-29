//
//  ECRBaseTableViewHeaderFooterView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewHeaderFooterView.h"

@implementation ECRBaseTableViewHeaderFooterView

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
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupObserver];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
