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

static NSString * const uchpCellReuseId = @"EDJUserCenterHomePageCell";

@interface EDJUserCenterViewController ()<
UITableViewDelegate,
UITableViewDataSource>
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


@end

@implementation EDJUserCenterViewController

- (void)viewDidLayoutSubviews{/// 先执行viewdidload再执行该方法
    [_containerHeadIcon cutToCycle];
    [_headIcon cutToCycle];
    CGFloat shadowOffset = 2;
    [_containerHeadIcon setShadowWithShadowColor:[UIColor EDJGrayscale_F4]
                                    shadowOffset:CGSizeMake(shadowOffset, shadowOffset)
                                   shadowOpacity:1 shadowRadius:shadowOffset];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self uiConfig];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

- (void)uiConfig{
    self.view.backgroundColor = [UIColor EDJGrayscale_F3];
    _separatLine.backgroundColor = [UIColor EDJGrayscale_F4];

    [self setHeaderButtons];
    
    [_tableView setContentInset:UIEdgeInsetsMake(29, 0, 29, 0)];
    [_tableView registerNib:[UINib nibWithNibName:uchpCellReuseId bundle:nil] forCellReuseIdentifier:uchpCellReuseId];
    
    _array = [EDJUserCenterHomePageModel loadLocalPlist];
    [_tableView reloadData];
    
    DJUser *user = [DJUser sharedInstance];
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:DJPlaceholderImage];
    _userNick.text = user.name;
    /// TODO: 设置党员等级文本
    _level.text = @"先锋党员一级";
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
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        /// 第一行为 我的信息
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCPersonInfoViewController" animated:YES];
    }
    if (indexPath.row == 2) {
        /// 第三行 帮助与反馈
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCHelpFadebackViewController" animated:YES];
    }
    if (indexPath.row == _array.count - 1) {
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCSettingViewController" animated:YES];
    }
}

- (IBAction)headerIconClick:(id)sender {
//    UCLoginViewController *loginvc = (UCLoginViewController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCLoginViewController"];
//    loginvc.canBack = YES;
//    [self.navigationController pushViewController:loginvc animated:YES];
}


- (void)headerButtonCick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName
                                            controllerId:@"UCMyQuestionViewController"
                                                animated:YES];
        }
            break;
        case 1:{
            NSLog(@"收藏");
        }
            break;
        case 2:{
            [self lgPushViewControllerWithClassName:@"UCUploadHomePageViewController"];
        }
            break;
        case 3:{
            [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCMsgTableViewController" animated:YES];
        }
            break;
    }
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
