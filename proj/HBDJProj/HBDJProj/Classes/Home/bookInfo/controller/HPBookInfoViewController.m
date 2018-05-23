//
//  HPBookInfoViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoViewController.h"
#import "HPBookInfoBaseCell.h"
#import "HPBookInfoModel.h"

static NSString * const bookInfoHeaderCell = @"HPBookInfoHeaderCell";
static NSString * const bookInfoBriefCell = @"HPBookInfoBriefCell";

@interface HPBookInfoViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *array;
@property (strong,nonatomic) UIButton *button;

@end

@implementation HPBookInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    self.title = @"图书详情";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.button];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.button.mas_top);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    NSMutableArray *arrMu = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        HPBookInfoModel *model = [HPBookInfoModel new];
        model.isHeader = !i;
        model.bookName = @"中国梦，我的梦";
        model.author = @"蔡国英";
        model.press = @"阳光出版社";
        model.testPressTime = @"出版时间：2015-07-07";
        model.testProgress = @"上次阅读进度：7%";
        
        if (i == 1) {
            model.itemTitle = @"简介";
            model.content = @"梦想，是一个国家和民族前进的灯塔。银川的四月，春意方浓。梦想，是一个国家和民族前进的灯塔。银川的四月，春意方浓。梦想，是一个国家和民族前进的灯塔。银川的四月，春意方浓。";
        }
        if (i == 2) {
            model.itemTitle = @"目录";
            model.content = @"第一章: 中国梦是人民的名\n第一章: 中国梦是人民的名\n第一章: 中国梦是人民的名\n第一章: 中国梦是人民的名\n";
        }
        
        [arrMu addObject:model];
    }
    _array = arrMu.copy;
    [self.tableView reloadData];
}

#pragma mark - data source & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPBookInfoModel *model = _array[indexPath.row];
    HPBookInfoBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[HPBookInfoBaseCell cellReuseIdWithModel:model]];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

#pragma mark - getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:bookInfoHeaderCell bundle:nil] forCellReuseIdentifier:bookInfoHeaderCell];
        [_tableView registerNib:[UINib nibWithNibName:bookInfoBriefCell bundle:nil] forCellReuseIdentifier:bookInfoBriefCell];
    }
    return _tableView;
}
- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton new];
        [_button setTitle:@"开始阅读" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:18];
        [_button setBackgroundColor:[UIColor EDJMainColor]];
    }
    return _button;
}


@end
