//
//  UHelpVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserHelpVC.h"

#import "UserHelpTableViewCell.h"

@interface UserHelpVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *array; // 数据数组

@end

@implementation UserHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTablView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"使用帮助");
}

- (void)configTablView
{
    CGFloat navHeight = [IPhoneVersion deviceVersion] == iphoneX ? cHeaderHeight_88 : cHeaderHeight_64;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height - navHeight - 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserHelpTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserHelpTableViewCell class])];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = view;
    
    [self.view addSubview:_tableView];
}

#pragma mark - tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserHelpTableViewCell *helpCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserHelpTableViewCell class])];
    helpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    helpCell.data = _array[indexPath.row];
    return helpCell;
}

#pragma mark - 属性

- (NSArray *)array
{
    if (_array == nil) {
        _array = @[@{@"question": LOCALIZATION(@"1、如何找到自己喜欢的电子书？"),
                     @"response": LOCALIZATION(@"你可以在书城里挑选自己喜欢的书籍，也可以通过搜索找到您喜欢的书籍。")},
                   @{@"question": LOCALIZATION(@"2、如何批量购买？"),
                     @"response": LOCALIZATION(@"在您挑选书籍的时候，点击详情页中的“加入购物车”，挑选完成后统一到购物车结算即可。")},
                   @{@"question": LOCALIZATION(@"3、电子书有哪些支付方式？"),
                     @"response": LOCALIZATION(@"电子书是虚拟商品，仅支持在线支付的形式，不可以货到付款，支付方式包括：虚拟币支付、微信支付、支付宝支付、银行卡支付等。")},
                   @{@"question": LOCALIZATION(@"4、电子书订单支付完成后，如何进行下载？"),
                     @"response": LOCALIZATION(@"支付完成后，在订单中点击阅读进行图书下载。")},
                   @{@"question": LOCALIZATION(@"5、如何进行退货或换货？"),
                     @"response": LOCALIZATION(@"由于电子书为虚拟商品，不支持7天无理由退货。如果有任何疑问请联系客服解决。")},
                   @{@"question": LOCALIZATION(@"6、软件升级或重复安装后本地的书会不会被删除？"),
                     @"response": LOCALIZATION(@"只要不卸载应用，本地数据不会删除。")},
                   @{@"question": LOCALIZATION(@"7、电子书支持打印吗？"),
                     @"response": LOCALIZATION(@"不支持。出版社出于保护作者的著作权，不允许打印。")},
                   @{@"question": LOCALIZATION(@"8、用户可以复制书中文字或者下载电子书到其他设备上自由阅读吗？"),
                     @"response": LOCALIZATION(@"出版社为了保护作者的权利，只允许“复制”部分文字。电子书是加密的，“拷贝”到其他设备上，将无法正常阅读。")},
                   ];
    }
    return _array;
}

@end
