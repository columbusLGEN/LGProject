//
//  FirstLaunchCountryVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "FirstLaunchCountryVC.h"

#import "UserInfoAddressVC.h"
#import "FirstLaunchBirthdayVC.h"
#import "ECRLocationManager.h"

@interface FirstLaunchCountryVC ()

@property (strong, nonatomic) UIImageView *imgBackground;   // 背景图
@property (strong, nonatomic) UILabel     *lblCountry;      // 选中的国家名
@property (strong, nonatomic) UIButton    *btnNext;         // 下一步

@property (strong, nonatomic) UIImageView *imgHeader;       // 顶部图片
@property (strong, nonatomic) UIImageView *imgHeaderDesc;   // 描述图片
@property (strong, nonatomic) UIImageView *imgIcon;         // 定位小图标
@property (strong, nonatomic) UIView *topLine;              // 国家顶部线
@property (strong, nonatomic) UIView *botLine;              // 国家底部线

@property (strong, nonatomic) NSMutableArray *arrCountry;   // 国家数组

@end

@implementation FirstLaunchCountryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self configCountryView];

    // 定位国家
    WeakSelf(self)
    [ECRLocationManager rg_startUpdatingLocationWithBlock:^(NSString *country) {
        StrongSelf(self)
        if ([country isNot:@"中国"])
            _lblCountry.text = LOCALIZATION(country);
        [self getCountrys];
    }];
}

#pragma mark - 配置首次启动选择国家界面
- (void)configCountryView
{
    CountryModel *country = [CountryModel new];
    country.zh_name = @"中国";
    country.en_name = @"China";
    [[CacheDataSource sharedInstance] setCache:country withCacheKey:CacheKey_SelectCountry];
    
    _imgBackground = [UIImageView new];
    _imgBackground.image = isPad ? [UIImage imageNamed:@"img_background_launchScreen_pad"] : [UIImage imageNamed:@"img_background_launchScreen"];
    [self.view addSubview:_imgBackground];
    
    _lblCountry = [UILabel new];
    _lblCountry.textColor = [UIColor cm_blackColor_666666_1];
    _lblCountry.font = [UIFont systemFontOfSize:22.f];
    _lblCountry.text = @"China";
    _lblCountry.textAlignment = NSTextAlignmentCenter;
    _lblCountry.userInteractionEnabled = YES;
    [self.view addSubview:_lblCountry];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSelectCountry)];
    [_lblCountry addGestureRecognizer:tap];
    
    _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 86*2, cButtonHeight_40)];
    _btnNext.backgroundColor = [UIColor cm_yellowColor_FFE402_1];
    _btnNext.titleLabel.font = [UIFont systemFontOfSize:cFontSize_16];
    _btnNext.titleLabel.textColor = [UIColor whiteColor];
    _btnNext.layer.cornerRadius  = _btnNext.height/2;
    _btnNext.layer.masksToBounds = YES;
    [_btnNext setTitle:@"Next" forState:UIControlStateNormal];
    [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnNext addTarget:self action:@selector(toSelectedBirthday) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnNext];
    
    _imgHeader = [UIImageView new];
    _imgHeader.image = [UIImage imageNamed:@"img_launch_header_location"];
    [self.view addSubview:_imgHeader];
    
    _imgHeaderDesc = [UIImageView new];
    _imgHeaderDesc.image = [UIImage imageNamed:@"img_launch_country_of_nationality"];
    [self.view addSubview:_imgHeaderDesc];
    
    _imgIcon = [UIImageView new];
    _imgIcon.image = [UIImage imageNamed:@"icon_launch_location"];
    [self.view addSubview:_imgIcon];
    
    _topLine = [UIView new];
    _topLine.backgroundColor = [UIColor cm_yellowColor_FFE402_1];
    [self.view addSubview:_topLine];
    
    _botLine = [UIView new];
    _botLine.backgroundColor = [UIColor cm_yellowColor_FFE402_1];
    [self.view addSubview:_botLine];
    
    [self updateConstraint];
}

/** 修改约束 */
- (void)updateConstraint
{
    [_imgBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [_lblCountry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([NSString stringWidthWithText:_lblCountry.text fontSize:_lblCountry.font.pointSize] + 20, cHeaderHeight_64));
    }];
    [_btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom .mas_equalTo(self.view.mas_bottom).offset(isPad ? -100 : -cHeaderHeight_44);
        make.size.mas_equalTo(CGSizeMake(self.view.width - 86*2, cButtonHeight_40));
    }];
    
    [_imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.top).offset(isPad ? 150.f : cHeaderHeight_64);
    }];
    [_imgHeaderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(_imgHeader.mas_bottom).offset(30);
    }];
    [_imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_lblCountry.mas_centerY);
        make.right.mas_equalTo(_lblCountry.mas_left).offset(-20);
    }];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_lblCountry.mas_leading);
        make.trailing.mas_equalTo(_lblCountry.mas_trailing);
        make.bottom.mas_equalTo(_lblCountry.mas_top);
        make.height.mas_equalTo(3.f);
    }];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_lblCountry.mas_leading);
        make.trailing.mas_equalTo(_lblCountry.mas_trailing);
        make.top.mas_equalTo(_lblCountry.mas_bottom);
        make.height.mas_equalTo(3.f);
    }];
}

#pragma mark -

/** 选择国家 */
- (void)getCountrys
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getCountrysComplention:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:LOCALIZATION(@"获取国家列表失败")];
        }
        else {
            _arrCountry = [CountryModel mj_objectArrayWithKeyValuesArray:object];
            [[CacheDataSource sharedInstance] setCache:_arrCountry withCacheKey:CacheKey_CountryList];
            [_arrCountry enumerateObjectsUsingBlock:^(CountryModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.zh_name isEqualToString:_lblCountry.text] || [obj.en_name isEqualToString:_lblCountry.text]) {
                    [[CacheDataSource sharedInstance] setCache:obj withCacheKey:CacheKey_SelectCountry];
                }
            }];
        }
    }];
}

/** 到选择国家列表界面 */
- (void)toSelectCountry
{
    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = ENUM_LanguageTypeEnglish;
    WeakSelf(self)
    addressVC.selectedCountryBlock = ^(CountryModel * country){
        StrongSelf(self)
        self.lblCountry.text = country.en_name;
        [self.lblCountry mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([NSString stringWidthWithText:_lblCountry.text fontSize:_lblCountry.font.pointSize] + 20, cHeaderHeight_64));
        }];
        [[CacheDataSource sharedInstance] setCache:country withCacheKey:CacheKey_SelectCountry];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

/** 下一步，到选择生日界面 */
- (void)toSelectedBirthday
{
    FirstLaunchBirthdayVC *birthdayVC = [FirstLaunchBirthdayVC new];
    [self.navigationController pushViewController:birthdayVC animated:YES];
}

@end
