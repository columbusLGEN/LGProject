//
//  LGNineImgView.m
//  nineImgDemo
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGNineImgView.h"

/// 设计图给的 尺寸
/// static CGFloat niWidth = 266;/// 图片布局总宽度
static CGFloat niMargin = 7;/// 图片间距
static CGFloat niImgWidth = 84;/// (266 - 2 * 7) / 3 , height = width

@interface LGNineImgView ()


@end

@implementation LGNineImgView

- (void)tapImg:(UIGestureRecognizer *)reco{
    UIImageView *img = (UIImageView *)reco.view;
    if (self.tapBlock) self.tapBlock(img.tag, self.dataSource);
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    
    
    for (NSInteger i = 0; i < dataSource.count; i++) {
        CGFloat imgX = (niImgWidth + niMargin) * (i % 3);
        CGFloat imgY = (niImgWidth + niMargin) * (i / 3);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, niImgWidth, niImgWidth)];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        if ([dataSource[i] isKindOfClass:[UIImage class]]) {
            img.image = dataSource[i];
        }else if ([dataSource[i] isKindOfClass:[NSString class]]) {
            /// sd_set
            
        }
        img.tag = i;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
        [img addGestureRecognizer:tapImg];
        [self addSubview:img];
    }
    
}

@end
