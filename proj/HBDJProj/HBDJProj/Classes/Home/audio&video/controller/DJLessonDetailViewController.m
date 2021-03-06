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
#import <DTCoreText/DTCoreText.h>
#import "PLPlayerView.h"
#import "UIAlertController+LGExtension.h"
#import "DJDataSyncer.h"

#import "PLPlayerView.h"
#import "LGAudioPlayerView.h"
#import "DJListPlayNoticeView.h"
#import "LGAlertControllerManager.h"

#import "DJWebDetailViewController.h"

@interface DJLessonDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
HPAudioVideoInfoCellDelegate,
LGVideoInterfaceViewDelegate,
LGThreeRightButtonViewDelegate,
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate,
HPVideoContainerViewDelegate,
DJMediaPlayDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *array;

@property (weak,nonatomic) LGThreeRightButtonView *pbdBottom;
@property (weak,nonatomic) HPVideoContainerView *vpv;
@property (weak,nonatomic) HPAudioPlayerView *apv;

@property (strong,nonatomic) NSURLSessionTask *task;

/** 缓存core text cell */
@property (strong,nonatomic) NSCache *cellCache;
/** 图片尺寸缓存 */
@property (nonatomic, strong) NSCache *imageSizeCache;

@end

@implementation DJLessonDetailViewController{
    NSArray *allLessonIds;
    /** 当前播放课程索引 */
    NSInteger currentPlayIndex;
    /** 列表播放 提示 */
    DJListPlayNoticeView *notice;
}

