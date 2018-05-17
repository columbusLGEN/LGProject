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

@interface UCAccountHitViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong,nonatomic) NSArray *array;

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
    UCAccountHitModel *model = _array[indexPath.row];
    UCAccountHitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}

- (IBAction)ahClick:(id)sender {
    UCAccountHitSuccessView *sv = [[UCAccountHitSuccessView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:sv];
    [[UIApplication sharedApplication].keyWindow addSubview:sv];
}

@end
