//
//  UCAccountHitViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCAccountHitViewController.h"
#import "UCAccountHitModel.h"
#import "UCAccountHitTableViewCell.h"
#import "UCAccountHitSuccessView.h"
#import "NSString+Extension.h"

@interface UCAccountHitViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UCAccountHitSuccessViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong,nonatomic) NSArray *array;

@property (strong,nonatomic) NSString *tel;
@property (strong,nonatomic) NSString *pwd;

@end

@implementation UCAccountHitViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_doneButton cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_doneButton.height / 2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    self.title = @"账号激活";
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton setBackgroundColor:[UIColor EDJMainColor]];
    
    _activationDict = [NSMutableDictionary new];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    self.array = [UCAccountHitModel loadLocalPlistWithPlistName:@"UCAccountHit"];
    [self.tableView reloadData];
    
}

#pragma mark - delegate & data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCAccountHitModel *model         = _array[indexPath.row];
    UCAccountHitTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.index  = indexPath;
    cell.vc     = self;
    cell.model  = model;
    return cell;
}

- (IBAction)ahClick:(id)sender {
    NSLog(@"self.actiondict: %@",self.activationDict);
    NSString *tel = self.activationDict[@"0"];
    NSString *oldPwd = self.activationDict[@"1"];
    NSString *pwd = self.activationDict[@"2"];
    NSString *pwd_confirm = self.activationDict[@"3"];
    
    /// TODO:
    
    /// 未输入时，取到的值 为nil
    BOOL canSendRequest = YES;
    if (tel == nil) {
        [self.view presentFailureTips:@"手机号不能为空"];
        canSendRequest = NO;
        return;
    }
    if (![tel isPhone]) {
        [self.view presentFailureTips:@"手机号格式不正确"];
        canSendRequest = NO;
        return;
    }
    if (oldPwd == nil) {
        [self.view presentFailureTips:@"初始密码不能为空"];
        canSendRequest = NO;
        return;
    }
    if (pwd == nil) {
        [self.view presentFailureTips:@"新密码不能为空"];
        canSendRequest = NO;
        return;
    }
    if (pwd_confirm == nil) {
        [self.view presentFailureTips:@"请再次输入新密码"];
        canSendRequest = NO;
        return;
    }
    if (![pwd isPwd]) {
        [self.view presentFailureTips:@"新密码为数字和大小写字母的任意组合，8-32位"];
        canSendRequest = NO;
        return;
    }
    
    if (![pwd isEqualToString:pwd_confirm]) {
        [self.view presentFailureTips:@"两次输入的密码不一致"];
        canSendRequest = NO;
        return;
    }
    
    /// 测试账号
    /**
     18768147661 -- qqqq1111
     18768147662
     18768147663
     18768147664
     18768147665
     18768147666
     18768147667
     18768147668
     18768147669
     */
    
    [self.view endEditing:YES];
    
    if (canSendRequest) {
        __weak typeof(self) weakSelf = self;
        [[DJUserNetworkManager sharedInstance] userActivationWithTel:tel oldPwd:oldPwd pwd:pwd success:^(id responseObj) {
            typeof(weakSelf) strongSelf = weakSelf;
            NSLog(@"activation: %@",responseObj);
            /**
             激活失败：
             服务端
             1.手机号未录入，请联系管理员
             2.初始密码错误
             3.网络异常
             */
            
            _tel = tel;
            _pwd = pwd;
            /// 写入登陆需要的数据
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UCAccountHitSuccessView *sv = [[UCAccountHitSuccessView alloc] initWithFrame:self.view.bounds];
                sv.delegate = strongSelf;
                //    [self.view addSubview:sv];
                [[UIApplication sharedApplication].keyWindow addSubview:sv];
            }];
        } failure:^(id failureObj) {
            if ([failureObj isKindOfClass:[NSError class]]) {
                NSLog(@"failure_error: %@",failureObj);
            }
            if ([failureObj isKindOfClass:[NSDictionary class]]) {
                NSLog(@"failure_dict: %@",failureObj);
                NSString *msg = failureObj[@"msg"];
                [self.view presentFailureTips:msg];
            }
        }];
    }

}

#pragma mark - UCAccountHitSuccessViewDelegate
- (void)removehsView{/// 移除激活成功提示的回调
    NSLog(@"跳转至登陆页面，并发起登陆请求:");
    [self.navigationController popViewControllerAnimated:YES];
    /// 通知代理（登陆控制器） 发起登陆请求
    if ([self.delegate respondsToSelector:@selector(ucanLoginWithTel:pwd:)]) {
        [self.delegate ucanLoginWithTel:_tel pwd:_pwd];
    }
}

@end
