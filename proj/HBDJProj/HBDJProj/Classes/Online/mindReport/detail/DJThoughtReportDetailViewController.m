//
//  DJThoughtReportDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoughtReportDetailViewController.h"
#import "DJThoutghtRepotListModel.h"
#import "DJThoughtReportDetailTableViewCell.h"
#import "DJThoughtReportDetailModel.h"

@interface DJThoughtReportDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) NSArray *array;
@property (weak,nonatomic) UITableView *tableView;

@end

@implementation DJThoughtReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self confiUI];
    
}

- (void)confiUI{
    UITableView *tbv = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tbv;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:trdHeaderCell bundle:nil] forCellReuseIdentifier:trdHeaderCell];
    [_tableView registerNib:[UINib nibWithNibName:trdTextCell bundle:nil] forCellReuseIdentifier:trdTextCell];
    [_tableView registerClass:[NSClassFromString(trdNineImageCell) class] forCellReuseIdentifier:trdNineImageCell];
    
    [self.view addSubview:_tableView];
    
}

- (void)setModel:(DJThoutghtRepotListModel *)model{
    _model = model;
    
//    self.title = model.title;
    
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0; i < 3; i++) {
        DJThoughtReportDetailModel *lineModel = DJThoughtReportDetailModel.new;
        lineModel.type = i;
        switch (i) {
            case 0:{
                lineModel.title = model.title;
                if (model.createdtime.length > length_timeString) {
                    lineModel.createdtime = [model.createdtime substringToIndex:(length_timeString + 1)];
                }else{
                    lineModel.createdtime = model.createdtime;
                }
                
                lineModel.uploader = model.uploader;
            }
                break;
            case 1:{
                lineModel.content = model.content;
            }
                break;
            case 2:{
                lineModel.fileurl = model.fileurl;
            }
                break;
        }
        [arrmu addObject:lineModel];
    }
    
    _array = arrmu.copy;
    
    [self.tableView reloadData];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DJThoughtReportDetailModel *model = self.array[indexPath.row];
    DJThoughtReportDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DJThoughtReportDetailTableViewCell cellReuseIdWithModel:model]];
    cell.model = model;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
