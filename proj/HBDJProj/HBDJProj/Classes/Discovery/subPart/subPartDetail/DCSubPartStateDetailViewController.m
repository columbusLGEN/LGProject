//
//  DCSubPartStateDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateDetailViewController.h"
#import "LGThreeRightButtonView.h"
#import "DCStateCommentsTableViewCell.h"
#import "DCStateCommentsModel.h"
#import "DCStateContentsCell.h"

#import "LGHTMLParser.h"
#import "NSAttributedString+Extension.h"

#import "DCRichTextTopInfoView.h"
#import "DCRichTextBottomInfoView.h"
#import "DJSendCommentsViewController.h"
#import "DCSubPartStateModel.h"
#import "DJUserInteractionMgr.h"
#import "DJDataSyncer.h"

//static const CGFloat richTextBottomInfoViewHeight = 77;
static const CGFloat richTextBottomInfoViewHeight = 40;

static NSString * const praiseid_keyPath = @"praiseid";
static NSString * const collectionid_keyPath = @"collectionid";
static NSString * const praisecount_keyPath = @"praisecount";
static NSString * const collectioncount_keyPath = @"collectioncount";

static NSString * const topinfoview_key = @"topinfoview_key";
static NSString * const bottominfoview_key = @"bottominfoview_key";

@interface DCSubPartStateDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate,
LGThreeRightButtonViewDelegate>
@property (strong,nonatomic) LGThreeRightButtonView *bottomUserInterView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray * array;

@property (strong,nonatomic) NSAttributedString *contentString;

/** 缓存core text cell */
@property (strong,nonatomic) NSCache *cellCache;
/** 图片尺寸缓存 */
@property (nonatomic, strong) NSCache *imageSizeCache;
@property (strong,nonatomic) NSCache *topInfoViewCache;
@property (strong,nonatomic) NSCache *bottomInfoViewCache;

@end

@implementation DCSubPartStateDetailViewController{
    CGFloat coreTextHeight;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_showCommentView) {
        
        [self rightClick:nil sender:nil success:nil failure:nil];
        
        /// 滚动到评论 单元格
        NSInteger scrollToRow = self.array.count;
        if (self.array.count >  5) {
            scrollToRow = 5;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToRow inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }
    
//    NSLog(@"self.tableView.contentSize : %@",NSStringFromCGSize(self.tableView.contentSize));
//    NSLog(@"coreTextHeight: %f",coreTextHeight);
//    [self.tableView setContentOffset:CGPointMake(0, coreTextHeight - kNavHeight - 40) animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"setContentOffset: %@",NSStringFromCGPoint(scrollView.contentOffset));
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    coreTextHeight = 0;
  
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomUserInterView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.bottomUserInterView.mas_top);
        make.right.equalTo(self.view.mas_right);
    }];
    
    CGFloat bottomHeight = 50;
    if ([LGDevice isiPhoneX]) {
        bottomHeight = 70;
    }
    [self.bottomUserInterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self dataSettings];
    
    _imageSizeCache = [[NSCache alloc] init];
    _cellCache = [[NSCache alloc] init];
    _topInfoViewCache = [NSCache.alloc init];
    _bottomInfoViewCache = [NSCache.alloc init];
    _cellCache.totalCostLimit = 10;
    _cellCache.countLimit = 10;
    
    
}

- (void)dataSettings{
    
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
    
    _bottomUserInterView.leftIsSelected = !(praiseid <= 0);
    _bottomUserInterView.middleIsSelected = !(collectionid <= 0);
    _bottomUserInterView.likeCount = likeCount;
    _bottomUserInterView.collectionCount = collectionCount;
    _bottomUserInterView.rightIsSelected = self.model.iscomment;
    _bottomUserInterView.commentCount = self.model.frontComments.count;
    
    [self.model addObserver:self forKeyPath:praiseid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:collectionid_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:praisecount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:collectioncount_keyPath options:NSKeyValueObservingOptionNew context:nil];
    
    /// 注册键盘相关通知
    
    self.array = self.model.frontComments;
    [self.tableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.model) {
        if ([keyPath isEqualToString:praiseid_keyPath]) {
            _bottomUserInterView.leftIsSelected = !(self.model.praiseid <= 0);
        }
        if ([keyPath isEqualToString:collectionid_keyPath]) {
            _bottomUserInterView.middleIsSelected = !(self.model.collectionid <= 0);
        }
        if ([keyPath isEqualToString:praisecount_keyPath]) {
            _bottomUserInterView.likeCount = self.model.praisecount;
        }
        if ([keyPath isEqualToString:collectioncount_keyPath]) {
            _bottomUserInterView.collectionCount = self.model.collectioncount;
        }
    }
}

#pragma mark - delegate & data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [self tableView:tableView prepareCellForIndexPath:indexPath];
    }
    DCStateCommentsModel *model = _array[indexPath.row - 1];
    DCStateCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DCStateContentsCell *cell = [self tableView:tableView prepareCellForIndexPath:indexPath];
        /// TODO: 富文本的高度 + 评论(x) 的高度
