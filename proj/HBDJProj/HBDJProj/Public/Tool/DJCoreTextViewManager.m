//
//  DJCoreTextViewManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJCoreTextViewManager.h"

#import "LGHTMLParser.h"
#import "LGAttributedTextView.h"


@interface DJCoreTextViewManager ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate>
@property (strong,nonatomic) LGAttributedTextView *textView;
/** 图片尺寸缓存 */
@property (nonatomic,strong) NSCache *imageSizeCache;

@end

@implementation DJCoreTextViewManager

- (void)viewWithRichText:(NSString *)richText completion:(void(^)(LGAttributedTextView *))completion;{
    
    [LGHTMLParser HTMLSaxWithHTMLString:richText success:^(NSAttributedString *attrString) {
        NSAttributedString *string = attrString;
        
        LGAttributedTextView *textView = [[LGAttributedTextView alloc] initWithFrame:CGRectZero];
        _textView = textView;
        textView.userInteractionEnabled = YES;
        textView.attributedString = string;
        textView.shouldDrawLinks = NO;/// 实现超链接点击，该属性设为NO，代理方法中创建DTLinkButton
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completion) completion(textView);
        }];
        
    }];
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
        
        // demonstrate combination with long press
        //        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
        //        [button addGestureRecognizer:longPress];
        
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
    for (DTTextAttachment *oneAttachment in [_textView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
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
            for (DTTextAttachment *oneAttachment in _textView.attributedTextContentView.layoutFrame.textAttachments) {
                NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
                if (sizeValue) {
                    _textView.attributedTextContentView.layouter = nil;
                    oneAttachment.displaySize = [sizeValue CGSizeValue];
                    [_textView.attributedTextContentView relayoutText];
                }
            }
            [_textView relayoutText];

        });
    }
}

- (void)linkPushed:(DTLinkButton *)button {
    NSURL *URL = button.URL;
    
    if ([self.delegate respondsToSelector:@selector(hyperLinkURL)]) {
        [self.delegate hyperLinkClick:URL];
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _imageSizeCache = [[NSCache alloc] init];
    }
    return self;
}

@end
