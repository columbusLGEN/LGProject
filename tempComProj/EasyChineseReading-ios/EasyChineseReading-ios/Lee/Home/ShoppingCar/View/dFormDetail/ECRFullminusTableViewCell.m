//
//  ECRFullminusTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/29.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRFullminusTableViewCell.h"
#import "ECRFullminusJuanView.h"
#import "ECRRowObject.h"
//#import "ECRFullminusModel.h"

@interface ECRFullminusTableViewCell ()
@property (unsafe_unretained, nonatomic) IBOutlet UIView *line;


@end

@implementation ECRFullminusTableViewCell

- (void)setRowModel:(ECRRowObject *)rowModel{
    _rowModel = rowModel;
    // 创建 1~2个满减卷
    __block CGFloat x;

    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == _line) {
            
        }else{
            [obj removeFromSuperview];
        }
    }];
    [rowModel.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ECRFullminusJuanView *juanView = [ECRFullminusJuanView fmJuanView];
        x = Screen_Width * 0.5 * idx;
        // 计算 宽高
        juanView.frame = CGRectMake(x, 0, Screen_Width * 0.5, self.cellHeight - 20);
        juanView.model = obj;
//        NSLog(@"frame -- %@",NSStringFromCGRect(juanView.frame));
        [self.contentView addSubview:juanView];
    }];
    
}




- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _line.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
}

- (CGFloat)cellHeight{
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 150;
    }else{
        return 130;
    }
}

@end
