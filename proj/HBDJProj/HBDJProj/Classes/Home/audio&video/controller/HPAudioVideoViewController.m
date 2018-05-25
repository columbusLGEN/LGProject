//
//  HPAudioVideoViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 第一个cell：播放器
/// 第二个cell：内容简介，可以展开 收起
/// 第三个cell：有可能是 图文混排 cell, 可以参考 DCSubPartStateDetailViewController
///            也有可能是纯文本

/// 暂时先按照纯文本 cell 处理

#import "HPAudioVideoViewController.h"
#import "LGThreeRightButtonView.h"
#import "HPAudioVideoContentCell.h"
#import "HPAudioVideoModel.h"
#import "HPAudioVideoInfoCell.h"
#import "HPAudioPlayerView.h"
#import "HPVideoPlayerView.h"

static CGFloat videoInsets = 233;
static CGFloat audioInsets = 296;

@interface HPAudioVideoViewController ()<
UITableViewDelegate,
UITableViewDataSource,
HPAudioVideoInfoCellDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *array;

@end

@implementation HPAudioVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
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
                                 },
                               @{TRConfigTitleKey:@"",
                                 TRConfigImgNameKey:@"uc_icon_fenxiang_gray",
                                 TRConfigSelectedImgNameKey:@"uc_icon_fenxiang_green",
                                 TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                 TRConfigTitleColorSelectedKey:[UIColor EDJColor_8BCA32]
                                 }]];
    
    [self.view addSubview:pbdBottom];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i++) {
        HPAudioVideoModel *model = [HPAudioVideoModel new];
        model.isopen = NO;
        [arr addObject:model];
    }
    self.array = arr.copy;
    [self.tableView reloadData];
    
    if (self.contentType == HPAudioVideoTypeVideo) {
        /// MARK: 视频播放器
        HPVideoPlayerView *vpv = [HPVideoPlayerView videoPlayerView];
        vpv.frame = CGRectMake(0, kNavHeight, kScreenWidth, videoInsets);
        [self.view addSubview:vpv];
    }else{
        /// MARK: 音频播放器
        HPAudioPlayerView *apv = [HPAudioPlayerView audioPlayerView];
        apv.frame = CGRectMake(0, kNavHeight, kScreenWidth, audioInsets);
        [self.view addSubview:apv];
    }
    
}

#pragma mark - LGThreeRightButtonViewDelegate

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HPAudioVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:avInfoCell];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == _array.count - 1) {
        HPAudioVideoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:avContentCell];
        return cell;
    }
    return nil;
}
#pragma mark - HPAudioVideoInfoCellDelegate
- (void)avInfoCellOpen:(HPAudioVideoInfoCell *)cell isOpen:(BOOL)isOpen{
    [self.tableView reloadData];
    if (!isOpen) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:avContentCell bundle:nil] forCellReuseIdentifier:avContentCell];
        [_tableView registerNib:[UINib nibWithNibName:avInfoCell bundle:nil] forCellReuseIdentifier:avInfoCell];
        if (self.contentType == HPAudioVideoTypeVideo) {
            /// 视频
            _tableView.contentInset = UIEdgeInsetsMake(videoInsets, 0, 0, 0);
        }else{
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
@end
