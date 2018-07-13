//
//  HPMicrolessonViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPMicrolessonViewController.h"

#import "EDJMicroPartyLessonHeaderCell.h"
#import "EDJMicroPartyLessonCell.h"
#import "EDJMicroLessionAlbumModel.h"

#import "LTScrollView-Swift.h"
#import "LGDidSelectedNotification.h"

static NSString * const microCell = @"EDJMicroPartyLessonCell";
static NSString * const microHeaderCell = @"EDJMicroPartyLessonHeaderCell";

@interface HPMicrolessonViewController ()<
UITableViewDelegate,
UITableViewDataSource,
EDJMicroPartyLessonHeaderCellDelegate>
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation HPMicrolessonViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //    if (@available(iOS 11.0, *)) {
    //        self.tableView.contentInsetAdjustmentBehavior = NO;
    //    } else {
    //        // Fallback on earlier versions
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
    [self.view addSubview:self.tableView];
    self.glt_scrollView = self.tableView;
    
    [self.tableView registerClass:[EDJMicroPartyLessonCell class] forCellReuseIdentifier:microCell];
    [self.tableView registerNib:[UINib nibWithNibName:microHeaderCell bundle:nil] forCellReuseIdentifier:microHeaderCell];
}

- (void)setDataArray:(NSArray *)dataArray{
    
    EDJMicroLessionAlbumModel *headerModel = [EDJMicroLessionAlbumModel new];
    
    /// 精品课程单独处理
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0;i < dataArray.count;i++) {
        EDJMicroLessionAlbumModel *model = dataArray[i];
        if (model.sort == 1) {
            [array addObject:model];
        }
    }
    if (array.count > 1) {
        if (headerModel.headerModel1 == nil) {
            headerModel.headerModel1 = array[0];
        }
        if (headerModel.headerModel2 == nil) {
            headerModel.headerModel2 = array[1];
        }        
    }
    
    NSMutableArray *arrayMutable = [NSMutableArray arrayWithArray:dataArray];
    [arrayMutable insertObject:headerModel atIndex:0];
    _dataArray = arrayMutable.copy;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroLessionAlbumModel *model = self.dataArray[indexPath.row];
    EDJMicroPartyLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:[EDJMicroPartyLessonCell cellIdentifierWithIndexPath:indexPath]];
    if ([cell isMemberOfClass:[EDJMicroPartyLessonHeaderCell class]]) {
        EDJMicroPartyLessonHeaderCell *headerCell = (EDJMicroPartyLessonHeaderCell *)cell;
        headerCell.delegate = self;
    }
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroPartyLessonCell cellHeightWithIndexPath:indexPath];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroLessionAlbumModel *model = nil;
    if (indexPath.row == 0) {
        /// 头部专辑 单独处理
    }else{
        model = self.dataArray[indexPath.row];
        [self sendNotificationWithModel:model];
    }
}
#pragma mark - EDJMicroPartyLessonHeaderCellDelegate
/// 点击头部专辑
- (void)headerAlbumClick:(EDJMicroPartyLessonHeaderCell *)header index:(NSInteger)index{
    EDJMicroLessionAlbumModel *headerModel = self.dataArray[0];
    EDJMicroLessionAlbumModel *destinyModel = nil;
    if (index == 0) {
        destinyModel = headerModel.headerModel1;
    }
    if (index == 1) {
        destinyModel = headerModel.headerModel2;
    }
    [self sendNotificationWithModel:destinyModel];
}

- (void)sendNotificationWithModel:(EDJMicroLessionAlbumModel *)model{
    if (model) {
        NSDictionary *dict = @{LGDidSelectedModelKey:model,
                               LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeMicrolessonAlbum)
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
    }else{
        [self presentFailureTips:@"精品专辑数据异常"];
    }
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - kTabBarHeight - kNavHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
