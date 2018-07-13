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

static const CGFloat richTextTopInfoViewHeight = 110;

@interface HPPartyBuildDetailViewController ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate,
LGThreeRightButtonViewDelegate>

/** 是否显示,查看次数,默认为NO，不显示 */
@property (assign,nonatomic) BOOL displayCounts;

@property (strong,nonatomic) DTAttributedTextView *coreTextView;
/** 图片尺寸缓存 */
@property (nonatomic,strong) NSCache *imageSizeCache;
@property (strong,nonatomic) LGThreeRightButtonView *pbdBottom;

@property (weak,nonatomic) DCRichTextTopInfoView *topInfoView;

@property (strong,nonatomic) NSURLSessionTask *task;

@end

@implementation HPPartyBuildDetailViewController

+ (void)buildVcPushWith:(id)model baseVc:(UIViewController *)baseVc{
    HPPartyBuildDetailViewController *dvc = [self new];
    dvc.djDataType = DJDataPraisetypeNews;
    if ([model isMemberOfClass:[NSClassFromString(@"EDJHomeImageLoopModel") class]]) {
        dvc.imageLoopModel = model;
    }else{
        dvc.contentModel = model;
    }
    NSLog(@"buildvc.model: %@",model);
    dvc.coreTextViewType = LGCoreTextViewTypeDefault;
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
}

- (void)setContentModel:(DJDataBaseModel *)contentModel{
    _contentModel = contentModel;
    _pbdBottom.leftIsSelected = !(contentModel.praiseid == 0);
    _pbdBottom.middleIsSelected = !(contentModel.collectionid == 0);
    
    [LGHTMLParser HTMLSaxWithHTMLString:contentModel.content success:^(NSAttributedString *attrString) {
        NSAttributedString *string = attrString;
        
        /// 目标frame: 可以显示 string 的大小 --> 只需知道 string 的最大高度即可
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            DTAttributedTextView *textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - self.bottomHeight - kNavHeight)];
            _coreTextView = textView;
            /// 设置insets 以显示 top info view
            _coreTextView.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(richTextTopInfoViewHeight, marginFifteen, 0, marginFifteen);
            _coreTextView.textDelegate = self;
            _coreTextView.attributedString = string;
            _coreTextView.shouldDrawLinks = NO;/// 实现超链接点击，该属性设为NO，代理方法中创建DTLinkButton
            [self.view addSubview:_coreTextView];

            
            /// MARK: 顶部信息view （标题，时间，来源等）
            DCRichTextTopInfoView *topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
            topInfoView.frame = CGRectMake(0, 0, kScreenWidth, richTextTopInfoViewHeight);
            topInfoView.model = contentModel;
            topInfoView.displayCounts = self.displayCounts;
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
- (void)linkPushed:(DTLinkButton *)button {
    NSURL *URL = button.URL;
    
    /// TODO: 打开URL
    NSLog(@"url: %@",URL);
}
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gesture view];
        button.highlighted = NO;
//        self.lastActionLink = button.URL;
        NSLog(@"url: %@",button.URL);
//        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
//        {
//            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.URL absoluteURL] description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
//            [action showFromRect:button.frame inView:button.superview animated:YES];
//        }
    }
}


#pragma mark - LGThreeRightButtonViewDelegate
/// MARK: 点赞
- (void)leftClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    [self likeCollectWithClickSuccess:success collect:NO];
}
/// MARK: 收藏
- (void)middleClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    [self likeCollectWithClickSuccess:success collect:YES];
}
- (void)likeCollectWithClickSuccess:(ClickRequestSuccess)clickSuccess collect:(BOOL)collect{
    _task = [[DJUserInteractionMgr sharedInstance] likeCollectWithModel:self.contentModel collect:collect type:DJDataPraisetypeNews success:^(NSInteger cbkid, NSInteger cbkCount) {
        if (clickSuccess) clickSuccess(cbkid,cbkCount);
    } failure:^(id failureObj) {
        NSLog(@"党建要闻点赞收藏失败: ");
    }];
}

/// MARK: 分享
- (void)rightClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    NSDictionary *param = @{LGSocialShareParamKeyWebPageUrl:_contentModel.shareUrl,
                            LGSocialShareParamKeyTitle:_contentModel.title,
                            LGSocialShareParamKeyDesc:_contentModel.contentvalidity,
                            LGSocialShareParamKeyThumbUrl:_contentModel.thumbnail,
                            LGSocialShareParamKeyVc:self
                            };
    
    [[LGSocialShareManager new] showShareMenuWithParam:param];
}

#pragma mark - DTAttributedTextContentViewDelegate
- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame{
    
    return YES;
}

#pragma mark Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
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
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
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
        
        // demonstrate combination with long press
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
        [button addGestureRecognizer:longPress];
        
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
    if (self.coreTextViewType == LGCoreTextViewTypePoint) {
        return NO;
    }else{
        return YES;
    }
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
    }
    return _pbdBottom;
}

- (void)dealloc{
    [_task cancel];
}

@end
