//
//  DJLessonDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJLessonDetailViewController.h"

#import "HPAudioPlayerView.h"
#import "HPVideoContainerView.h"
#import "LGVideoInterfaceView.h"
#import "LGThreeRightButtonView.h"

#import "HPAudioVideoInfoCell.h"
/// 课程文稿cell
#import "DJLessonAVTextTableViewCell.h"

#import "HPAudioVideoModel.h"
#import "EDJHomeImageLoopModel.h"

#import "LGPlayer.h"
#import "DJUserInteractionMgr.h"
#import "HPAddBroseCountMgr.h"

static CGFloat videoInsets = 233;
static CGFloat audioInsets = 296;

@interface DJLessonDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
HPAudioVideoInfoCellDelegate,
LGVideoInterfaceViewDelegate,
LGThreeRightButtonViewDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *array;

@property (weak,nonatomic) LGThreeRightButtonView *pbdBottom;
@property (weak,nonatomic) HPVideoContainerView *vpv;
@property (weak,nonatomic) HPAudioPlayerView *apv;

@property (strong,nonatomic) NSURLSessionTask *task;

@end

@implementation DJLessonDetailViewController

/// TODO: 播放之后 调 添加播放接口 homeAddcountWithId

/// MARK: 进入微党课详情页面
+ (void)lessonvcPushWithLesson:(DJDataBaseModel *)lesson baseVc:(UIViewController *)baseVc{
    /// 在经过 DJMediaDetailTransAssist 实例分发数据之后，这里只有 音视频模板类型的数据,if条件可以省略
    if (lesson.modaltype == ModelMediaTypeCustom || lesson.modaltype == ModelMediaTypeRichText) {
        [baseVc presentFailureTips:@"数据异常"];
    }else{
        /// 如果跳转来自 图片轮播器，那么 需要 EDJHomeImageLoopModel 的frontnews
        DJLessonDetailViewController *avc = [self new];
        if ([lesson isMemberOfClass:[EDJHomeImageLoopModel class]]) {
            EDJHomeImageLoopModel *imgLoopModel = (EDJHomeImageLoopModel *)lesson;
            avc.model = imgLoopModel.frontNews;
        }else{
            avc.model = lesson;
        }
        avc.lessonMediaType = lesson.modaltype;
        [baseVc.navigationController pushViewController:avc animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    NSLog(@"新版微党课音视频控制器 : ");
}
- (void)configUI{
    
    CGFloat bottomHeight = 60;
    BOOL isiPhoneX = ([LGDevice sharedInstance].currentDeviceType == LGDeviecType_iPhoneX);
    if (isiPhoneX) {
        bottomHeight = 90;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottomHeight);
    }];
    
    /// bottom
    LGThreeRightButtonView *pbdBottom = [[LGThreeRightButtonView alloc] initWithFrame:CGRectMake(0, kScreenHeight - bottomHeight, kScreenWidth, bottomHeight)];
    pbdBottom.delegate = self;
    _pbdBottom = pbdBottom;
    [pbdBottom setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                 TRConfigImgNameKey:@"dc_like_normal",
                                 TRConfigSelectedImgNameKey:@"dc_like_selected",
                                 TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                 TRConfigTitleColorSelectedKey:[UIColor EDJColor_6CBEFC]
                                 },
                               @{TRConfigTitleKey:@"99+",
                                 TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                 TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                 TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                 TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                 }]];
    //    ,
    //    @{TRConfigTitleKey:@"",
    //      TRConfigImgNameKey:@"uc_icon_fenxiang_gray",
    //      TRConfigSelectedImgNameKey:@"uc_icon_fenxiang_green",
    //      TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
    //      TRConfigTitleColorSelectedKey:[UIColor EDJColor_8BCA32]
    //      }
    NSInteger praiseid = 0;
    NSInteger collectionid = 0;
    
    NSInteger likeCount = 0;
    NSInteger collectionCount = 0;

    if (self.model) {
        praiseid = self.model.praiseid;
        collectionid = self.model.collectionid;
        likeCount = self.model.praisecount;
        collectionCount = self.model.collectioncount;
    }
    
    pbdBottom.leftIsSelected = !(praiseid <= 0);
    pbdBottom.middleIsSelected = !(collectionid <= 0);
    pbdBottom.likeCount = likeCount;
    pbdBottom.collectionCount = collectionCount;
    
    [self.view addSubview:pbdBottom];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i++) {
        HPAudioVideoModel *model = [HPAudioVideoModel new];
        model.isopen = NO;
        [arr addObject:model];
    }
    self.array = arr.copy;
    [self.tableView reloadData];
    
    if (self.lessonMediaType == ModelMediaTypeVideo) {
        /// MARK: 视频播放器
        HPVideoContainerView *vpv = [[HPVideoContainerView alloc] init];
        vpv.lessonDetailVc = self;
        vpv.frame = CGRectMake(0, kNavHeight, kScreenWidth, videoInsets);
        [self.view addSubview:vpv];
        vpv.model = self.model;
        _vpv = vpv;
    }else if (self.lessonMediaType == ModelMediaTypeAudio){
        /// MARK: 音频播放器
        HPAudioPlayerView *apv = [HPAudioPlayerView audioPlayerView];
        apv.lessonDetailVc = self;
        apv.frame = CGRectMake(0, kNavHeight, kScreenWidth, audioInsets);
        [self.view addSubview:apv];
        apv.model = self.model;
        _apv = apv;
    }else{
        /// 其他
    }
    [[HPAddBroseCountMgr new] addBroseCountWithId:self.model.seqid success:^{
        self.model.playcount += 1;
        [self.tableView reloadData];
    }];
    
}

