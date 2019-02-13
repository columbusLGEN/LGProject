//
//  EDJUserCenterViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJUserCenterViewController.h"
#import "EDJUserCenterHomePageModel.h"
#import "EDJUserCenterHomePageCell.h"
#import "LGCustomButton.h"
#import "UCLoginViewController.h"
#import "LGWKWebViewController.h"
#import "UCPersonInfoViewController.h"
#import "UIImageView+LGExtension.h"

#import "DJNotOpenViewController.h"

static NSString * const uchpCellReuseId = @"EDJUserCenterHomePageCell";

@interface EDJUserCenterViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UCPersonInfoViewControllerDelegate>
@property (strong,nonatomic) NSArray<EDJUserCenterHomePageModel *> *array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBgImageView;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIView *containerHeadIcon;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNick;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UIView *separatLine;
@property (weak, nonatomic) IBOutlet LGCustomButton *headerQuestion;
@property (weak, nonatomic) IBOutlet LGCustomButton *headerCollect;
@property (weak, nonatomic) IBOutlet LGCustomButton *headerUpload;
@property (weak, nonatomic) IBOutlet LGCustomButton *headerMsg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


@end

@implementation EDJUserCenterViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_headIcon cutToCycle];

    /// 最新版本中 头像白边 已经隐藏
//    CGFloat shadowOffset = 2;
//    [_containerHeadIcon cutToCycle];
//    [_containerHeadIcon setShadowWithShadowColor:[UIColor EDJGrayscale_F4]
//                                    shadowOffset:CGSizeMake(shadowOffset, shadowOffset)
//                                   shadowOpacity:1 shadowRadius:shadowOffset];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // TODO: Zup_添加获取用户信息接口，当用户积分增加并且升级时，可以实时变更用户积分等级
    [DJUserNetworkManager.sharedInstance frontUserinfo_selectSuccess:^(id responseObj) {
        DJUser *user = [DJUser mj_objectWithKeyValues:responseObj];
        [self updateInfoWithUser:user];
    } failure:^(id failureObj) {
        [self.tableView.mj_header endRefreshing];
    }];

    /// 查看未读消息数量
    [DJUserNetworkManager.sharedInstance frontUserNotice_selectUnReadNumSuccess:^(id responseObj) {
        NSDictionary *dict = responseObj;
        NSNumber *num = dict[@"num"];
        if (num.intValue == 0) {
            [_headerMsg.img removeLittleRedDot];
        }else{
            [_headerMsg.img addLittleRedDot];
        }
        
    } failure:^(id failureObj) {
        
    }];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self uiConfig];
}

- (void)uiConfig{
    self.view.backgroundColor = [UIColor EDJGrayscale_F3];
    _separatLine.backgroundColor = [UIColor EDJGrayscale_F4];
    
    _topConstraint.constant = -kStatusBarHeight;

    [self setHeaderButtons];
    
    [_tableView setContentInset:UIEdgeInsetsMake(29, 0, 29, 0)];
    [_tableView registerNib:[UINib nibWithNibName:uchpCellReuseId bundle:nil] forCellReuseIdentifier:uchpCellReuseId];
    
    _array = [EDJUserCenterHomePageModel loadLocalPlist];
    [_tableView reloadData];
    
    DJUser *user = [DJUser sharedInstance];
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:DJHeadIconPImage];
    _userNick.text = user.name;
    _level.text = user.gradename;
    _level.textColor = UIColor.EDJMainColor;
    if (user.gradename == nil || [user.gradename isEqualToString:@""]) {
        _level.text = @"先锋党员";
    }
}
// TODO: Zup_添加获取用户信息接口，当用户积分增加并且升级时，可以实时变更用户积分等级
- (void)updateInfoWithUser:(DJUser *)user{
    /// 用户信息本地化
    [user keepUserInfo];
    
    /// 将本地用户信息赋值给单利对象,保证每次用户重新登录之后，都会重新赋值
    [[DJUser sharedInstance] getLocalUserInfo];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self uiConfig];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJUserCenterHomePageModel *model = _array[indexPath.row];
    EDJUserCenterHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:uchpCellReuseId];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

