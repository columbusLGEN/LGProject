//
//  HPMicrolessonViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPMicrolessonViewController.h"
#import "EDJMicroPartyLessonCell.h"
#import "EDJMicroLessionAlbumModel.h"

#import "LGDidSelectedNotification.h"
#import "LTScrollView-Swift.h"

static NSString * const microCell = @"EDJMicroPartyLessonCell";
static NSString * const microHeaderCell = @"EDJMicroPartyLessonHeaderCell";

@interface HPMicrolessonViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation HPMicrolessonViewController

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    NSLog(@"微党课刷新数据: ");
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroLessionAlbumModel *model = self.dataArray[indexPath.row];
    EDJMicroPartyLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:[EDJMicroPartyLessonCell cellIdentifierWithIndexPath:indexPath]];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroPartyLessonCell cellHeightWithIndexPath:indexPath];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroLessionAlbumModel *model = nil;
    NSLog(@"进入党课列表:");
    if (indexPath.row == 0) {
        NSLog(@"头部专辑 -- ");
        /// TODO: 如何从头部2选1？
        
    }else{
        NSLog(@"其他专辑 -- ");
        model = self.dataArray[indexPath.row];
    }
    NSDictionary *dict = @{LGDidSelectedModelKey:model?model:[NSObject new],
                           LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeMicrolessonAlbum)
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
}

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