#pragma mark - LGThreeRightButtonViewDelegate
- (void)leftClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 点赞
    [self likeCollectWithClickSuccess:success collect:NO];
}
- (void)middleClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 收藏
    [self likeCollectWithClickSuccess:success collect:YES];
}
- (void)rightClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 分享
    
}

- (void)likeCollectWithClickSuccess:(ClickRequestSuccess)clickSuccess collect:(BOOL)collect{
    DJDataBaseModel *model = self.model;
    _task = [[DJUserInteractionMgr sharedInstance] likeCollectWithModel:model collect:collect type:DJDataPraisetypeMicrolesson success:^(NSInteger cbkid, NSInteger cbkCount) {
        if (clickSuccess) clickSuccess(cbkid,cbkCount);
    } failure:^(id failureObj) {
        NSLog(@"点赞收藏失败: ");
    }];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HPAudioVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:avInfoCell];
        cell.model = self.model;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == _array.count - 1) {
        /// 返回课程文稿cell （图文混排）
        DJLessonAVTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lessonAVTextCell];
        cell.model = self.model;
        
        return cell;
    }
    return nil;
}
#pragma mark - HPAudioVideoInfoCellDelegate
- (void)avInfoCellOpen:(HPAudioVideoInfoCell *)cell isOpen:(BOOL)isOpen{
    /// 课程信息的展开与收起
    [self.tableView reloadData];
    if (!isOpen) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
}
#pragma mark - LGVideoInterfaceViewDelegate
//- (void)userDragProgress:(LGVideoInterfaceView *)videoInterfaceView value:(float)value{
//    NSLog(@"用户拖动进度value -- %f",value);
//
//}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        [_tableView registerNib:[UINib nibWithNibName:avContentCell bundle:nil] forCellReuseIdentifier:avContentCell];
        /// 注册课程文稿cell
        [_tableView registerClass:[DJLessonAVTextTableViewCell class] forCellReuseIdentifier:lessonAVTextCell];
        
        [_tableView registerNib:[UINib nibWithNibName:avInfoCell bundle:nil] forCellReuseIdentifier:avInfoCell];
        if (self.lessonMediaType == DJLessonMediaTypeVideo) {
            /// 视频
            _tableView.contentInset = UIEdgeInsetsMake(videoInsets, 0, 0, 0);
        }else if (self.lessonMediaType == DJLessonMediaTypeAudio) {
            /// 音频
            _tableView.contentInset = UIEdgeInsetsMake(audioInsets, 0, 0, 0);
        }
        
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc{
    [_task cancel];
    
    if (_opreated) {
        [_vpv stop];
        [_apv audioStop];
    }
}

@end
