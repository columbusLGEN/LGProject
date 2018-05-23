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

#import "DCRichTextTopInfoView.h"

static const CGFloat richTextTopInfoViewHeight = 100;

@interface HPPartyBuildDetailViewController ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate>

/** 是否显示,查看次数,默认为NO，不显示 */
@property (assign,nonatomic) BOOL displayCounts;

@property (strong,nonatomic) DTAttributedTextView *coreTextView;
/** 图片尺寸缓存 */
@property (nonatomic, strong) NSCache *imageSizeCache;

@end

@implementation HPPartyBuildDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    _imageSizeCache = [[NSCache alloc] init];
    
    CGFloat bottomHeight = 60;
    BOOL isiPhoneX = ([LGDevice sharedInstance].currentDeviceType == LGDeviecType_iPhoneX);
    if (isiPhoneX) {
        bottomHeight = 90;
    }
    
    /// core text
    [[[LGHTMLParser alloc] init] HTMLSax:^(id objc) {
        NSAttributedString *string = (NSAttributedString *)objc;
        
        /// 目标frame: 可以显示 string 的大小 --> 只需知道 string 的最大高度即可
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            DTAttributedTextView *textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - bottomHeight - kNavHeight)];
            _coreTextView = textView;
            textView.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(richTextTopInfoViewHeight, marginFifteen, 0, marginFifteen);
            textView.textDelegate = self;
            textView.attributedString = string;
            [self.view addSubview:textView];
            
            /// MARK: 顶部信息view
            DCRichTextTopInfoView *topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
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
}

#pragma mark - LGThreeRightButtonViewDelegate

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
- (BOOL)displayCounts{
    if (self.coreTextViewType == LGCoreTextViewTypePoint) {
        return NO;
    }else{
        return YES;
    }
}

@end
