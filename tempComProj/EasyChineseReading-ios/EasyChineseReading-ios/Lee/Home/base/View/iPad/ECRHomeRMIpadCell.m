//
//  ECRHomeRMIpadCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/30.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRHomeRMIpadCell.h"
#import "ECRHomeRMSingleView.h"
#import "ECRRowObject.h"
#import "ECRRankUser.h"

@interface ECRHomeRMIpadCell ()
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation ECRHomeRMIpadCell

- (void)setRowModel:(ECRRowObject *)rowModel{
    _rowModel = rowModel;
    __block CGFloat x = 0;
    CGFloat space = 0;
    if (self.contentView.subviews.count) {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:_line]) {
            }else{
                [obj removeFromSuperview];
                obj = nil;
            }
        }];
    }
    [rowModel.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ECRRankUser *rankUser = obj;
        ECRHomeRMSingleView *single = [ECRHomeRMSingleView rmSingleView];
        x = Screen_Width * 0.5 * idx + space;
        single.frame = CGRectMake(x, 0, Screen_Width * 0.5 - 2 * space, self.cellHeight - 1);
        single.model = rankUser;
        [self.contentView addSubview:single];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    _line.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
    self.contentView.backgroundColor = [UIColor clearColor];
}
- (CGFloat)cellHeight{
    return 89;
}


@end
