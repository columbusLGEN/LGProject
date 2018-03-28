//
//  PictureTextDisplayTestView.m
//  picture&text
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 LG. All rights reserved.
//

/// testImg

#import "PictureTextDisplayTestView.h"
#import <CoreText/CoreText.h>

static NSString * const heightKey = @"height";
static NSString * const widthKey = @"width";

@interface PictureTextDisplayTestView ()


@end

@implementation PictureTextDisplayTestView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    

    /// 1.准备工作: 转换坐标系
    /// 1.1 获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    /// 1.2 设置字形的图形变换矩阵不做图形变换 ?
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    /// 1.3 将画布向上平移一个屏幕高度
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    /// 1.4 缩放方法
    /// x轴缩放系数为1 表示不变
    /// y轴缩放系数为-1 表示 以x轴为轴旋转180°
    CGContextScaleCTM(context, 1.0, -1.0);
    
    /// 创建测试文本
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"\n图文混排测试,\n我是一个富文本"];
    
    /// 2.图片代理设置
    /// 2.1 设置一个回调结构体
    /// 创建一个回调结构体, 设置相关参数
    CTRunDelegateCallbacks callBacks;
    /// memset 将已开辟内存空间 callBacks 的首 n 个字节设置为值 0, 相当于对 CTRunDelegateCallbacks 内存空间初始化
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    /// 设置回调版本,默认 kCTRunDelegateVersion1
    callBacks.version = kCTRunDelegateVersion1;
    /// 设置图片顶部距离基线的距离
    callBacks.getAscent = ascentCallBacks;
    /// 设置图片底部距离基线的距离
    callBacks.getDescent = descentCallBacks;
    /// 设置图片宽度
    callBacks.getWidth = widthCallBacks;
    
    /// 2.2 创建一个代理
    /// 创建一个图片尺寸的字典
    NSDictionary *picDict = @{heightKey:@"200",widthKey:@"300"};
    /// 创建代理
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks,(__bridge void *)(picDict));
    
    /// 3.图片的插入
    /// 首先 创建富文本占位符,绑定代理
    /// 创建空白字符
    unichar placeHolder = 0xFFFC;
    /// 生成空白字符串
    NSString *placeHolderString = [NSString stringWithCharacters:&placeHolder length:1];
    /// 初始化占位符 富文本
    NSMutableAttributedString *placeHolderAttrString = [[NSMutableAttributedString alloc] initWithString:placeHolderString];
    /// 给字符串中的范围中字符串设置代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    /// 释放
    CFRelease(delegate);
    /// 将占位符 插入原富文本
    [attributeString insertAttributedString:placeHolderAttrString atIndex:8];
    
    /// 4.绘制
    /// 4.1 绘制文本
    /// frame工厂,负责生成frame
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeString);
    /// 创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    /// 添加绘制尺寸
    CGPathAddRect(path, NULL, self.bounds);
    /// 工厂根据绘制区域以及富文本设置frame
    NSInteger length = attributeString.length;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    /// 根据frame绘制文字
    CTFrameDraw(frame, context);
    
    /// 4.2 绘制图片
    UIImage *testImg = [UIImage imageNamed:@"testImg"];
    /// 获取图片的frame
    CGRect imgFrame = [self calculateImageRectWithFrame:frame];
    CGContextDrawImage(context, imgFrame, testImg.CGImage);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    
}

static CGFloat ascentCallBacks(void * ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:heightKey] floatValue];
}
static CGFloat descentCallBacks(void * ref){
    return 0;
}
static CGFloat widthCallBacks(void * ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:widthKey] floatValue];
}

- (CGRect)calculateImageRectWithFrame:(CTFrameRef)frame{
    /// 根据frame 获取需要绘制的线的数组
    NSArray *arrLines = (NSArray *)CTFrameGetLines(frame);
    /// 获取线的数量
    NSInteger lineCount = [arrLines count];
    /// 建立起点的数组 CGPoint 是 C语言结构体,所以是C语言数组
    CGPoint points[lineCount];
    /// 获取起点
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    
    /// 遍历所有的CTRun 检查它是否是绑定图片的那个,如果是, 计算该CTRun的尺寸
    for (int i = 0; i < lineCount; i ++) {
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray * arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < arrGlyphRun.count; j ++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary * dic = CTRunDelegateGetRefCon(delegate);
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            CGPoint point = points[i];
            CGFloat ascent;
            CGFloat descent;
            CGRect boundsRun;
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            boundsRun.size.height = ascent + descent;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            boundsRun.origin.x = point.x + xOffset;
            boundsRun.origin.y = point.y - descent;
            CGPathRef path = CTFrameGetPath(frame);
            CGRect colRect = CGPathGetBoundingBox(path);
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            return imageBounds;
        }
    }
    return CGRectZero;
}

@end
