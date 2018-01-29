//
//  ECRSeriesBooksView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/20.
//  Copyright © 2017年 retech. All rights reserved.
//

static CGFloat margin = 12;
static CGFloat marginToBound = 13;
//static CGFloat iconW = 67;
//static CGFloat iconH = 116;
//static CGFloat itemW = 60;

#import "ECRSeriesBooksView.h"
#import "ECRSeriesModel.h"
#import "ECRHome.h"

@interface ECRSeriesBooksView ()
/** 系列封面 & 图书封面 宽度 */
@property (assign,nonatomic) CGFloat iconW;//
/** 系列封面 高度 */
@property (assign,nonatomic) CGFloat iconH;
/** cell 宽度 */
@property (assign,nonatomic) CGFloat itemW;//

@property (strong,nonatomic) UIImageView *icon;//
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;//
@property (strong,nonatomic) UIButton *button;//

@end

@implementation ECRSeriesBooksView

- (void)serialClick:(UIButton *)sender{
    NSDictionary *dict = @{ECRHomeSerialClickKey:self.model};
    [[NSNotificationCenter defaultCenter] postNotificationName:ECRHomeSerialClickNotification object:nil userInfo:dict];
}

- (void)setModel:(ECRSeriesModel *)model{
    _model = model;
//    NSLog(@"系列id -- %ld",model.serialId);
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.serialUrl] placeholderImage:LGPlaceHolderImg];
    }else{
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.en_serialUrl] placeholderImage:LGPlaceHolderImg];
    }
//    model.serialName;
    
}

- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    [self.icon setImage:[UIImage imageNamed:imgName]];
    
}

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height{

    CGFloat imgW;
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        imgW = (Screen_Width - 7 * [ECRMultiObject homeBookCoverSpace]) / 6;
        self.iconH = imgW + 100;
    }else{
        imgW = (Screen_Width - 5 * [ECRMultiObject homeBookCoverSpace]) / 4;
        self.iconH = imgW + 85;
    }
    self.itemW = imgW;
    self.iconW = imgW + 7;
    
    return [self initWithFrame:frame];
}

- (void)setupUI{
//    self.backgroundColor = [UIColor randomColor];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [LGSkinSwitchManager homeBorderColor].CGColor;
    
    [self addSubview:self.button];
    [self addSubview:self.icon];
    [self addSubview:self.collectionView];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_top);
        make.left.equalTo(self.icon.mas_left);
        make.bottom.equalTo(self.icon.mas_bottom);
        make.right.equalTo(self.icon.mas_right);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(margin);
        make.left.equalTo(self.mas_left).offset(margin);
        make.width.equalTo(@(self.iconW));
        make.height.equalTo(@(self.iconH));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_top);
        make.left.equalTo(self.icon.mas_right).offset(self.marginC);
        make.right.equalTo(self.mas_right).offset(-marginToBound);
        make.height.equalTo(@(self.iconH));
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUI:) name:kNotificationChangeHomeUI object:nil];
    [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
}
- (void)changeUI:(NSNotification *)notification{
    NSNumber *type = notification.userInfo[kNotificationChangeHomeUIKey];
    [self skinWithType:type.integerValue];
}
- (void)skinWithType:(ECRHomeUIType)type{
    switch (type) {
        case ECRHomeUITypeDefault:{
        }
//            break;
        case ECRHomeUITypeAdultTwo:{
            self.layer.cornerRadius = 0;
            self.layer.masksToBounds = NO;
            [self setShadowWithShadowColor:nil
                                               shadowOffset:CGSizeZero
                                              shadowOpacity:0
                                               shadowRadius:0];
        }
            break;
        case ECRHomeUITypeKidOne:{
            self.layer.cornerRadius = 28;
            self.layer.masksToBounds = YES;
            [self unifySetShadow];
        }
            break;
        case ECRHomeUITypeKidtwo:{
            self.layer.cornerRadius = 28;
            self.layer.masksToBounds = YES;
            [self unifySetShadow];
        }
            break;
    }
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

- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}
- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton new];
        [_button addTarget:self
                    action:@selector(serialClick:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.itemW, self.iconH);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat space;
        if ([ECRMultiObject userInterfaceIdiomIsPad]) {
            space = 20;
        }else{
            space = 8;
        }
        _flowLayout.minimumLineSpacing = space;
//        _flowLayout.minimumInteritemSpacing;
    }
    return _flowLayout;
}
- (CGFloat)marginC{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return 26;
    }else{
        return 12;
    }
}

@end
