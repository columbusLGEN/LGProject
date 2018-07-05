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

@interface DJSelectPeopleViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) UIButton *shadow;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *array;

@property (strong,nonatomic) NSMutableArray *selectPeople;

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
    
    NSMutableArray *arrMutable = NSMutableArray.new;
    for (int i = 0; i < 30; i++) {
        DJSelectPeopleModel *model = DJSelectPeopleModel.new;
        model.name = [@"雪碧" stringByAppendingFormat:@"_%d",i];
        [arrMutable addObject:model];
    }
    self.array = arrMutable.copy;
    [self.tableView reloadData];
    _selectPeople = NSMutableArray.new;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DJSelectPeopleModel *model = self.array[indexPath.row];
    DJSelectPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:selectPeopleCell];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJSelectPeopleModel *model = self.array[indexPath.row];
    model.select = !model.select;
    model.select?[_selectPeople addObject:model]:[_selectPeople removeObject:model];
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
    if ([self.delegate respondsToSelector:@selector(selectPeopleDone:peopleList:spType:)]) {
        [self.delegate selectPeopleDone:self peopleList:self.selectPeople.copy spType:_spType];
    }
    [super lg_dismissViewController];
}

@end
