//
//  ECRSubjectHeaderView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/24.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRSubjectHeaderView.h"

@interface ECRSubjectHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *img;


@end

@implementation ECRSubjectHeaderView

- (void)setImgURL:(NSString *)imgURL{
    _imgURL = imgURL;
    
    [_img sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:LGPlaceHolderImg];
}

- (void)setupUI{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

@end
