//
//  LGSegmentBottomView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSegmentBottomView.h"

@interface LGSegmentBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *allSelect;
@property (weak, nonatomic) IBOutlet UIButton *delete;


@end

@implementation LGSegmentBottomView

- (IBAction)allSelect:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    if ([self.delegate respondsToSelector:@selector(segmentBottomAll:)]) {
        [self.delegate segmentBottomAll:self];
    }
}
- (IBAction)delete:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(segmentBottomDelete:)]) {
        [self.delegate segmentBottomDelete:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_delete cutBorderWithBorderWidth:0 borderColor:0 cornerRadius:_delete.height / 2];
}
//- (void)awakeFromNib{
//    [super awakeFromNib];
//    self.backgroundColor = [UIColor whiteColor];
//}
+ (instancetype)segmentBottom{
    return [[[NSBundle mainBundle] loadNibNamed:@"LGSegmentBottomView" owner:nil options:nil] lastObject];
    
}

+ (CGFloat)bottomHeight{
    CGFloat bottomHeight = 50;
    if ([LGDevice isiPhoneX]) {
        bottomHeight = 70;
    }
    return bottomHeight;
}

@end
