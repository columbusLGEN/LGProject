//
//  USetVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserSetVC.h"

#import "SDImageCache.h"

#import "UserCommentVC.h"
#import "UserSetSkinVC.h"
#import "UserSetLanguageVC.h"
#import "UserSetAboutVC.h"
#import "UserSetAboutVC_phone.h"
#import "LoginVC.h"
#import "ECRLocalFileManager.h"

@interface UserSetVC ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *cellAllow;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellAdvice;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellClearCache;

@property (weak, nonatomic) IBOutlet UILabel *lblThemeChange; // 主题切换
@property (weak, nonatomic) IBOutlet UILabel *lblLanguage;    // 语言切换
@property (weak, nonatomic) IBOutlet UILabel *lblAllow;       // 允许好友查看
@property (weak, nonatomic) IBOutlet UILabel *lblAppUpdate;   // 版本更新
@property (weak, nonatomic) IBOutlet UILabel *lblAdvice;      // 意见反馈
@property (weak, nonatomic) IBOutlet UILabel *lblCleaerCache; // 清空缓存
@property (weak, nonatomic) IBOutlet UILabel *lblAbout;       // 关于

@property (weak, nonatomic) IBOutlet UILabel *lblCacheSize;   // 缓存大小
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;     // 退出登录

@property (weak, nonatomic) IBOutlet UISwitch *switchAllow;   // 允许好友查看我的信息开关

// 右箭头 -----
@property (weak, nonatomic) IBOutlet UIImageView *imgRA0;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA1;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA3;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA4;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA5;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA6;
// -----

@end

@implementation UserSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSetView];
    [self createNavLeftBackItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"设置");

    _lblThemeChange.text = LOCALIZATION(@"皮肤切换");
    _lblLanguage.text    = LOCALIZATION(@"语言");
    _lblAllow.text       = LOCALIZATION(@"允许好友查看我的信息");
    _lblAppUpdate.text   = LOCALIZATION(@"版本更新");
    _lblAdvice.text      = LOCALIZATION(@"意见反馈");
    _lblCleaerCache.text = LOCALIZATION(@"清空缓存");
    _lblAbout.text       = LOCALIZATION(@"关于");
    
    [_btnLogout setTitle:LOCALIZATION(@"退出登录") forState:UIControlStateNormal];
}

#pragma mark - 配置设置界面

- (void)configSetView
{
    _cellAllow.hidden      = ![[UserRequest sharedInstance] online];
    _cellAdvice.hidden     = ![[UserRequest sharedInstance] online];
    _cellClearCache.hidden = ![[UserRequest sharedInstance] online];
    
    _btnLogout.hidden = ![[UserRequest sharedInstance] online];
    self.tableView.estimatedSectionHeaderHeight = 0;
    _lblCacheSize.text = [NSString stringWithFormat:@"%.1f M", [self getCacheSize]];
    
    _btnLogout.layer.masksToBounds = YES;
    _btnLogout.layer.cornerRadius = _btnLogout.height/2;
    
    [_btnLogout setBackgroundColor:[UIColor cm_mainColor]];
    [_btnLogout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _switchAllow.onTintColor = [UIColor cm_mainColor];
    _switchAllow.on = [UserRequest sharedInstance].user.canview;
    
    _imgRA0.image = _imgRA1.image = _imgRA3.image =  _imgRA4.image = _imgRA5.image = _imgRA6.image = [UIImage imageNamed:@"icon_arrow_right"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 根据 cellID 获取执行方法，要求 id 与执行方法必须一样!!! 如果错误, 则找不到该方法, 必崩溃!!!
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![NSString isEmpty:cell.reuseIdentifier]) {
        SEL method = NSSelectorFromString(cell.reuseIdentifier);
        [self performSelector:method withObject:nil afterDelay:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[UserRequest sharedInstance] online] && (2 == indexPath.row || 4 == indexPath.row || 5 == indexPath.row))
        return .5;
    else
        return 44.f;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self clearCache];
    }
}

#pragma mark - 设置操作

