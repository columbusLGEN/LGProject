//
//  HPBookInfoViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoViewController.h"

#import "HPBookInfoBaseCell.h"
#import "HPBookInfoHeaderCell.h"
#import "HPBookInfoBriefCell.h"

#import "EDJDigitalModel.h"
#import "HPBookInfoModel.h"
// 本地资源文件管理者
#import "LGLocalFileProducer.h"
#import "LGBookReaderManager.h"


@interface HPBookInfoViewController ()<
UITableViewDelegate,
UITableViewDataSource,
HPBookInfoBriefCellDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIButton *button;
@property (strong,nonatomic) NSArray *array;

@end

@implementation HPBookInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)setModel:(EDJDigitalModel *)model{
    _model = model;
    
    NSMutableArray *arrMu = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        HPBookInfoModel *lineModel = [HPBookInfoModel new];
        lineModel.isHeader = !i;
//        NSLog(@"isheader: %d",lineModel.isHeader);
        if (i == 0) {
            lineModel.coverUrl = model.cover;
            lineModel.bookName = model.ebookname;
            lineModel.author = model.author;
            lineModel.press = model.publisher;
            lineModel.testPressTime = [NSString stringWithFormat:@"出版时间: %@",model.pubdate];
            lineModel.testProgress = model.progressForUI;
        }
        
        
        if (i == 1) {
            lineModel.itemTitle = @"简介";
            lineModel.content = model.introduction;
        }
        if (i == 2) {
            lineModel.itemTitle = @"目录";
            lineModel.content = model.catalog;
        }
        
        [arrMu addObject:lineModel];
    }
    _array = arrMu.copy;
    [self.tableView reloadData];

    /// 如果需要，请详情接口获取数据
//    [DJHomeNetworkManager homeDigitalDetailWithId:model.seqid success:^(id responseObj) {
//        NSLog(@"homeDigitalDetailWithId -- %@",responseObj);
//        EDJDigitalModel *model = [EDJDigitalModel mj_objectWithKeyValues:responseObj];
//
//    } failure:^(id failureObj) {
//
//    }];
}

- (void)closeReaderNotification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *progress = userInfo[LGCloseReaderProgressKey];
    self.model.progress = progress.floatValue;
    HPBookInfoModel *lineModel = self.array[0];
    lineModel.testProgress = self.model.progressForUI;
    [self.tableView reloadData];
//    NSLog(@"self.model.progressForUI: %@",self.model.progressForUI);
}

- (void)readBook{
    [LGLocalFileProducer openBookWithModel:self.model vc:self];
    [DJHomeNetworkManager.sharedInstance frontIntegralGrade_addReportInformationWithTaskid:32 completenum:@"1" success:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
}

#pragma mark - HPBookInfoBriefCellDelegate
- (void)bibCellShowAllButtonClick:(HPBookInfoBriefCell *)cell{
    [self.tableView reloadData];
}

#pragma mark - data source & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPBookInfoModel *model = _array[indexPath.row];
    if (indexPath.row == 0) {
        HPBookInfoHeaderCell *cell = [HPBookInfoHeaderCell bookInInfoHeaderCell];
        cell.model = model;
        return cell;
    }
//    HPBookInfoBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[HPBookInfoBaseCell cellReuseIdWithModel:model]];
//    cell.model = model;
    HPBookInfoBriefCell *cell = [HPBookInfoBriefCell bookinfoBreifCell];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPBookInfoModel *model = _array[indexPath.row];
    return [HPBookInfoBaseCell cellHeightWithModel:model];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeReaderNotification:) name:LGCloseReaderNotification object:nil];
    
}

#pragma mark - getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:bookinfoHeaderCell bundle:nil] forCellReuseIdentifier:bookinfoHeaderCell];
        [_tableView registerNib:[UINib nibWithNibName:bookinfoBriefCell bundle:nil] forCellReuseIdentifier:bookinfoBriefCell];
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
        [_button addTarget:self action:@selector(readBook) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc{
    [LGLocalFileProducer cancelDownloadAll];
    
    [self IntegralGrade_addWithIntegralid:DJUserAddScoreTypeReadBook];
}

@end
