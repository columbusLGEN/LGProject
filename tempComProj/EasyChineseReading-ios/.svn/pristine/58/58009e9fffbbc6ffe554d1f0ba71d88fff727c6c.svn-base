//
//  ECRDetailPJTableViewPadCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/30.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRDetailPJTableViewPadCell.h"
#import "ECRRowObject.h"
#import "ECRDetailPJTableViewPadSingleView.h"
#import "ECRScoreUserModel.h"

@interface ECRDetailPJTableViewPadCell ()
@property (weak, nonatomic) IBOutlet UIView *line;


@end

@implementation ECRDetailPJTableViewPadCell

- (void)setRowModel:(ECRRowObject *)rowModel{
    _rowModel = rowModel;
    __block CGFloat x;
    [rowModel.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ECRScoreUserModel *model = obj;
        ECRDetailPJTableViewPadSingleView *single = [ECRDetailPJTableViewPadSingleView pjSingleView];
        x = Screen_Width * 0.5 * idx;
        single.frame = CGRectMake(x, 0, Screen_Width * 0.5, self.cellHeight - 1);
        single.model = model;
        [self.contentView addSubview:single];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _line.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
    
}
- (CGFloat)cellHeight{
    return 90;
}


@end
