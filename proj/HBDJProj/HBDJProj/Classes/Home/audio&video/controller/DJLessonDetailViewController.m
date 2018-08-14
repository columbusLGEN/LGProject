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

static CGFloat videoInsets = 233;
static CGFloat audioInsets = 296;

@interface DJLessonDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
HPAudioVideoInfoCellDelegate,
LGVideoInterfaceViewDelegate,
LGThreeRightButtonViewDelegate,
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate>
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

@implementation DJLessonDetailViewController

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
}
- (void)configUI{
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
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
        titleLabel.font = [UIFont systemFontOfSize:17];
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
