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

#import "DJLessonDetailViewController.h"

#import "HPPartyBuildDetailViewController.h"

@interface HPAlbumTableViewController ()<
HPAlbumHeaderCellDelegate>

@property (strong,nonatomic) HPAlbumHeaderCell *header;
/// 切换数据排序方式,0时间正序，1时间倒序
@property (assign,nonatomic) BOOL timeSort;

@property (strong,nonatomic) LGLoadingAssit *loadAssit;

@property (assign,nonatomic) NSInteger offset;

@end

@implementation HPAlbumTableViewController

- (void)setPush_seqid:(NSInteger)push_seqid{
    _push_seqid = push_seqid;
    
    EDJMicroLessionAlbumModel *albModel = EDJMicroLessionAlbumModel.new;
    albModel.classid = push_seqid;
    self.albumModel = albModel;
    
    /// MARK: 请求 封面 & 简介
    [DJHomeNetworkManager.sharedInstance carouselfigure_selectCurriculumDetailWithClassid:push_seqid success:^(id responseObj) {
        
        self.albumModel = [EDJMicroLessionAlbumModel mj_objectWithKeyValues:responseObj];
        self.albumModel.classid = push_seqid;
        
        [self headerSetWithAlbumModel:self.albumModel];
        
    } failure:^(id failureObj) {
        
    }];
    
    _offset = 0;
    /// 请求列表
    [self requestNetDataWithOffset:_offset];
    
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
            }else{
                [self.tableView.mj_header endRefreshing];
            }
            
            for (int i = 0; i < array.count; i++) {
                DJDataBaseModel *model = [DJDataBaseModel mj_objectWithKeyValues:array[i]];
                [arrm addObject:model];
            }
            
            /// 配置header模型
            [self headerSetWithAlbumModel:strongSelf.albumModel];
            
            _offset = arrm.count;
            strongSelf.dataArray = arrm.copy;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [strongSelf.tableView reloadData];
            }];
            
        } failure:^(id failureObj) {
            [normalHUD hideAnimated:YES];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            
            if ([failureObj isKindOfClass:[NSString class]]) {
                [strongSelf.view presentFailureTips:failureObj];
            }
        }];
    }];
}

/// MARK: 配置 header
- (void)headerSetWithAlbumModel:(EDJMicroLessionAlbumModel *)albumModel{
    DJDataBaseModel *headerModel = [DJDataBaseModel new];
    headerModel.cover = albumModel.classimg;
    headerModel.classdescription = albumModel.classdescription;
    _header.model = headerModel;
    _header.frame = CGRectMake(0, 0, kScreenWidth, [_header headerHeight]);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerNib:[UINib nibWithNibName:albumListHeaderCell bundle:nil] forCellReuseIdentifier:albumListHeaderCell];
    [self.tableView registerNib:[UINib nibWithNibName:microPartyLessonSubCell bundle:nil] forCellReuseIdentifier:microPartyLessonSubCell];
    self.tableView.rowHeight = homeMicroLessonSubCellBaseHeight * rateForMicroLessonCellHeight();
    
    HPAlbumHeaderCell *header =  [[[NSBundle mainBundle] loadNibNamed:albumListHeaderCell owner:nil options:nil] lastObject];
    _header = header;
    header.delegate = self;
    self.tableView.tableHeaderView = header;
    
    self.timeSort = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self requestNetDataWithOffset:_offset];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoad)];
    
    [self.tableView.mj_header beginRefreshing];
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
    EDJMicroPartyLessonSubCell *cell = [tableView dequeueReusableCellWithIdentifier:microPartyLessonSubCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 进入课程详情页面
    DJDataBaseModel *lesson = self.dataArray[indexPath.row];
    lesson.playcount += 1;
    // TODO: Zup_根据不同类型的数据跳转不同的界面
    if (lesson.modaltype == ModelMediaTypeRichText || lesson.modaltype == ModelMediaTypeCustom) {
        [HPPartyBuildDetailViewController buildVcPushWith:lesson baseVc:self dataSyncer:nil];
        //    [[DJMediaDetailTransAssist new] mediaDetailWithModel:lesson baseVc:self dataSyncer:nil];
    } else {
        [DJLessonDetailViewController lessonvcPushWithLesson:lesson baseVc:self dataSyncer:nil sort:self.timeSort];
        
    }
}

#pragma mark - HPAlbumHeaderCellDelegate
- (void)albumListHeaderTimeSort{
    if (self.timeSort) {
        self.timeSort = NO;
    }else{
        self.timeSort = YES;
    }
    /// 重置数据
    [self.tableView.mj_header beginRefreshing];
}
- (void)albumListHeaderReCalHeight{
    _header.frame = CGRectMake(0, 0, kScreenWidth, [_header headerHeight]);
    [self.tableView reloadData];
}

- (LGLoadingAssit *)loadAssit{
    if (!_loadAssit) {
        _loadAssit = [LGLoadingAssit new];
    }
    return _loadAssit;
}

@end
