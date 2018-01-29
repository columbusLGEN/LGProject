//
//  ECRInputBookViewController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRInputBookViewController.h"
#import "ECRInputBookTableViewCell.h"
#import "ECRBRLoadLocalBookModel.h"

@interface ECRInputBookViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong,nonatomic) UITableView *tableView;//

@end

@implementation ECRInputBookViewController

- (void)textDependsLauguage{
    self.title = LOCALIZATION(@"导入图书");
}

- (void)setArray:(NSArray *)array{
    _array = array;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECRInputBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ECRInputBookTableViewCell cellID]];
    ECRBRLoadLocalBookModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 345;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        CGRect rect = CGRectMake(0, 0, Screen_Width, Screen_Height - 64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:[ECRInputBookTableViewCell cellID] bundle:nil] forCellReuseIdentifier:[ECRInputBookTableViewCell cellID]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
