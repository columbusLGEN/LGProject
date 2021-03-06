//
//  LGSegmentView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSegmentView.h"
#import "LGSegmentViewController.h"

static CGFloat flyW = 60;

@interface LGSegmentView ()
@property (strong,nonatomic) NSMutableArray<NSString *> *buttonTitleFrames;
@property (weak,nonatomic) UIView *fly;
@property (strong,nonatomic) NSArray *segmentItems;
@property (strong,nonatomic) NSArray *buttons;
@end

@implementation LGSegmentView

- (instancetype)initWithSegmentItems:(NSArray<NSDictionary *> *)items{
    NSMutableArray *itemStrings = [NSMutableArray array];
    for (NSInteger i = 0; i < items.count; i++) {
        NSDictionary *obj = items[i];
        NSString *itemName = obj[LGSegmentItemNameKey];
        [itemStrings addObject:itemName];
    }
    self.segmentItems = itemStrings;
    return [self init];
}

- (void)buttonClick:(UIButton *)button{
    [self setFlyLocationWithIndex:button.tag];
    if ([self.delegate respondsToSelector:@selector(segmentView:click:)]) {
        [self.delegate segmentView:self click:button.tag];
    }
}

- (void)setFlyLocationWithIndex:(NSInteger)index{
    
    UIButton *curButton = self.buttons[index];
    for (UIButton *button in self.buttons) {
        if (curButton == button) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    CGRect flyFrame = self.fly.frame;
    flyFrame.origin.x = [self flyXWithIndex:index];
    [UIView animateWithDuration:0.2 animations:^{
        self.fly.frame = flyFrame;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupUI];
    
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    _buttonTitleFrames = [NSMutableArray array];
    
    CGRect firstButtonFrame;
    NSMutableArray *arrmu = NSMutableArray.new;
    for (int i = 0; i < self.segmentItems.count; i++) {
        NSString *content = self.segmentItems[i];
        
        CGFloat x = self.buttonW * i;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, self.buttonW, 40)];
        if (i == 0) {
            firstButtonFrame = button.frame;
            button.selected = YES;
        }
        button.tag = i;
        
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:content forState:UIControlStateNormal];
        [button setTitleColor:[UIColor EDJGrayscale_33] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor EDJMainColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [arrmu addObject:button];
    }
    self.buttons = arrmu.copy;
    
    CGRect flyDefaultFrame = CGRectMake([self flyXWithIndex:0], firstButtonFrame.size.height - 2, flyW, 2);
    
    UIView *fly = [[UIView alloc] initWithFrame:flyDefaultFrame];
    fly.backgroundColor = [UIColor EDJMainColor];
    [self addSubview:fly];
    _fly = fly;

}

- (CGFloat)flyXWithIndex:(NSInteger)index{
    return self.buttonW * index + (self.buttonW - flyW) / 2 - 1;
}

- (CGFloat)buttonW{
    return kScreenWidth / self.segmentItems.count;
}

@end
