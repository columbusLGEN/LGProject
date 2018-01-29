//
//  ECRSubjectCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/23.
//  Copyright © 2017年 retech. All rights reserved.
//

static CGFloat cellH = 169;

#import "ECRSubjectCell.h"
//#import "ECRSubjectRowModel.h"
#import "ECRRowObject.h"
#import "ECRSubjectModel.h"
#import "ECRSubjectSingleView.h"

@interface ECRSubjectCell ()
@property (strong,nonatomic) IBOutlet UIView *line;//


@end

@implementation ECRSubjectCell

- (void)setRowModel:(ECRRowObject *)rowModel{
    _rowModel = rowModel;
    __block CGFloat x = 0;
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ECRSubjectSingleView class]]) {
            [obj removeFromSuperview];
        }
    }];
    [rowModel.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ECRSubjectSingleView *single = [ECRSubjectSingleView subjectSingleView];
        x = Screen_Width * 0.5 * idx;
        single.frame = CGRectMake(x, 0, Screen_Width * 0.5, cellH - 1);
        single.model = obj;
        [self.contentView addSubview:single];
    }];
//    [rowModel.subjectArray enumerateObjectsUsingBlock:^(ECRSubjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        NSLog(@"celheight -- %f",self.height);
//
//    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _line.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)cellHeight{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return cellH;
    }else{
        return cellH;
    }
}


@end
