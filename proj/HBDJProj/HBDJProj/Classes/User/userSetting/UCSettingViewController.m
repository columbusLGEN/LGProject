//
//  UCSettingViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCSettingViewController.h"
#import "UCSettingModel.h"
#import "UCSettingTableViewCell.h"
#import "UCLoginViewController.h"
#import "LGCacheClear.h"
#import "LGUserLimitsManager.h"

static NSString * const settingCell = @"UCSettingTableViewCell";
static CGFloat cellHeight = 59;

@interface UCSettingViewController ()<
UITableViewDelegate,
UCSettingTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) UIButton *logOut;
@property (strong,nonatomic) NSArray *array;
@end

@implementation UCSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 200, 0)];
    self.array = [UCSettingModel loadLocalPlist];
    
    /// 给 检查版本行模型 content 赋值 /// 取倒数第二项
    UCSettingModel *checkVersionModel = self.array[self.array.count - 2];
    checkVersionModel.content;
    
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = 313;
    UIButton *logOut = [[UIButton alloc] initWithFrame:
                        CGRectMake((kScreenWidth - buttonWidth) * 0.5,
                                   _array.count * cellHeight + 20,
                                   buttonWidth,
                                   buttonHeight)];
    [logOut cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:buttonHeight * 0.5];
    [logOut setBackgroundColor:[UIColor EDJMainColor]];
    [logOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOut.titleLabel.font = [UIFont systemFontOfSize:14];
    [logOut addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:logOut];
    _logOut = logOut;
    
    
    [self.tableView reloadData];
    
}
/// 登出
- (void)logOut:(id)sender{
    [[LGLoadingAssit sharedInstance] homeAddLoadingViewTo:self.view];

    [[DJUserNetworkManager sharedInstance] userLogoutSuccess:^(id responseObj) {
       NSLog(@"userlogout_res: %@",responseObj);
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        [[DJUser sharedInstance] removeLocalUserInfo];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:isLogin_key];
        /// 退出登录，重置页面
        [UIApplication sharedApplication].keyWindow.rootViewController = [UCLoginViewController navWithLoginvc];
        
    } failure:^(id failureObj) {
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        NSLog(@"userlogout_failureObj: %@",failureObj);
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCSettingModel *model = _array[indexPath.row];
    UCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCell forIndexPath:indexPath];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UCSettingModel *model = _array[indexPath.row];
    if (model.contentType == 2) {
        LGCacheClear  *cc = LGCacheClear.new;
        [cc clearCacheWithAlertCallBack:^(UIAlertController *alertvc) {
            [self presentViewController:alertvc animated:YES completion:nil];
        } completion:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }

    if ([model.itemName isEqualToString:@"修改密码"]) {
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"DJChangePwdViewController" animated:YES];
    }
}

- (void)stCellClickSwitchWithModel:(UCSettingModel *)model sender:(UISwitch *)sender{
    if (model.contentType == 1) {
        if (model.subType == 0) {
            /// 系统通知
            UIAlertController *alertvc = [LGUserLimitsManager.new showSetPushNotificationAlertViewWithViewController:self cancelABlock:^(UIAlertAction * _Nonnull action) {
                sender.on = !sender.on;
            } doneBlock:nil];
            [self presentViewController:alertvc animated:YES completion:nil];
        }
        if (model.subType == 1) {
            /// 是否开启非wifi播放提醒
            sender.on = !sender.isOn;
            
            NSInteger notice = 0;
            if (sender.isOn) {
                notice = 1;
            }else{
                notice = 2;
            }
            DJUser.sharedInstance.WIFI_playVideo_notice = notice;
            [[NSUserDefaults standardUserDefaults] setObject:@(notice) forKey:NWiFi_notice_key];
        }
    }
}

@end
