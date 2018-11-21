//
//  HPPartyBuildDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPartyBuildDetailViewController.h"

#import "LGThreeRightButtonView.h"
#import "DCRichTextTopInfoView.h"

#import "EDJHomeImageLoopModel.h"

#import "LGHTMLParser.h"
#import "DJUserInteractionMgr.h"
#import "LGSocialShareManager.h"
#import "HPAddBroseCountMgr.h"
#import "LGWKWebViewController.h"

#import <WebKit/WebKit.h>
#import "LGAttributedTextView.h"
#import "DJDataSyncer.h"

@interface HPPartyBuildDetailViewController ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate,
LGThreeRightButtonViewDelegate,
WKUIDelegate,
WKNavigationDelegate>

/** 是否显示,查看次数,默认为NO，不显示 */
@property (assign,nonatomic) BOOL displayCounts;

@property (strong,nonatomic) LGAttributedTextView *coreTextView;
/** 图片尺寸缓存 */
@property (nonatomic,strong) NSCache *imageSizeCache;

@property (strong,nonatomic) NSURLSessionTask *task;

@property (weak,nonatomic) DCRichTextTopInfoView *topInfoView;


@end

@implementation HPPartyBuildDetailViewController{
    NSDate *viewDidloadDate;
}

+ (void)buildVcPushWith:(DJDataBaseModel *)model baseVc:(UIViewController *)baseVc dataSyncer:(DJDataSyncer *)dataSyncer{
    HPPartyBuildDetailViewController *dvc = [self new];
    dvc.dataSyncer = dataSyncer;
    dvc.djDataType = DJDataPraisetypeNews;
    if (model.classid == 2) {
        /// 党建要闻
        dvc.dj_jumpSource = DJPointNewsSourcePartyBuild;
    }else if (model.classid == 1){
        /// 主席要闻
        dvc.dj_jumpSource = DJPointNewsSourceZhuxiNews;
    }else{
        /// 党课
        dvc.dj_jumpSource = DJPointNewsSourceMicroLesson;
    }
    if ([model isMemberOfClass:[NSClassFromString(@"EDJHomeImageLoopModel") class]]) {
        dvc.imageLoopModel = (EDJHomeImageLoopModel *)model;
    }else{
        dvc.contentModel = model;
    }
    [baseVc.navigationController pushViewController:dvc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageSizeCache = [[NSCache alloc] init];
    
    /// bottom
    [self.view addSubview:self.pbdBottom];
    
    NSInteger praiseid = self.contentModel.praiseid;
    NSInteger collectionid = self.contentModel.collectionid;
    NSInteger likeCount = self.contentModel.praisecount;
    NSInteger collectionCount = self.contentModel.collectioncount;
    
    _pbdBottom.leftIsSelected = !(praiseid <= 0);
    _pbdBottom.middleIsSelected = !(collectionid <= 0);
    _pbdBottom.likeCount = likeCount;
    _pbdBottom.collectionCount = collectionCount;
    
    /// 添加播放次数
    [[HPAddBroseCountMgr new] addBroseCountWithId:self.contentModel.seqid success:^{
        _contentModel.playcount += 1;
        [_topInfoView reloadPlayCount:_contentModel.playcount];
    }];
    
    if (_isMsgTrans) {
        [_pbdBottom removeFromSuperview];
    }

    [self addReportInformation];
    
}

- (void)setContentModel:(DJDataBaseModel *)contentModel{
    _contentModel = contentModel;
    _pbdBottom.leftIsSelected = !(contentModel.praiseid == 0);
    _pbdBottom.middleIsSelected = !(contentModel.collectionid == 0);
    
//    NSLog(@"[contentModel.content class]: %@",[contentModel.content class]);
    
    _contentModel.content = [_contentModel.content stringByReplacingOccurrencesOfString:@"crossorigin=\"anonymous\" " withString:@""];
    
    [LGHTMLParser HTMLSaxWithHTMLString:contentModel.content success:^(NSAttributedString *attrString) {
        NSAttributedString *string = attrString;
        
        /// 计算表态高度
        CGFloat titleHeight = [contentModel.title sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) font:[UIFont systemFontOfSize:25]].height;
        CGFloat topInfoViewHeight = titleHeight + 81;
        if (_isMsgTrans) {
            topInfoViewHeight -= 30;
        }

        /// 目标frame: 可以显示 string 的大小 --> 只需知道 string 的最大高度即可
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            LGAttributedTextView *textView = [[LGAttributedTextView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - self.bottomHeight - kNavHeight)];
            textView.userInteractionEnabled = YES;
            _coreTextView = textView;
            /// 设置insets 以显示 top info view
            _coreTextView.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(topInfoViewHeight, marginFifteen, 0, marginFifteen);
            _coreTextView.textDelegate = self;
            _coreTextView.attributedString = string;
            _coreTextView.shouldDrawLinks = NO;/// 实现超链接点击，该属性设为NO，代理方法中创建DTLinkButton
            
//            UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//            [_coreTextView addGestureRecognizer:tap];
            
            [self.view addSubview:_coreTextView];

            /// MARK: 顶部信息view （标题，时间，来源等）
            DCRichTextTopInfoView *topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
            topInfoView.tabIndex = 0;
            topInfoView.displayCounts = self.displayCounts;
            topInfoView.isMsgTrans = _isMsgTrans;
            topInfoView.frame = CGRectMake(0, 0, kScreenWidth, topInfoViewHeight);
            topInfoView.model = contentModel;

            [textView addSubview:topInfoView];
            _topInfoView = topInfoView;

        }];
    }];
}

