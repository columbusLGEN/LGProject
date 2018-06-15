//
//  HPPartyBuildDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPartyBuildDetailViewController.h"
//#import "LGThreeRightButtonView.h"
#import "LGThreeRightButtonView.h"
#import "LGHTMLParser.h"
#import "EDJHomeImageLoopModel.h"
#import "DCRichTextTopInfoView.h"
#import "EDJMicroBuildModel.h"

#import "DJUserInteractionMgr.h"
#import "LGSocialShareManager.h"

static const CGFloat richTextTopInfoViewHeight = 100;

@interface HPPartyBuildDetailViewController ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate,
LGThreeRightButtonViewDelegate>

/** 是否显示,查看次数,默认为NO，不显示 */
@property (assign,nonatomic) BOOL displayCounts;

@property (strong,nonatomic) DTAttributedTextView *coreTextView;
/** 图片尺寸缓存 */
@property (nonatomic, strong) NSCache *imageSizeCache;
@property (strong,nonatomic) LGThreeRightButtonView *pbdBottom;

@end

@implementation HPPartyBuildDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageSizeCache = [[NSCache alloc] init];
    
    /// bottom
    [self.view addSubview:self.pbdBottom];
    
}

- (void)setContentModel:(EDJMicroBuildModel *)contentModel{
    _contentModel = contentModel;
    _pbdBottom.leftIsSelected = !(contentModel.praiseid == 0);
    _pbdBottom.middleIsSelected = !(contentModel.collectionid == 0);
    
    [LGHTMLParser HTMLSaxWithHTMLString:contentModel.content success:^(NSAttributedString *attrString) {
        NSAttributedString *string = attrString;
        
        /// 目标frame: 可以显示 string 的大小 --> 只需知道 string 的最大高度即可
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            DTAttributedTextView *textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - self.bottomHeight - kNavHeight)];
            _coreTextView = textView;
            textView.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(richTextTopInfoViewHeight, marginFifteen, 0, marginFifteen);
            textView.textDelegate = self;
            textView.attributedString = string;
            [self.view addSubview:textView];
            
            /// MARK: 顶部信息view
            DCRichTextTopInfoView *topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
            topInfoView.model = contentModel;
            topInfoView.displayCounts = self.displayCounts;
            [textView addSubview:topInfoView];
            [topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(textView.mas_top);
                make.left.equalTo(textView.mas_left);
                make.width.mas_equalTo(kScreenWidth);
                make.height.mas_equalTo(richTextTopInfoViewHeight);
            }];
            
        }];
    }];
}

- (void)setImageLoopModel:(EDJHomeImageLoopModel *)imageLoopModel{
    _imageLoopModel = imageLoopModel;
    
    /**
     /// 测试数据
     {"params":{"imei":"460030912121001","imsi":"460030912121001","seqid":"1","userid":"","type":"1"},
     "md5":"654c01acaf40e0ce6d841a552fd3b96c"}
     */
    
    [DJNetworkManager homePointNewsDetailWithId:imageLoopModel.seqid type:1 success:^(id responseObj) {
        NSLog(@"homePointNewsDetailWithId -- %@",responseObj);
        EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:responseObj];
        self.contentModel = model;
//        model.collectionid;
//        model.praiseid;
        
    } failure:^(id failureObj) {
        
    }];
    
    /// 请求党建要闻详情数据
    /// imageLoopModel.seqid
//    [DJNetworkManager homePointNewsDetailWithId:imageLoopModel.seqid type:self.djDataType success:^(id responseObj) {
//        NSLog(@"homePointNewsDetailWithId -- %@",responseObj);
//
//    } failure:^(id failureObj) {
//
//    }];
    
}


#pragma mark - LGThreeRightButtonViewDelegate
/// MARK: 点赞
- (void)leftClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    [self likeCollectWithSeqid:self.contentModel.seqid pcid:self.contentModel.praiseid clickSuccess:success collect:NO];
}
/// MARK: 收藏
- (void)middleClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    [self likeCollectWithSeqid:self.contentModel.seqid pcid:self.contentModel.collectionid clickSuccess:success collect:YES];
}
- (void)likeCollectWithSeqid:(NSInteger)seqid pcid:(NSInteger)pcid clickSuccess:(ClickRequestSuccess)clickSuccess collect:(BOOL)collect{
    [DJUserInteractionMgr likeCollectWithSeqid:seqid pcid:pcid collect:collect type:DJDataPraisetypeNews success:^(id responseObj) {
        NSDictionary *dict = responseObj;
        if ([[[dict allKeys] firstObject] isEqualToString:@"praiseid"]) {
            NSLog(@"点赞 -- %@",responseObj);
            self.contentModel.praiseid = [responseObj[@"praiseid"] integerValue];
            clickSuccess(self.contentModel.praiseid);
        }else{
            NSLog(@"收藏 -- %@",responseObj);
            self.contentModel.collectionid = [responseObj[@"collectionid"] integerValue];
            clickSuccess(self.contentModel.collectionid);
        }
    } failure:^(id failureObj) {
        
    }];
}

/// MARK: 分享
- (void)rightClick:(LGThreeRightButtonView *)rbview success:(ClickRequestSuccess)success failure:(ClickRequestFailure)failure{
    [LGSocialShareManager showShareMenuWithThumbUrl:nil content:nil webpageUrl:nil vc:self];
}

#pragma mark - DTAttributedTextContentViewDelegate
- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame{
    
    return YES;
}
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
    
    DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
    
    imageView.delegate = self;
    
    // sets the image if there is one
    imageView.image = [(DTImageTextAttachment *)attachment image];
    
    // url for deferred loading
    imageView.url = attachment.contentURL;
    
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

@end
