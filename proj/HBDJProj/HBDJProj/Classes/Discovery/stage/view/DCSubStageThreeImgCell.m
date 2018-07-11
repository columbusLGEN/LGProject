//
//  DCSubStageThreeImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageThreeImgCell.h"
#import "DCSubStageModel.h"
#import "LGNineImgView.h"

@interface DCSubStageThreeImgCell ()
@property (strong,nonatomic) DCSubStageModel *subModel;
@property (weak,nonatomic) LGNineImgView *nineImg;

@end

@implementation DCSubStageThreeImgCell

- (void)setModel:(DCSubStageModel *)model{
    [super setModel:model];
    _subModel = model;
    
    if (_nineImg) {
        [_nineImg removeFromSuperview];
    }
    

    LGNineImgView *nine = [[LGNineImgView alloc] initWithFrame:CGRectMake(leftOffset, contentTopOffset + model.heightForContent + 10, kScreenWidth, model.nineImgViewHeight)];
    [self.contentView addSubview:nine];
    _nineImg = nine;
    nine.dataSource = model.imgs;
    
    /// 九宫格点击回调
    nine.tapBlock = ^(NSInteger index, NSArray *dataSource) {
        NSLog(@"idnex -- %ld",index);
    };
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];

        
    }
    return self;
}



@end
