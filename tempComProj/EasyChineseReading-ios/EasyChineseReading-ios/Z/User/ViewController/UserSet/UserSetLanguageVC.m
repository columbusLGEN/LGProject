//
//  USetLanguageVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserSetLanguageVC.h"

#import "AppDelegate.h"
#import "CLMTabBarController.h"

@interface UserSetLanguageVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgChinese;
@property (weak, nonatomic) IBOutlet UIImageView *imgEnglish;

@property (weak, nonatomic) IBOutlet UILabel *lblChinese;
@property (weak, nonatomic) IBOutlet UILabel *lblEnglish;

@end

@implementation UserSetLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 判断是中英文

- (void)updateSystemLanguage
{
    _imgChinese.image = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
    _imgEnglish.image = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? [UIImage imageNamed:cImageUnSelected] : [UIImage imageNamed:cImageSelected];
    
    self.title = LOCALIZATION(@"语言");

    _lblChinese.text = LOCALIZATION(@"中文");
    _lblEnglish.text = LOCALIZATION(@"英文");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 修改本地获取的语言文件-交替
    // 如果 当前的语言环境是英文，选中了中文才切换中文环境
    if (0 == indexPath.row && [UserRequest sharedInstance].language == ENUM_LanguageTypeEnglish) {
        // 设置语言
        [NSBundle setLanguage:@"zh-Hans"];
        // 缓存语言
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    }
    // 如果 当前的语言环境是中文，选中了英文才切换英文环境
    else if (1 == indexPath.row && [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese) {
        [NSBundle setLanguage:@"en"];
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    }
    else {
        return;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self presentLoadingTips:LOCALIZATION(@"正在设置...")];
    WeakSelf(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 把系统windown的rootViewController替换掉
        CLMTabBarController *tab = [[CLMTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        // 跳转到设置页
        tab.selectedIndex = 2;
        // 发送修改语言通知
        [weakself fk_postNotification:kNotificationLanguageChanged];
        [LGPChangeLanguage switchChineseToEnglishOrBack];
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - 0.5, Screen_Width, .5)];
    line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [cell addSubview:line];
}

@end