- (void)setImageLoopModel:(EDJHomeImageLoopModel *)imageLoopModel{
    _imageLoopModel = imageLoopModel;
    self.contentModel = imageLoopModel.frontNews;
}

#pragma mark Actions
/// MARK: 点击超链接响应事件
- (void)linkPushed:(DTLinkButton *)button {
    NSURL *URL = button.URL;
    
    LGWKWebViewController *webVc = [LGWKWebViewController.alloc initWithUrl:URL];
    [self.navigationController pushViewController:webVc animated:YES];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - LGThreeRightButtonViewDelegate
/// MARK: 点赞
- (void)leftClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    [self likeCollectWithClickSuccess:success collect:NO sender:sender];
}
/// MARK: 收藏
- (void)middleClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    [self likeCollectWithClickSuccess:success collect:YES sender:sender];
}
- (void)likeCollectWithClickSuccess:(ClickRequestSuccess)clickSuccess collect:(BOOL)collect sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    _task = [[DJUserInteractionMgr sharedInstance] likeCollectWithModel:self.contentModel collect:collect type:DJDataPraisetypeNews success:^(NSInteger cbkid, NSInteger cbkCount) {
        
        if (collect) {
            /// 收藏
            for (DJDataBaseModel *news in self.dataSyncer.home_news) {
                if (news.seqid == self.contentModel.seqid) {
                    news.collectionid = self.contentModel.collectionid;
                    news.collectioncount = self.contentModel.collectioncount;
                }
            }
            for (DJDataBaseModel *news in self.dataSyncer.home_lessons) {
                if (news.seqid == self.contentModel.seqid) {
                    news.collectionid = self.contentModel.collectionid;
                    news.collectioncount = self.contentModel.collectioncount;
                }
            }
        }else{
            /// 点赞
            for (DJDataBaseModel *news in self.dataSyncer.home_news) {
                if (news.seqid == self.contentModel.seqid) {
                    news.praiseid = self.contentModel.praiseid;
                    news.praisecount = self.contentModel.praisecount;
                }
            }
            for (DJDataBaseModel *news in self.dataSyncer.home_lessons) {
                if (news.seqid == self.contentModel.seqid) {
                    news.praiseid = self.contentModel.praiseid;
                    news.praisecount = self.contentModel.praisecount;
                }
            }
        }
        
        sender.userInteractionEnabled = YES;
        if (clickSuccess) clickSuccess(cbkid,cbkCount);
        
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        
    }];
}

/// MARK: 分享
- (void)rightClick:(LGThreeRightButtonView *)rbview sender:(UIButton *)sender success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    NSDictionary *param = @{LGSocialShareParamKeyWebPageUrl:_contentModel.shareUrl,
                            LGSocialShareParamKeyTitle:_contentModel.title,
                            LGSocialShareParamKeyDesc:_contentModel.sharecontent,
                            LGSocialShareParamKeyThumbUrl:_contentModel.thumbnail,
                            LGSocialShareParamKeyVc:self
                            };
    
    [[LGSocialShareManager new] showShareMenuWithParam:param shareType:DJShareTypeNews];
}

