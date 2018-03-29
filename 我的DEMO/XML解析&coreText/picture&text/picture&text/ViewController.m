//
//  ViewController.m
//  picture&text
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "ViewController.h"
#import "PictureTextDisplayTestView.h"
#import "LEENewsDetailHTMLView.h"
#import "LGHTMLParser.h"
#import <DTCoreText/DTCoreText.h>

@interface ViewController ()<UIScrollViewDelegate,DTAttributedTextContentViewDelegate>

@property (weak,nonatomic) UIScrollView *scrollView;
/** */
@property (weak,nonatomic) DTAttributedTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//
//    // html 显示
//    LEENewsDetailHTMLView *view = [[LEENewsDetailHTMLView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
//    view.html = html;
    

    /// DTCoreText 显示
    [[[LGHTMLParser alloc] init] HTMLSax:^(id objc) {
        NSAttributedString *string = (NSAttributedString *)objc;

        /// 目标frame: 可以显示 string 的大小 --> 只需知道 string 的最大高度即可

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            DTAttributedTextView *textView = [[DTAttributedTextView alloc] initWithFrame:self.view.bounds];
            _textView = textView;
            textView.shouldDrawImages = NO;
            textView.textDelegate = self;
            textView.attributedString = string;
            [self.view addSubview:textView];

        }];
    }];
    
}

#pragma mark -
- (void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView didDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context{
    
    
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
    
    // TODO: 改变图片的尺寸,适应手机屏幕大小
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [_textView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            [_textView relayoutText];
        });
    }
}

@end















