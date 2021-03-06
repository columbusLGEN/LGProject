//
//  ZStarView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ZStarView.h"

#define kUNSELECTED_STAR @"icon_book_unStar"
#define kSELECTED_STAR   @"icon_book_star"
#define kNUMBER_OF_STAR  5

#define KANIMATIONTIME 0

@interface ZStarView ()

@property (strong, nonatomic) UIView *viewStarBackground;
@property (strong, nonatomic) UIView *viewForeground;

@property (assign, nonatomic) CGRect customFrame;

@end


@implementation ZStarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self = [self initWithFrame:self.frame numberOfStar:kNUMBER_OF_STAR];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    _customFrame = frame;
    return [self initWithFrame:_customFrame numberOfStar:kNUMBER_OF_STAR];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _numberOfStar = kNUMBER_OF_STAR;
    [self commonInit];
}

/**
 *  初始化StarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return StarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)number
{
    _customFrame = frame;
    self = [super initWithFrame:_customFrame];
    if (self) {
        _numberOfStar = number;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.viewStarBackground = [self buidlStarViewWithImageName:kUNSELECTED_STAR];
    self.viewForeground = [self buidlStarViewWithImageName:kSELECTED_STAR];
    [self addSubview:self.viewStarBackground];
    [self addSubview:self.viewForeground];
}

#pragma mark -
#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     整数 
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(NSInteger)score withAnimation:(BOOL)isAnimate
{
    [self setScore:(score - 1) * 1.0 / _numberOfStar withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimate completion:(void (^)(BOOL finished))completion
{
//    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0){
        score = 0;
    }
    
    if (score > 1){
        score = score/_numberOfStar;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate){
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:KANIMATIONTIME animations:^{
            [weakSelf changeviewForegroundWithPoint:point];
        } completion:^(BOOL finished){
            if (completion){
                completion(finished);
            }
        }];
    } else {
        [self changeviewForegroundWithPoint:point];
    }
}

#pragma mark -
#pragma mark - Touche Event

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_canChange) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(CGRectContainsPoint(rect,point)){
            [self changeviewForegroundWithPoint:point];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_canChange) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:KANIMATIONTIME animations:^{
            [weakSelf changeviewForegroundWithPoint:point];
        }];
    }
}

#pragma mark - Build Star View

/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeviewForegroundWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0){
        p.x = 0;
    }
    
    if (p.x > _customFrame.size.width){
        p.x = _customFrame.size.width;
    }
    
    float tmpWidth = _customFrame.size.width / _numberOfStar;
    
    NSInteger score = (p.x + 0.001) / tmpWidth; // 加0.001 防止小数无限趋近整数, 但是比准确值小造成的数据错误 例如: 39.999999999999993
    score += 1;
    p.x = tmpWidth * score;
    
    self.viewForeground.frame = CGRectMake(0, 0, p.x, _customFrame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]){
        [self.delegate starRatingView:self score:score * 1.0];
    }
}

@end