/// MARK: 进入微党课详情页面
+ (void)lessonvcPushWithLesson:(DJDataBaseModel *)lesson baseVc:(UIViewController *)baseVc dataSyncer:(DJDataSyncer *)dataSyncer sort:(NSInteger)sort{
    /// 在经过 DJMediaDetailTransAssist 实例分发数据之后，这里只有 音视频模板类型的数据,if条件可以省略
    // TODO: Zup_没有要求按照类型区分，暂时注释
    /*
    if (lesson.modaltype == ModelMediaTypeCustom || lesson.modaltype == ModelMediaTypeRichText) {
        [baseVc presentFailureTips:@"数据异常"];
    }else{
     */
        
//        NSLog(@"basevcclass: %@",[baseVc class]);
        
        /// 如果跳转来自 图片轮播器，那么 需要 EDJHomeImageLoopModel 的frontnews
        DJLessonDetailViewController *avc = [self new];
        avc.sort = sort;
        avc.dataSyncer = dataSyncer;
        if ([lesson isMemberOfClass:[EDJHomeImageLoopModel class]]) {
            EDJHomeImageLoopModel *imgLoopModel = (EDJHomeImageLoopModel *)lesson;
            avc.model = imgLoopModel.frontNews;
        }else{
            avc.model = lesson;
        }
        avc.lessonMediaType = lesson.modaltype;
        [baseVc.navigationController pushViewController:avc animated:YES];
    /*
    }
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO: Zup_获取详情内容
    [self getDetailInfo];
}
- (void)configUI{
    
    NSLog(@"时间排序: %ld",_sort);
    
    NSError *error = nil;
    
    _imageSizeCache = [[NSCache alloc] init];
    _cellCache = [[NSCache alloc] init];
    _cellCache.totalCostLimit = 10;
    _cellCache.countLimit = 10;
    
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
    
    [self setBottomBarData];
    
    [self.view addSubview:pbdBottom];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i++) {
        HPAudioVideoModel *model = [HPAudioVideoModel new];
        model.isopen = NO;
        [arr addObject:model];
    }
    self.array = arr.copy;
    [self.tableView reloadData];
    
    /// 当前用户 是否连续播放微党课
    __block NSNumber *loopPlay = [NSUserDefaults.standardUserDefaults objectForKey:self.userLoopPlayKey];
    
    if (self.lessonMediaType == ModelMediaTypeVideo) {
        /// MARK: 视频播放器
        HPVideoContainerView *vpv = [[HPVideoContainerView alloc] init];
        
        [vpv.playerView.conPlay addTarget:self action:@selector(audioLoopPlay:) forControlEvents:UIControlEventTouchUpInside];
        vpv.playerView.conPlay.selected = loopPlay.boolValue;
        
        vpv.lessonDetailVc = self;
        vpv.delegate = self;
        vpv.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.videoInsets);
        [self.view addSubview:vpv];
        vpv.model = self.model;
        _vpv = vpv;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
        
    }else if (self.lessonMediaType == ModelMediaTypeAudio){
        /// MARK: 音频播放器
        HPAudioPlayerView *apv = [HPAudioPlayerView audioPlayerView];
        apv.delegate = self;
        
        [apv.audioPlayer.conPlay addTarget:self action:@selector(audioLoopPlay:) forControlEvents:UIControlEventTouchUpInside];
        apv.audioPlayer.conPlay.selected = loopPlay.boolValue;
        
        apv.lessonDetailVc = self;
        apv.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.audioInsets);
        [self.view addSubview:apv];
        apv.model = self.model;
        _apv = apv;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        
    }else{
        /// 其他
    }
    [[HPAddBroseCountMgr new] addBroseCountWithId:self.model.seqid success:^{
        self.model.playcount += 1;
        [self.tableView reloadData];
    }];
    
    if (loopPlay.boolValue) {

        [DJHomeNetworkManager.sharedInstance frontNews_selectClassIdWithClassid:self.model.classid sort:_sort success:^(id responseObj) {
            [self handleAllLessonIdWith:responseObj];
            
        } failure:^(id failureObj) {
            loopPlay = @(NO);
            _apv.audioPlayer.conPlay.selected = NO;
            _vpv.playerView.conPlay.selected = NO;
            [NSUserDefaults.standardUserDefaults setObject:loopPlay forKey:self.userLoopPlayKey];
            [self presentFailureTips:@"获取列表失败，请稍后重试"];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
    }
}
// TODO: Zup_添加获取详情接口
- (void)getDetailInfo
{
    [DJHomeNetworkManager homePointNewsDetailWithId:_model.seqid type:DJDataPraisetypeMicrolesson success:^(id responseObj) {
        self.model = [DJDataBaseModel mj_objectWithKeyValues:responseObj];
        // TODO: Zup_如果有 width=100% 则不显示图片 原因未知
        self.model.content = [self.model.content stringByReplacingOccurrencesOfString:@" width=\"100%\"" withString:@" "];
        [self configUI];
    } failure:^(id failureObj) {
        
    }];
}

- (void)setBottomBarData{
    /// 设置数据
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
    
    _pbdBottom.leftIsSelected = !(praiseid <= 0);
    _pbdBottom.middleIsSelected = !(collectionid <= 0);
    _pbdBottom.likeCount = likeCount;
    _pbdBottom.collectionCount = collectionCount;
}

/// MARK: 音频循环 播放
- (void)audioLoopPlay:(UIButton *)sender{
    __block NSNumber *loopPlay = [NSUserDefaults.standardUserDefaults objectForKey:self.userLoopPlayKey];
    loopPlay = @(!loopPlay.boolValue);
    sender.selected = loopPlay.boolValue;
    [NSUserDefaults.standardUserDefaults setObject:loopPlay forKey:self.userLoopPlayKey];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    if (sender.isSelected) {
        if (!allLessonIds) {
            
            /// 添加 “列表播放” 提示
            CGFloat nw = 100;
            CGFloat nx = (kScreenWidth - nw) * 0.5;
            CGFloat nh = 40;
            CGFloat ny = kScreenHeight - kTabBarHeight - marginTwenty - nh;
            if (!notice) {
                notice = [DJListPlayNoticeView.alloc initWithFrame:CGRectMake(nx, ny, nw, nh)];
                [notice showNoticeWithView:self.view complete:^{
                    notice = nil;
                }];
            }
            
            [DJHomeNetworkManager.sharedInstance frontNews_selectClassIdWithClassid:self.model.classid sort:_sort success:^(id responseObj) {
                [self handleAllLessonIdWith:responseObj];
            } failure:^(id failureObj) {
                loopPlay = @(NO);
                sender.selected = NO;
                [NSUserDefaults.standardUserDefaults setObject:loopPlay forKey:self.userLoopPlayKey];
                [self presentFailureTips:@"获取列表失败，请稍后重试"];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }];
        }
    }else{
        if (allLessonIds) {
            allLessonIds = nil;
        }
    }
}

- (void)videoContainerCompletedWithModel:(DJDataBaseModel *)model{
    [self currentMediaPlayCompleteWithCurrentModel:model];
}

#pragma mark - DJMediaPlayDelegate
- (void)currentMediaPlayCompleteWithCurrentModel:(DJDataBaseModel *)currentModel{
    if (allLessonIds.count) {
        for (NSInteger i = 0; i < allLessonIds.count; i++) {
            LGBaseModel *model = allLessonIds[i];
            if (currentModel.seqid == model.seqid) {
                currentPlayIndex = i;
            }
        }
        
        // TODO: Zup_顺序播放变成逆序播放
        if (currentPlayIndex == 0) { // currentPlayIndex == (allLessonIds.count - 1)
            
            UIAlertController *alertvc = [LGAlertControllerManager alertvcWithTitle:@"提示" message:@"该专辑已全部播放完毕" doneText:@"确定" doneBlock:^(UIAlertAction * _Nonnull action) {
            }];
            [self presentViewController:alertvc animated:YES completion:nil];
            
        }else{
            NSInteger nextIndex = currentPlayIndex - 1; //  currentPlayIndex + 1
            LGBaseModel *nextModel = allLessonIds[nextIndex];
            
            /// MARK: 请求下一条数据，自动播放
            [DJHomeNetworkManager homePointNewsDetailWithId:nextModel.seqid type:DJDataPraisetypeMicrolesson success:^(id responseObj) {
                
                self.model = [DJDataBaseModel mj_objectWithKeyValues:responseObj];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self setBottomBarData];
                    if (self.lessonMediaType == ModelMediaTypeVideo) {
                        _vpv.model = self.model;
                        [_vpv.playerView play];
                    }else{
                        _apv.model = self.model;
                        [_apv manualPlay];
                    }
                    [self.tableView reloadData];
                }];
                
            } failure:^(id failureObj) {
                
            }];
        }
    }
}

- (void)handleAllLessonIdWith:(id)responseObj{
    NSArray *arr = responseObj;
    if (!(arr == nil || arr.count == 0)) {
        NSMutableArray *arrmu = NSMutableArray.new;
        for (NSInteger i = 0; i < arr.count; i++) {
            LGBaseModel *model = [LGBaseModel mj_objectWithKeyValues:arr[i]];
            [arrmu addObject:model];
        }
        allLessonIds = arrmu.copy;
    }
}

- (void)videoConViewPlayCheckWithPlayerView:(PLPlayerView *)playeView{
    /// 在控制器的代理方法中,执行playerview的- (void)lg_play_before  和  - (void)lg_real_play;两个新方法
    
    [playeView lg_play_before];
    [LGNoticer.new noticeNetworkStatusWithBlock:^(BOOL notice) {
        if (notice) {
            /// 提示用户当前为流量状态
            UIAlertController *alertvc = [UIAlertController lg_popUpWindowWithTitle:@"提示" message:@"当前播放会消耗流量" preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" doneTitle:@"继续播放" cancelBlock:^(UIAlertAction * _Nonnull action) {
            } doneBlock:^(UIAlertAction * _Nonnull action) {
                [playeView lg_real_play];
                
            }];
            [self presentViewController:alertvc animated:YES completion:nil];
            
        }else{
            /// 继续播放
            [playeView lg_real_play];
        }
    }];
}

#pragma mark - LGThreeRightButtonViewDelegate
- (void)leftClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 点赞
    [self likeCollectWithClickSuccess:success collect:NO sender:sender];
}
- (void)middleClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 收藏
    [self likeCollectWithClickSuccess:success collect:YES sender:sender];
}
- (void)rightClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    /// 分享
    
}

- (void)likeCollectWithClickSuccess:(ClickRequestSuccess)clickSuccess collect:(BOOL)collect sender:(UIButton *)sender{
    /// task 执行 cancel 方法之后 执行falure回调
    
    DJDataBaseModel *model = self.model;
    sender.userInteractionEnabled = NO;
    
    _task = [[DJUserInteractionMgr sharedInstance] likeCollectWithModel:model collect:collect type:DJDataPraisetypeMicrolesson success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
        
        if (collect) {
            /// 收藏
            for (DJDataBaseModel *lesson in self.dataSyncer.home_lessons) {
                if (lesson.seqid == model.seqid) {
                    lesson.collectionid = model.collectionid;
                    lesson.collectioncount = model.collectioncount;
                }
            }
        }else{
            /// 点赞
            for (DJDataBaseModel *lesson in self.dataSyncer.home_lessons) {
                if (lesson.seqid == model.seqid) {
                    lesson.praiseid = model.praiseid;
                    lesson.praisecount = model.praisecount;
                }
            }
        }
        
        if (clickSuccess) clickSuccess(cbkid,cbkCount);
        
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
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
        DJLessonAVTextTableViewCell *cell = [self tableView:tableView prepareCellForIndexPath:indexPath];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _array.count - 1) {
        DJLessonAVTextTableViewCell *cell = [self tableView:tableView prepareCellForIndexPath:indexPath];
        return [cell requiredRowHeightInTableView:tableView];
    }else{
        HPAudioVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:avInfoCell];
        cell.model = self.model;
        return [cell cellHeight];
    }
}

- (DJLessonAVTextTableViewCell *)tableView:(UITableView *)tableView prepareCellForIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"dcSubPartyCoreTextCell_%ld_%ld",indexPath.section,indexPath.row];
    DJLessonAVTextTableViewCell *cell = [_cellCache objectForKey:key];
    
    if (!cell) {
        cell = [[DJLessonAVTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:richContentCell];
        cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(38, marginTen, 0, marginTen);
        cell.hasFixedRowHeight = NO;
        cell.textDelegate = self;
        cell.attributedTextContextView.shouldDrawImages = YES;
        
        [_cellCache setObject:cell forKey:key];
        
        /// 添加cell的头部信息
        UILabel *titleLabel = UILabel.new;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textColor = UIColor.EDJGrayscale_11;
        titleLabel.text = @"课程文稿";
        
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(marginEight);
            make.left.equalTo(cell.contentView.mas_left).offset(marginEight);
        }];
        [cell.contentView bringSubviewToFront:titleLabel];
        
    }
    
    /// MARK: 设置富文本数据
    [cell setHTMLString:self.model.content];
    
    /// 为每个占位图设置大小
    for (DTTextAttachment *oneAttachment in cell.attributedTextContextView.layoutFrame.textAttachments) {
        NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
        if (sizeValue) {
            cell.attributedTextContextView.layouter = nil;
            oneAttachment.displaySize = [sizeValue CGSizeValue];
            [cell.attributedTextContextView relayoutText];
        }
    }
    [cell.attributedTextContextView relayoutText];
    return cell;
}
#pragma mark - DTAttributedTextContentViewDelegate
//对于没有在Html标签里设置宽高的图片，在这里为其设置占位
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        imageView.contentView = attributedTextContentView;
        
        return imageView;
    }
    return nil;
}

// TODO: Zup_添加超链接跳转
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
    NSLog(@"\n==============\nurl:%@\nidentify:%@\nframe:%@\n---------------", url, identifier, NSStringFromCGRect(frame));
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = url;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)linkPushed:(DTLinkButton *)button
{
    DJWebDetailViewController *webDetail = [[DJWebDetailViewController alloc] init];
    webDetail.url = button.URL;
    [self.navigationController pushViewController:webDetail animated:YES];
}

#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size{
    BOOL needUpdate = NO;
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    for (DTTextAttachment *oneAttachment in [lazyImageView.contentView.layoutFrame textAttachmentsWithPredicate:pred]){
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero)){
            oneAttachment.originalSize = size;
            NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
            if (!sizeValue) {
                //将图片大小记录在缓存中，但是这种图片的原始尺寸可能很大，所以这里设置图片的最大宽
                //并且计算高
                CGFloat aspectRatio = size.height / size.width;
                CGFloat width = kScreenWidth - 100;
                CGFloat height = width * aspectRatio;
                CGSize newSize = CGSizeMake(width, height);
                [_imageSizeCache setObject:[NSValue valueWithCGSize:newSize]forKey:url];
            }
            needUpdate = YES;
        }
    }
    
    if (needUpdate) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }
    
}

#pragma mark - HPAudioVideoInfoCellDelegate
- (void)avInfoCellOpen:(HPAudioVideoInfoCell *)cell isOpen:(BOOL)isOpen{
    /// 课程信息的展开与收起
    [self.tableView reloadData];
//    if (!isOpen) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
//    }
    
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
//        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        [_tableView registerNib:[UINib nibWithNibName:avContentCell bundle:nil] forCellReuseIdentifier:avContentCell];
        /// 注册课程文稿cell
        [_tableView registerClass:[DJLessonAVTextTableViewCell class] forCellReuseIdentifier:lessonAVTextCell];
        
        [_tableView registerNib:[UINib nibWithNibName:avInfoCell bundle:nil] forCellReuseIdentifier:avInfoCell];
        
        if (self.lessonMediaType == DJLessonMediaTypeVideo) {
            /// 视频
            _tableView.contentInset = UIEdgeInsetsMake(self.videoInsets, 0, 0, 0);
        }else if (self.lessonMediaType == DJLessonMediaTypeAudio) {
            /// 音频
            _tableView.contentInset = UIEdgeInsetsMake(self.audioInsets, 0, 0, 0);
        }
        
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.lessonMediaType == ModelMediaTypeVideo){
        [self endPlay];
    }
}

- (void)dealloc{
    [self endPlay];
}

- (void)lg_dismissViewController{
    
    [self endPlay];
    
    [super lg_dismissViewController];
}

- (void)endPlay{
    [_task cancel];
    
    if (_opreated) {
        [_vpv stop];
        [_apv audioStop];
    }
    
    [self IntegralGrade_addWithIntegralid:DJUserAddScoreTypeReadLesson];
}

- (NSString *)userLoopPlayKey{
    return [NSString stringWithFormat:@"%@_loopPlay",DJUser.sharedInstance.userid];
}

- (CGFloat)audioInsets{
    /// 加括号只是为了表示 乘除关系 不加也可以正确计算期望值
    if ([LGDevice isiPad]) {
        return (296 * kScreenHeight) / plusScreenHeight;
    }
    return 296;
}

- (CGFloat)videoInsets{
    if ([LGDevice isiPad]) {
        return (233 * kScreenHeight) / plusScreenHeight;
    }
    return 233;
}

@end