//        return [cell requiredRowHeightInTableView:tableView] + richTextBottomInfoViewHeight;
        CGFloat cellHeight = [cell requiredRowHeightInTableView:tableView];
        coreTextHeight = cellHeight;
        return cellHeight;
    }
    DCStateCommentsModel *model = _array[indexPath.row - 1];
    return [model cellHeight];
}

- (DCStateContentsCell *)tableView:(UITableView *)tableView prepareCellForIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"dcSubPartyCoreTextCell_%ld_%ld",indexPath.section,indexPath.row];
    DCStateContentsCell *cell = [_cellCache objectForKey:key];
    DCRichTextTopInfoView *topInfoView = [_topInfoViewCache objectForKey:topinfoview_key];
    DCRichTextBottomInfoView *bottomInfoView = [_bottomInfoViewCache objectForKey:bottominfoview_key];
    
    if (!cell) {
        
        CGFloat titleHeight = [self.model.title sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) font:[UIFont systemFontOfSize:25]].height;
        CGFloat topInfoViewHeight = titleHeight + 81;
        
        cell = [[DCStateContentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:richContentCell];
        cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(topInfoViewHeight, marginFifteen, richTextBottomInfoViewHeight, marginFifteen);
        cell.hasFixedRowHeight = NO;
        cell.textDelegate = self;
        cell.attributedTextContextView.shouldDrawImages = YES;
        
        [_cellCache setObject:cell forKey:key];
        
        if (!topInfoView) {
            /// MARK: 富文本cell顶部信息view
            topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
            topInfoView.tabIndex = 1;
            [cell.contentView addSubview:topInfoView];
//            topInfoView.model = self.model;
            [topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top);
                make.left.equalTo(cell.mas_left);
                make.right.equalTo(cell.mas_right);
                make.height.mas_equalTo(topInfoViewHeight);
            }];
            
            [_topInfoViewCache setObject:topInfoView forKey:topinfoview_key];
        }
        
        /// MARK: 富文本cell底部信息view
        if (!bottomInfoView) {
            bottomInfoView = [DCRichTextBottomInfoView richTextBottomInfo];
            
            [cell.contentView addSubview:bottomInfoView];
            [bottomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left);
                make.right.equalTo(cell.mas_right);
                make.bottom.equalTo(cell.mas_bottom).offset(-marginEight);
                make.height.mas_equalTo(richTextBottomInfoViewHeight);
            }];
            
            [_bottomInfoViewCache setObject:bottomInfoView forKey:bottominfoview_key];
            
            [cell.contentView bringSubviewToFront:bottomInfoView];
        }
        
    }
    
    topInfoView.model = self.model;
    bottomInfoView.model = self.model;
    
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

/// MARK: 底部交互按钮点击
/// 点赞
- (void)leftClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:self.model collect:NO type:DJDataPraisetypeState success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
        
        if (_isSearchSubvc) {
            for (DCSubPartStateModel *modelSearch in self.dataSyncer.dicovery_branch) {
                if (modelSearch.seqid == self.model.seqid) {
                    modelSearch.praiseid = self.model.praiseid;
                    modelSearch.praisecount = self.model.praisecount;
                    NSLog(@"支部动态详情点赞同步: %@",self.model.title);
                }
            }
        }
        
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"点赞失败，请稍后重试"];
    }];
}
/// 收藏
- (void)middleClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:self.model collect:YES type:DJDataPraisetypeState success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
        
        if (_isSearchSubvc) {
            for (DCSubPartStateModel *modelSearch in self.dataSyncer.dicovery_branch) {
                if (modelSearch.seqid == self.model.seqid) {
                    modelSearch.collectionid = self.model.collectionid;
                    modelSearch.collectioncount = self.model.collectioncount;
                    NSLog(@"支部动态详情收藏同步: %@",self.model.title);
                }
            }
        }
        
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"点赞失败，请稍后重试"];
    }];
}
- (void)rightClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    DJSendCommentsViewController *vc = [DJSendCommentsViewController sendCommentvcWithModel:self.model];
    vc.commenttype = 2;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - notifications


#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.estimatedRowHeight = 80;
        [_tableView registerClass:[DCStateContentsCell class] forCellReuseIdentifier:richContentCell];
        [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}
- (LGThreeRightButtonView *)bottomUserInterView{
    if (!_bottomUserInterView) {
        _bottomUserInterView = [LGThreeRightButtonView new];
        _bottomUserInterView.bothSidesClose = YES;
        _bottomUserInterView.delegate = self;
        [_bottomUserInterView setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
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
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_discuss_normal",
                                        TRConfigSelectedImgNameKey:@"dc_discuss_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_CEB0E7]
                                        }]];
    }
    return _bottomUserInterView;
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:praiseid_keyPath];
    [self.model removeObserver:self forKeyPath:collectionid_keyPath];
    [self.model removeObserver:self forKeyPath:praisecount_keyPath];
    [self.model removeObserver:self forKeyPath:collectioncount_keyPath];
    
    [self IntegralGrade_addWithIntegralid:DJUserAddScoreTypeReadBranch];
}

@end
