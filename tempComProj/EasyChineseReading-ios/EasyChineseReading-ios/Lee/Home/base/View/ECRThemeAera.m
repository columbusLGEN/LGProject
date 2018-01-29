//
//  ECRThemeAera.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

static CGFloat margin = 16;// 到屏幕两边的距离
//static CGFloat taHeight = 220;// 主题// 父view 中也有这个高度,后期需优化

#import "ECRThemeAera.h"
#import "ECRHeadlineView.h"
#import "ECRThematicModel.h"

@interface ECRThemeAera ()
@property (strong,nonatomic) ECRHeadlineView *headLine;// 标题
@property (assign,nonatomic) CGFloat headLineHeight;//
@property (assign,nonatomic) CGFloat taHeight;//
@property (strong,nonatomic) UIButton *tlButton;// top left
@property (strong,nonatomic) UIButton *blButton;// bottom left
@property (strong,nonatomic) UIButton *trButton;// top right
@property (strong,nonatomic) UIButton *brButton;// bottom right

@property (assign,nonatomic) CGFloat marginV;//
@property (assign,nonatomic) CGFloat marginH;//

@end

@implementation ECRThemeAera

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height{
    self.taHeight = height;
    return [self initWithFrame:frame];
}

- (void)buttonClick:(UIButton *)sender{
    if (self.models.count) {
        ECRThematicModel *model = self.models[sender.tag];;
        if ([self.delegate respondsToSelector:@selector(taView:model:)]) {
            [self.delegate taView:self model:model];
        }
    }
}
- (void)setModels:(NSArray<ECRThematicModel *> *)models{
    _models = models;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        for (NSInteger i = 0; i < models.count; i++) {
            ECRThematicModel *obj = models[i];
            switch (i) {
                case 0:{
                    // 上左
//                    [self.tlButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];
                    [self.tlButton sd_setImageWithURL:[NSURL URLWithString:obj.specialPic] forState:UIControlStateNormal placeholderImage:LGPlaceHolderImg];
                }
                    break;
                case 1:{
                    // 上右
//                    [self.trButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];
                    [self.trButton sd_setImageWithURL:[NSURL URLWithString:obj.specialPic] forState:UIControlStateNormal placeholderImage:LGPlaceHolderImg];
                }
                    break;
                case 2:{
                    // 下左
//                    [self.blButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];
                    [self.blButton sd_setImageWithURL:[NSURL URLWithString:obj.specialPic] forState:UIControlStateNormal placeholderImage:LGPlaceHolderImg];
                }
                    break;
                case 3:{
                    // 下右
//                    [self.brButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];
                    [self.brButton sd_setImageWithURL:[NSURL URLWithString:obj.specialPic] forState:UIControlStateNormal placeholderImage:LGPlaceHolderImg];
                }
                    break;
            }
        }
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headLine];
        [self addSubview:self.tlButton];
        [self addSubview:self.trButton];
        [self addSubview:self.blButton];
        [self addSubview:self.brButton];
        
        [self.headLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(self.headLineHeight));
        }];
        
        CGFloat btnW = (Screen_Width - self.marginH - 2 * margin)/2;
        CGFloat btnH = (self.taHeight - self.headLineHeight - 2 * self.marginV)/2;
        [self.tlButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headLine.mas_bottom);//.offset(5);
            make.left.equalTo(self.mas_left).offset(margin);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
        [self.trButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tlButton.mas_top);
            make.left.equalTo(self.tlButton.mas_right).offset(self.marginH);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
        [self.blButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tlButton.mas_bottom).offset(self.marginV);
            make.left.equalTo(self.tlButton.mas_left);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
        [self.brButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.blButton.mas_top);
            make.left.equalTo(self.trButton.mas_left);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
        [self.tlButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];
        [self.trButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];
        [self.blButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];
        [self.brButton setImage:[UIImage imageNamed:@"bys_16"] forState:UIControlStateNormal];

        [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
    }
    return self;
}

- (void)skinWithType:(ECRHomeUIType)type{
    switch (type) {
        case ECRHomeUITypeDefault:{
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
        case ECRHomeUITypeAdultTwo:{
            self.backgroundColor = [UIColor clearColor];
        }
            break;
        case ECRHomeUITypeKidOne:{
            self.backgroundColor = [UIColor clearColor];
        }
            break;
        case ECRHomeUITypeKidtwo:{
            
        }
            break;
    }
    _headLine.iconImgName = @"icon_home_thmatic";
}
- (ECRHeadlineView *)headLine{
    if (_headLine == nil) {
        _headLine = [[ECRHeadlineView alloc] init];
        _headLine.headTitle = @"主题专栏";
    }
    return _headLine;
}
- (UIButton *)tlButton{
    if (_tlButton == nil) {
        _tlButton = [[UIButton alloc] init];
        _tlButton.tag = 0;
        [[_tlButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
        _tlButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        _tlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [self addTargetWithButton:_tlButton];
    }
    return _tlButton;
}
- (UIButton *)blButton{
    if (_blButton == nil) {
        _blButton = [[UIButton alloc] init];
        _blButton.tag = 2;
        [[_blButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
        _blButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        _blButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [self addTargetWithButton:_blButton];
    }
    return _blButton;
}
- (UIButton *)trButton{
    if (_trButton == nil) {
        _trButton = [[UIButton alloc] init];
        _trButton.tag = 1;
        [[_trButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
        _trButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        _trButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [self addTargetWithButton:_trButton];
    }
    return _trButton;
}
- (UIButton *)brButton{
    if (_brButton == nil) {
        _brButton = [[UIButton alloc] init];
        _brButton.tag = 3;
        [[_brButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
        _brButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        _brButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [self addTargetWithButton:_brButton];
    }
    return _brButton;
}
- (void)addTargetWithButton:(UIButton *)button{
    [button addTarget:self
               action:@selector(buttonClick:)
     forControlEvents:UIControlEventTouchUpInside];
}
- (CGFloat)headLineHeight{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 46;
    }else{
        return 36;
    }
}
- (CGFloat)marginH{
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 30;
    }else{
        return 14;
    }
}
- (CGFloat)marginV{
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 23;
    }else{
        return 14;
    }
}

@end
