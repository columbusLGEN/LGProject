//
//  DJSelectPeopleViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSelectPeopleViewController.h"
#import "DJSelectPeopleModel.h"
#import "DJSelectPeopleCell.h"

#import "DJOnlineUploadTableModel.h"

@interface DJSelectPeopleViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) UIButton *shadow;
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation DJSelectPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat shadowHeight = kScreenHeight / 4;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self.view addSubview:self.shadow];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.shadow.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(shadowHeight);
    }];

}

- (void)setAllPeople:(NSArray *)allPeople{
    _allPeople = allPeople;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allPeople.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DJSelectPeopleModel *model = self.allPeople[indexPath.row];
    DJSelectPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:selectPeopleCell];
    cell.repSpType = _spType;
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJSelectPeopleModel *model = self.allPeople[indexPath.row];
    
    if (_spType == DJSelectPeopleTypePresent) {
        /// 出席
        if (model.attend == DJMemeberAttendTypePresent) {
            model.attend = DJMemeberAttendTypeAbsent;
        }else{
            model.attend = DJMemeberAttendTypePresent;
        }
        model.select_present = (model.attend == DJMemeberAttendTypePresent);
        model.select_absent = !model.select_present;
    }else if(_spType == DJSelectPeopleTypeAbsent){
        /// 缺席
        if (model.attend == DJMemeberAttendTypeAbsent) {
            model.attend = DJMemeberAttendTypePresent;
        }else{
            model.attend = DJMemeberAttendTypeAbsent;
        }
        model.select_absent = (model.attend == DJMemeberAttendTypeAbsent);
        model.select_present = !model.select_absent;
    }else{
        /// 选择主持人
        for (DJSelectPeopleModel *other in self.allPeople) {
            if (other == model) {
                other.select_host = YES;
                self.model.content = other.name;
            }else{
                other.select_host = NO;
            }
        }
    }

}

#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DJSelectPeopleCell class] forCellReuseIdentifier:selectPeopleCell];
    }
    return _tableView;
}
- (UIButton *)shadow{
    if (!_shadow) {
        _shadow = UIButton.new;
        [_shadow addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadow;
}

- (void)lg_dismissViewController{
    /// 如果全员缺席，禁止用户返回
    BOOL allAbsent = YES;
    for (DJSelectPeopleModel *model in self.allPeople) {
        /// 只要有人出席，allAbsent赋值为NO
        if (model.select_present) {
            allAbsent = NO;
        }
    }
    // TODO: Zup_取消禁止全员缺席
//    if (allAbsent) {
//        [self presentFailureTips:@"禁止全员缺席"];
//        /// TODO: 改为系统弹窗
//        return;
//    }else{
        if ([self.delegate respondsToSelector:@selector(selectPeopleDone:model:spType:)]) {
            [self.delegate selectPeopleDone:self model:self.model spType:_spType];
        }
        [super lg_dismissViewController];
//    }
    
}

@end