#pragma mark - DTAttributedTextContentViewDelegate
- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame{
    
    return YES;
}

#pragma mark Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press -- 长按
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
//    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
    
    DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
    
    imageView.delegate = self;
    
    // sets the image if there is one
    imageView.image = [(DTImageTextAttachment *)attachment image];
    
    // url for deferred loading
    imageView.url = attachment.contentURL;
    
    if (attachment.hyperLinkURL)
    {
        // NOTE: this is a hack, you probably want to use your own image view and touch handling
        // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
        imageView.userInteractionEnabled = YES;
        
        DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
        button.URL = attachment.hyperLinkURL;
        button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
        button.GUID = attachment.hyperLinkGUID;
        
        // use normal push action for opening URL
        [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:button];
    }
    
    return imageView;
}
#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [_coreTextView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
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
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            for (DTTextAttachment *oneAttachment in _coreTextView.attributedTextContentView.layoutFrame.textAttachments) {
                NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
                if (sizeValue) {
                    _coreTextView.attributedTextContentView.layouter = nil;
                    oneAttachment.displaySize = [sizeValue CGSizeValue];
                    [_coreTextView.attributedTextContentView relayoutText];
                }
            }
            [_coreTextView relayoutText];
            NSLog(@"刷新以加载图片 -- ");
        });
    }
}

#pragma mark - getter
/// 显示查看次数
- (BOOL)displayCounts{
    return (self.dj_jumpSource == DJPointNewsSourceMicroLesson);
}
- (CGFloat)bottomHeight{
    CGFloat bottomHeight = 60;
    BOOL isiPhoneX = ([LGDevice sharedInstance].currentDeviceType == LGDeviecType_iPhoneX);
    if (isiPhoneX) {
        bottomHeight = 90;
    }
    return bottomHeight;
}
- (LGThreeRightButtonView *)pbdBottom{
    if (!_pbdBottom) {
        LGThreeRightButtonView *pbdBottom = [[LGThreeRightButtonView alloc] initWithFrame:CGRectMake(0, kScreenHeight - self.bottomHeight, kScreenWidth, self.bottomHeight)];
        pbdBottom.delegate = self;
        _pbdBottom = pbdBottom;
        NSMutableArray *array = [@[@{TRConfigTitleKey:@"99+",
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
                                    }] mutableCopy];
        if (self.dj_jumpSource == DJPointNewsSourceMicroLesson) {
            [array removeLastObject];
        }
        [pbdBottom setBtnConfigs:array];
    }
    return _pbdBottom;
}

- (void)dealloc{
    [_task cancel];
    
    if (_dj_jumpSource == DJPointNewsSourceMicroLesson) {
        [self IntegralGrade_addWithIntegralid:DJUserAddScoreTypeReadLesson];
    }else{
        [self IntegralGrade_addWithIntegralid:DJUserAddScoreTypeReadNews];
        if (_dj_jumpSource == DJPointNewsSourceZhuxiNews) {
            /// 上传查看 主席要闻时长
            NSTimeInterval readZxNewsTime = [[NSDate date] timeIntervalSinceDate:viewDidloadDate];
            NSString *timeString = [NSString stringWithFormat:@"%f",readZxNewsTime];
//            NSLog(@"查看主席要闻时长: %@",timeString);
            [self frontIntegralGrade_addReportInformationWithTaskid:31 completenum:timeString];
        }
    }
}

- (void)frontIntegralGrade_addReportInformationWithTaskid:(NSInteger)taskid completenum:(NSString *)completenum{
    [DJHomeNetworkManager.sharedInstance frontIntegralGrade_addReportInformationWithTaskid:taskid completenum:completenum success:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
}

/// MARK: 后台任务记录接口
- (void)addReportInformation{
    NSInteger ariTaskid = 29;
    BOOL ariSend = YES;
    if (self.dj_jumpSource == 0) {
        /// 党课不调用 frontIntegralGrade_addReportInformationWithTaskid 接口
        ariSend = NO;
    }
    
    if (self.dj_jumpSource == 1) {
        /// 普通要闻
    }
    if (self.dj_jumpSource == 2) {
        /// 主席要闻
        ariTaskid = 30;
        
        /// 记录阅读时间
        viewDidloadDate = [NSDate date];
    }
    if (ariSend) {
        [self frontIntegralGrade_addReportInformationWithTaskid:ariTaskid completenum:@"1"];
    }
}

@end


