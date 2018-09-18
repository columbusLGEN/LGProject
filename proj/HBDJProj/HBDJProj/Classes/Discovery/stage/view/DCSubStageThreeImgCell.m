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
#import "DJUcMyCollectPYQModel.h"

@interface DCSubStageThreeImgCell ()
@property (nonatomic,strong) HZPhotoGroup *groupView;

@end

@implementation DCSubStageThreeImgCell

- (void)setModel:(DCSubStageModel *)model{
    [super setModel:model];
    [self assiDataWithModel:model];
}

- (void)setMc_pyq_model:(DJUcMyCollectPYQModel *)mc_pyq_model{
    [super setMc_pyq_model:mc_pyq_model];
    [self assiDataWithModel:mc_pyq_model];
    
    if (mc_pyq_model.edit) {
        self.groupView.userInteractionEnabled = NO;
        
    }else{
        self.groupView.userInteractionEnabled = YES;
        
    }
}
- (void)assiDataWithModel:(DCSubStageModel *)model{
    if (model.imgs.count == 1 && [model.imgs[0] isEqualToString:@""]) {
        /// 说明只有文字
        
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_left);
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
            make.left.equalTo(self.icon.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.top.equalTo(self.contentView.mas_top).offset(contentTopOffset);
        }];
        [self.groupView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom);
            make.left.equalTo(self.icon.mas_left);
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
