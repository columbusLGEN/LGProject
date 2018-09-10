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
#import "DJMsgCenterTranser.h"
#import "LGAlertControllerManager.h"

@interface UCMsgTableViewController ()<
LGSegmentBottomViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UCMsgTableViewCellDelegate>
@property (strong,nonatomic) UITableView *msgListView;
@property (strong,nonatomic) LGSegmentBottomView *allSelectView;
@property (strong,nonatomic) NSArray *array;
/** 是否编辑状态 */
@property (assign,nonatomic) BOOL edit;

@end

@implementation UCMsgTableViewController{
    NSInteger offset;
    NSMutableArray *selectArray;
    UIButton *_dbtn;
    DJMsgCenterTranser *transer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
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
    _dbtn = dbtn;
    [dbtn setTitle:@"取消" forState:UIControlStateSelected];
    [dbtn setImage:UIImage.new forState:UIControlStateSelected];
    [dbtn setTitleColor:UIColor.EDJGrayscale_11 forState:UIControlStateSelected];
    
    [dbtn addTarget:self action:@selector(removeMsg:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [UIBarButtonItem.alloc initWithCustomView:dbtn];
    self.navigationItem.rightBarButtonItem = rightButton;

    _array = @[];
    
    [self headerFooterSet];
    
    [self.msgListView.mj_header beginRefreshing];
    
    transer = DJMsgCenterTranser.new;
}

- (void)headerFooterSet{
    self.msgListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 0;
        [self.msgListView.mj_footer resetNoMoreData];
        [self getData];
    }];
    
    self.msgListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
}

- (void)getData{
    [DJUserNetworkManager.sharedInstance frontUserNotice_selectWithOffset:offset success:^(id responseObj) {
       
        if (offset == 0) {
            [self.msgListView.mj_header endRefreshing];
        }else{
            [self.msgListView.mj_footer endRefreshing];
        }
        
        
        NSArray *keyvalueArray = responseObj;
        if (keyvalueArray == nil || keyvalueArray.count == 0) {
            [self.msgListView.mj_footer endRefreshingWithNoMoreData];
            return;
        }else{
            
            NSMutableArray *arrmu;
            if (offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.array];
            }
            
            for (NSInteger i = 0; i < keyvalueArray.count; i++) {
                UCMsgModel *model = [UCMsgModel mj_objectWithKeyValues:keyvalueArray[i]];
                [arrmu addObject:model];
            }
            
            self.array = arrmu.copy;
            offset = self.array.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.msgListView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.msgListView.mj_header endRefreshing];
        [self.msgListView.mj_footer endRefreshing];
    }];
}

- (void)setEdit:(BOOL)edit{
    _edit = edit;
    if (edit) {
        /// 编辑状态
        [self.msgListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-[LGSegmentBottomView bottomHeight]);
        }];
        _allSelectView.hidden = NO;
        self.msgListView.mj_header = nil;
        self.msgListView.mj_footer = nil;
        for (UCMsgModel *model in self.array) {
            model.isEdit = _edit;
        }
        
    }else{
        /// 普通状态
        [self.msgListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        for (UCMsgModel *model in self.array) {
            model.select = NO;
            model.isEdit = _edit;
        }
        _allSelectView.hidden = YES;
        [self headerFooterSet];
    }
}

/// MARK: 删除按钮点击事件
- (void)removeMsg:(UIButton *)sender{
    if (!selectArray) {
        selectArray = NSMutableArray.new;
    }
    self.edit = !_edit;
    sender.selected = _edit;
    if (!_edit) {
        self.allSelectView.asbState = NO;
    }
    [self.msgListView reloadData];
}

#pragma mark - LGSegmentBottomViewDelegate
/// MARK: 全选按钮点击事件
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
    
    BOOL allAlreadySelect = YES;
    for (UCMsgModel *model in self.array) {
        if (!model.select) {
            allAlreadySelect = NO;
            break;
        }
    }
    
    BOOL select;
    if (allAlreadySelect) {
        select = NO;
    }else{
        select = YES;
    }
    
    for (UCMsgModel *model in self.array) {
        model.select = select;
    }
    [self.msgListView reloadData];
    
    if (select) {
        selectArray = [NSMutableArray arrayWithArray:self.array];
    }else{
        [selectArray removeAllObjects];
    }
    
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{

    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0; i < selectArray.count; i++) {
        UCMsgModel *model = selectArray[i];
        [arrmu addObject:@(model.seqid)];
    }
    NSString *seqid_s = [arrmu componentsJoinedByString:@","];
    
    /// 发送删除消息请求
//    NSLog(@"seqid_s: %@",seqid_s);
    
    if (seqid_s == nil || [seqid_s isEqualToString:@""]) {
        return;
    }
    
    UIAlertController *alertvc = [LGAlertControllerManager alertvcWithTitle:@"提示" message:@"您确定要删除这些内容吗" cancelText:@"取消" doneText:@"确定" cancelABlock:^(UIAlertAction * _Nonnull action) {
        
    } doneBlock:^(UIAlertAction * _Nonnull action) {
        [DJUserNetworkManager.sharedInstance frontUserNotice_deleteWithSeqids:seqid_s success:^(id responseObj) {
            /// 结束编辑，刷新视图
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.edit = NO;
                _dbtn.selected = NO;
                [self.msgListView.mj_header beginRefreshing];
            }];
        } failure:^(id failureObj) {
            [self presentFailureTips:op_failure_notice];
        }];
    }];
    
    [self presentViewController:alertvc animated:YES completion:nil];

    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCMsgModel *model = _array[indexPath.row];
    model.indexPath = indexPath;
    UCMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCMsgTableViewCell cellReuseIdWithModel:model]];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UCMsgModel *model = _array[indexPath.row];
    if (self.edit) {
        model.select = !model.select;
        if (model.select) {
            [selectArray addObject:model];
        }else{
            [selectArray removeObject:model];
        }
        
        /// 判定并修改 allSelectView的全选按钮的 选中状态
        if (selectArray.count == self.array.count) {
            self.allSelectView.asbState = YES;
        }else{
            self.allSelectView.asbState = NO;
        }
        
        [self.msgListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        if (!model.isread) {
            /// 发起修改用户 已读未读状态 请求
            [DJUserNetworkManager.sharedInstance frontUserNotice_updateWithId:model.seqid success:^(id responseObj) {
                model.isread = YES;
            } failure:^(id failureObj) {
                
            }];            
        }
        
        /// 消息跳转测试
//        model.noticetype = 7;// 在线测试
//        model.noticetype = 2;// 学习问答
//        model.noticetype = 3;// 支部动态
//        model.noticetype = 6;// 在线投票
//        model.noticetype = 0;// 自定义消息
//        model.noticetype = 1;/// 要闻
        
        /// MARK: 跳转详情
        [transer msgShowDetailVcWithModel:model nav:self.navigationController];
    }
}

#pragma mark - UCMsgTableViewCellDelegate
- (void)ucmsgCellShowAllWithIndexPath:(NSIndexPath *)indexPath{
    [self.msgListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