/** 允许好友查看我的信息 */
- (IBAction)changeSwitchAllow:(id)sender {
    WeakSelf(self)
    [[UserRequest sharedInstance] updateUserInfoCanBrowse:[NSString stringWithFormat:@"%d", _switchAllow.on]
                                               completion:^(id object, ErrorModel *error) {
                                                   StrongSelf(self)
                                                   if (error) {
                                                       _switchAllow.on = !_switchAllow.on;
                                                       [self presentFailureTips:error.message];
                                                   }
                                                   else {
                                                       [UserRequest sharedInstance].user.canview = _switchAllow.on;
                                                       [[UserRequest sharedInstance] saveCache];
                                                   }
                                               }];
}

/** 意见反馈 */
- (void)comment
{
    [self pushToViewControllerWithStoryBoard:@"User" withStoryBoardId:NSStringFromClass([UserCommentVC class])];
}

/** 清理缓存 */
- (void)clear
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:LOCALIZATION(@"清除所有的缓存?") delegate:self cancelButtonTitle:nil destructiveButtonTitle:LOCALIZATION(@"确定") otherButtonTitles:LOCALIZATION(@"取消"), nil];
    [actionSheet showInView:self.view];
}

/** 更新(跳转 appStore) */
- (void)update
{
    // TODO: 更新appid
    NSString *app_id = @"";
    //去appstore中更新
    NSString *appStoreLink = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", app_id];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
}

/** 仅在wifi情况下同步电子书 */
- (void)wifi
{
    // nil
}

/** 允许好友查看我的信息 -- 个人信息中 Ta 正在读的书是否显示*/
- (void)allow
{
    // nil
}

/** 关于 */
- (void)about
{
    if (isPad)
        [self pushToViewControllerWithStoryBoard:@"User" withStoryBoardId:NSStringFromClass([UserSetAboutVC class])];
    else
        [self pushToViewControllerWithStoryBoard:@"User" withStoryBoardId:NSStringFromClass([UserSetAboutVC_phone class])];
}

/** 语言切换 */
- (void)language
{
    [self pushToViewControllerWithStoryBoard:@"User" withStoryBoardId:NSStringFromClass([UserSetLanguageVC class])];
}

/** 皮肤切换 */
- (void)skin
{
    [self pushToViewControllerWithStoryBoard:@"User" withStoryBoardId:NSStringFromClass([UserSetSkinVC class])];
}

#pragma mark - 退出登录
- (IBAction)click_btnLogout:(id)sender {
    [self logout];
}

- (void)logout
{
    [self showWaitTips];

    WeakSelf(self)
    // 通知退出
    [[UserRequest sharedInstance] logoutWithCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            // 清楚缓存、发布退出通知
            [[UserRequest sharedInstance] signout];
            [self pushToViewControllerWithClassName:NSStringFromClass([LoginVC class])];
        }
    }];
}

#pragma mark - 获取缓存
/** 获取缓存大小 */
- (float)getCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float m_file_size = [self folderSizeAtPath:cachePath];
    
    NSInteger byteImageData = [[SDImageCache sharedImageCache] getSize];
    float m_image_size = byteImageData / (1024.f * 1024.f);
    
    return m_file_size + m_image_size;
}

/** 根据路径获取文件夹大小 */
- (float)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
}

/** 根据路径获取文件夹大小 */
- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 清除缓存
- (void)clearCache
{
    [self presentLoadingTips:LOCALIZATION(@"正在清理缓存, 请稍后..")];
    [ECRLocalFileManager clearLocalFiles];
    WeakSelf(self)
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        StrongSelf(self)
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
            //NSLog ( @"cachpath = %@" , cachePath);
            for ( NSString *p in files) {
                NSError *error = nil ;
                //获取文件全路径
                NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:p];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:&error];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissTips];
                [self presentSuccessTips:LOCALIZATION(@"清理完成")];
                //读取缓存大小
                _lblCacheSize.text = [NSString stringWithFormat:@"%.1f M",[self getCacheSize]];
            });
        });
    }];
}

@end
