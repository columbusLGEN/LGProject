//
//  HPAlbumTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAlbumTableViewController.h"

#import "DJDataBaseModel.h"
#import "EDJMicroLessionAlbumModel.h"

#import "HPAlbumHeaderCell.h"
#import "EDJMicroPartyLessonSubCell.h"

#import "HPAudioVideoViewController.h"

@interface HPAlbumTableViewController ()<
HPAlbumHeaderCellDelegate>

/// 切换数据排序方式
@property (assign,nonatomic) BOOL timeSort;

@property (strong,nonatomic) LGLoadingAssit *loadAssit;

@property (assign,nonatomic) NSInteger offset;

@end

@implementation HPAlbumTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:albumListHeaderCell bundle:nil] forCellReuseIdentifier:albumListHeaderCell];
    [self.tableView registerNib:[UINib nibWithNibName:microPartyLessonSubCell bundle:nil] forCellReuseIdentifier:microPartyLessonSubCell];
    self.tableView.estimatedRowHeight = 90;
    
    self.timeSort = YES;
    
    _offset = 0;
    
    [self requestNetDataWithOffset:_offset];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoad)];
}

- (void)requestNetDataWithOffset:(NSInteger)offset{
    __weak typeof(self) weakSelf = self;
    
    [self.loadAssit normalShowHUDTo:self.view HUDBlock:^(MBProgressHUD *normalHUD) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [[DJHomeNetworkManager sharedInstance] homeAlbumListWithClassid:strongSelf.albumModel.classid offset:offset length:10 sort:strongSelf.timeSort success:^(id responseObj) {
            
            [normalHUD hideAnimated:YES];
            
            NSArray *array = responseObj;
            
            NSMutableArray *arrm;
            if (offset == 0) {
                arrm  = [NSMutableArray array];
            }else{
                arrm = [NSMutableArray arrayWithArray:strongSelf.dataArray];
            }
            
            if (offset != 0) {
                /// 上拉刷新
                if (array.count == 0 || array == nil) {
                    /// 没有更多数据
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            
            for (int i = 0; i < array.count; i++) {
                DJDataBaseModel *model = [DJDataBaseModel mj_objectWithKeyValues:array[i]];
                [arrm addObject:model];
            }
            /// 配置header 数据
            DJDataBaseModel *headerModel = [DJDataBaseModel new];
            headerModel.cover = strongSelf.albumModel.classimg;
            headerModel.classdescription = strongSelf.albumModel.classdescription;
            [arrm insertObject:headerModel atIndex:0];
            
            _offset = arrm.count;
            strongSelf.dataArray = arrm.copy;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [strongSelf.tableView reloadData];
            }];
            
        } failure:^(id failureObj) {
            [normalHUD hideAnimated:YES];
            [self.tableView.mj_footer endRefreshing];
            
            if ([failureObj isKindOfClass:[NSString class]]) {
                [strongSelf.view presentFailureTips:failureObj];
            }
        }];
    }];
}

- (void)footerLoad{
    [self requestNetDataWithOffset:_offset];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJDataBaseModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        HPAlbumHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:albumListHeaderCell];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
    EDJMicroPartyLessonSubCell *cell = [tableView dequeueReusableCellWithIdentifier:microPartyLessonSubCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 进入课程详情
    DJDataBaseModel *lesson = self.dataArray[indexPath.row];
//    HPAudioVideoViewController *avc = [HPAudioVideoViewController new];
//    [avc avcPushWithLesson:lesson baseVc:self];
    [HPAudioVideoViewController avcPushWithLesson:lesson baseVc:self];
}

#pragma mark - HPAlbumHeaderCellDelegate
- (void)albumListHeaderTimeSort{
    if (self.timeSort) {
        self.timeSort = NO;
    }else{
        self.timeSort = YES;
    }
    /// 重置数据
    [self requestNetDataWithOffset:0];
}

- (LGLoadingAssit *)loadAssit{
    if (!_loadAssit) {
        _loadAssit = [LGLoadingAssit new];
    }
    return _loadAssit;
}

@end
