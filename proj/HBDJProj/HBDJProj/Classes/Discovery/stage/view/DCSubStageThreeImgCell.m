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
#import "HZPhotoGroup.h"
#import "LGThreeRightButtonView.h"

@interface DCSubStageThreeImgCell ()
@property (strong,nonatomic) DCSubStageModel *subModel;
//@property (weak,nonatomic) LGNineImgView *nineImg;
@property (nonatomic,strong) HZPhotoGroup *groupView;

@end

@implementation DCSubStageThreeImgCell

- (void)setModel:(DCSubStageModel *)model{
    [super setModel:model];
    _subModel = model;
    
    if (model.imgs.count == 1 && [model.imgs[0] isEqualToString:@""]) {
        /// 说明只有文字
        
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.top.equalTo(self.contentView.mas_top).offset(contentTopOffset);
            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginEight);
        }];
        self.groupView.hidden = YES;
        
    }else{
        self.groupView.hidden = NO;
        CGFloat nineImageViewHeight = niImgWidth;
        
        NSArray *dataSource = model.imgs;
        
        self.groupView.urlArray = dataSource;
        
        if (dataSource.count < 4) {
        }else if (dataSource.count < 7){
            nineImageViewHeight += (niImgWidth + niMargin);
        }else{
            nineImageViewHeight += (niImgWidth + niMargin) * 2;
        }
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.top.equalTo(self.contentView.mas_top).offset(contentTopOffset);
        }];
        [self.groupView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTwenty);
            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginEight);
            make.height.mas_equalTo(nineImageViewHeight);
        }];
    }

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.groupView];
        
    }
    return self;
}

- (HZPhotoGroup *)groupView{
    if (!_groupView) {
        _groupView = [[HZPhotoGroup alloc] init];
    }
    return _groupView;
}

@end