#pragma mark - 跳转
/// MARK: 点击头像 -- 也跳转到我的等级
//- (IBAction)headerIconClick:(id)sender {
//
//}
/// MARK: 跳转到我的等级
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    return NO;/// 返回no 为禁止 segue跳转
//}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /// MARK: 我的信息、党员统计信息、帮助与反馈、设置
    if (indexPath.row == 0) {
        /// 第一行为 我的信息
        UCPersonInfoViewController *pivc = (UCPersonInfoViewController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCPersonInfoViewController"];
        pivc.delegate = self;
        [self.navigationController pushViewController:pivc animated:YES];
    }
    if (indexPath.row == _array.count - 1) {
        /// 设置
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCSettingViewController" animated:YES];
    }
    
    
    if (indexPath.row == 1) {
        /// 党员统计报表
        NSURLComponents *URLComponents = DJNetworkManager.sharedInstance.tableURLComponents;
        NSLog(@"URLComponents: %@",URLComponents);
        NSLog(@"URLComponents.URL: %@",URLComponents.URL);
        LGWKWebViewController *webvc = [LGWKWebViewController.alloc initWithUrl:URLComponents.URL];
        webvc.title = @"党员统计报表";
        [self.navigationController pushViewController:webvc animated:YES];
        
    }
    if (indexPath.row == 2) {
        /// 第三行 帮助与反馈
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCHelpFadebackViewController" animated:YES];
    }
    
}
- (void)headerButtonCick:(UIButton *)sender{

//    [self showNotOpenvc];
    /// MARK: 提问、收藏、上传、消息
    switch (sender.tag) {
        case 0:{
            [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName
                                            controllerId:@"UCMyQuestionViewController"
                                                animated:YES];
        }
            break;
        case 1:{
            [self lgPushViewControllerWithClassName:@"DJMyCollectViewController"];

        }
            break;
        case 2:{
            [self lgPushViewControllerWithClassName:@"UCUploadHomePageViewController"];
        }
            break;
        case 3:{
            /// 消息中心
            [UIApplication.sharedApplication setApplicationIconBadgeNumber:0];
            [self lgPushViewControllerWithClassName:@"UCMsgTableViewController"];
        }
            break;
    }

}

#pragma mark - UCPersonInfoViewControllerDelegate
- (void)pivcUpdateAvadater:(NSURL *)iconUrl{
    [_headIcon sd_setImageWithURL:iconUrl];
}

/// MARK: 展示暂未开放控制器
- (void)showNotOpenvc{
    DJNotOpenViewController *vc = [DJNotOpenViewController new];
    vc.showBackItem = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setHeaderButtons{
    NSString *hbtColorStr = @"333333";
    
    [_headerQuestion setupWithImgName:@"uc_icon_question"
                            labelText:@"提问"
                       labelTextColor:hbtColorStr];
    [_headerQuestion addTarget:self
                        action:@selector(headerButtonCick:)
              forControlEvents:UIControlEventTouchUpInside];
    _headerQuestion.button.tag = 0;
    
    [_headerCollect setupWithImgName:@"uc_icon_collect"
                           labelText:@"收藏"
                      labelTextColor:hbtColorStr];
    [_headerCollect addTarget:self
                       action:@selector(headerButtonCick:)
             forControlEvents:UIControlEventTouchUpInside];
    _headerCollect.button.tag = 1;
    
    [_headerUpload setupWithImgName:@"uc_icon_upload"
                          labelText:@"上传"
                     labelTextColor:hbtColorStr];
    [_headerUpload addTarget:self
                      action:@selector(headerButtonCick:)
            forControlEvents:UIControlEventTouchUpInside];
    _headerUpload.button.tag = 2;
    
    [_headerMsg setupWithImgName:@"uc_icon_msg"
                       labelText:@"消息"
                  labelTextColor:hbtColorStr];
    [_headerMsg addTarget:self
                   action:@selector(headerButtonCick:)
         forControlEvents:UIControlEventTouchUpInside];
    _headerMsg.button.tag = 3;
    
}
@end
