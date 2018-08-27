//
//  UCMsgTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMsgTableViewController.h"
#import "UCMsgTableViewCell.h"
#import "UCMsgEditTableViewCell.h"
#import "UCMsgModel.h"
#import "LGSegmentBottomView.h"

@interface UCMsgTableViewController ()<
LGSegmentBottomViewDelegate,
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) UITableView *msgListView;
@property (strong,nonatomic) LGSegmentBottomView *allSelectView;
@property (strong,nonatomic) NSMutableArray *array;
/** 是否编辑状态 */
@property (assign,nonatomic) BOOL edit;

@end

@implementation UCMsgTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.msgListView];
    _allSelectView = [LGSegmentBottomView segmentBottom];
    _allSelectView.delegate = self;
    [self.view addSubview:_allSelectView];
    
    [self.msgListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [_allSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo([LGSegmentBottomView bottomHeight]);
    }];
    _allSelectView.hidden = YES;
    
    // 添加删除按钮
    UIButton *dbtn = UIButton.new;
    [dbtn setImage:[UIImage imageNamed:@"home_icon_remove"] forState:UIControlStateNormal];
    [dbtn addTarget:self action:@selector(removeMsg:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [UIBarButtonItem.alloc initWithCustomView:dbtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _array = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 20; i++) {
        UCMsgModel *model = [UCMsgModel new];
        model.content = @"科目渡无人科目渡无人科目渡无人科目渡无人科目渡无人科目渡无人科目渡无人科目渡无人科目渡无人";
        model.isEdit = NO;
        [_array addObject:model];
    }
    [self.msgListView reloadData];
}

- (void)setEdit:(BOOL)edit{
    _edit = edit;
    if (edit) {
        [self.msgListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-[LGSegmentBottomView bottomHeight]);
        }];
        _allSelectView.hidden = NO;
    }else{
        [self.msgListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        _allSelectView.hidden = YES;
    }
}

#pragma mark - target
- (void)removeMsg:(UIButton *)sender{
    self.edit = !_edit;
    for (UCMsgModel *model in self.array) {
        model.isEdit = self.edit;
    }
    [self.msgListView reloadData];
}

#pragma mark - LGSegmentBottomViewDelegate
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
    NSLog(@"全选: ");
    
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
    NSLog(@"全选删除: ");
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCMsgModel *model = _array[indexPath.row];
    UCMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCMsgTableViewCell cellReuseIdWithModel:model]];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.edit) {
        UCMsgModel *model = _array[indexPath.row];
        if (model.select) {
            model.select = NO;
        }else{
            model.select = YES;
        }
        [self.msgListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (UITableView *)msgListView{
    if (!_msgListView) {
        _msgListView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain];
        _msgListView.dataSource = self;
        _msgListView.delegate = self;
        _msgListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_msgListView registerNib:[UINib nibWithNibName:msgCell bundle:nil] forCellReuseIdentifier:msgCell];
        [_msgListView registerNib:[UINib nibWithNibName:msgEditCell bundle:nil] forCellReuseIdentifier:msgEditCell];
        _msgListView.estimatedRowHeight = 1.0;
        
        _msgListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_msgListView.mj_header endRefreshing];
            });
        }];
        
        _msgListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_msgListView.mj_footer endRefreshing];
            });
        }];
        
    }
    return _msgListView;
}

@end
