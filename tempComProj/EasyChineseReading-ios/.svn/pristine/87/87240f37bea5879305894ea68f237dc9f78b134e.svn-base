//
//  USetSkinVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserSetSkinVC.h"

static CGFloat const kSectionHeight = 44;
static NSString *const kThemeNameKey = @"kThemeNameKey";   // 主题名键值

@interface UserSetSkinVC ()

@property (strong, nonatomic) NSArray *arrThemeDataSource; // 总主题数组

@property (strong, nonatomic) NSArray *arrSection0;        // tableView indexPath.section == 0
@property (strong, nonatomic) NSArray *arrSection1;        // tableView indexPath.section == 1

@end


@implementation UserSetSkinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *section0 = [NSMutableArray array];
    NSMutableArray *section1 = [NSMutableArray array];
    
    ThemeManager *themeManager = [ThemeManager sharedThemeManager];
    
    NSArray *themePlistKeys = themeManager.dicThemePlist.allKeys;
    _arrThemeDataSource = [NSMutableArray arrayWithArray:themePlistKeys];
    // 将主题分组
    [themePlistKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"成人"])
            [section0 addObject:obj];
        else
            [section1 addObject:obj];
    }];
    // 升序排序
    _arrSection0 = [section0 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    _arrSection1 = [section1 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    [self createNavLeftBackItem];
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"皮肤切换");
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 == section ? _arrSection0.count : _arrSection1.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * Identifier = @"skinCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    
    NSString * text = 0 == indexPath.section ? _arrSection0[indexPath.row] : _arrSection1[indexPath.row];
    cell.textLabel.text = text;
    
    UIImageView *imgSelected = [[UIImageView alloc] init];
    [cell addSubview:imgSelected];
    
    [imgSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.right.mas_equalTo(cell.mas_right).offset(-15);
    }];
    
    ThemeManager * themeManager = [ThemeManager sharedThemeManager];
    NSString * currentTheme = themeManager.themeName;
    if (currentTheme == nil)
        currentTheme = @"成人一";
    if ([currentTheme isEqualToString:text])
        imgSelected.image = [UIImage imageNamed:cImageSelected];
    else
        imgSelected.image = [UIImage imageNamed:cImageUnSelected];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kSectionHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(10, (kSectionHeight - 14) / 2, 3, 14)];
    verLine.backgroundColor = [UIColor cm_mainColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, .5)];
    line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    UILabel *lblType = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 200, kSectionHeight - 2 * 8)];
    lblType.font = [UIFont systemFontOfSize:16.f];
    lblType.textColor = [UIColor cm_blackColor_333333_1];
    lblType.text = section == 0 ? LOCALIZATION(@"成人版") : LOCALIZATION(@"儿童版");
    
    [view addSubview:line];
    [view addSubview:verLine];
    [view addSubview:lblType];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, .5)];
    line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [cell addSubview:line];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 动态更换皮肤
    ThemeManager * themeManager = [ThemeManager sharedThemeManager];
    NSString * themeName = 0 == indexPath.section ? _arrSection0[indexPath.row] : _arrSection1[indexPath.row];
    
    if ([themeName isEqualToString:@"默认"]) {
        themeName = nil;
    }
    if ([themeName isEqualToString:@"成人一"]) {
        [LGSkinSwitchManager changeSkinWithType:ECRHomeUITypeDefault];
    }
    if ([themeName isEqualToString:@"成人二"]) {
        [LGSkinSwitchManager changeSkinWithType:ECRHomeUITypeAdultTwo];
    }
    if ([themeName isEqualToString:@"儿童一"]) {
        [LGSkinSwitchManager changeSkinWithType:ECRHomeUITypeKidOne];
    }
    if ([themeName isEqualToString:@"儿童二"]) {
        [LGSkinSwitchManager changeSkinWithType:ECRHomeUITypeKidtwo];
    }

    // 记录当前主题名字
    themeManager.themeName = themeName;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationThemeChanged object:nil];

    // 主题持久化
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:themeName forKey:kThemeNameKey];
    [userDefaults synchronize];

    // 刷新界面
    [self.tableView reloadData];
    
    // 修改完成，返回到主界面
    [UIApplication sharedApplication].keyWindow.rootViewController = [CLMTabBarController new];
}

@end
