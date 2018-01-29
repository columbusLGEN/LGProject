//
//  ECRBookClassesCollectionCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookClassesCollectionCell.h"
#import "ECRClassSortModel.h"

@interface ECRBookClassesCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *bcName;

/** 图标名前缀 */
@property (copy,nonatomic) NSString *iconNameSufix;

@end

@implementation ECRBookClassesCollectionCell

- (NSString *)iconNameSufix{
    if (_iconNameSufix == nil) {
        _iconNameSufix = @"icon_bys_class_";
    }
    return _iconNameSufix;
}
- (void)skinWithType:(ECRHomeUIType)type{
    switch (type) {
        case ECRHomeUITypeDefault:{
            
        }
        case ECRHomeUITypeAdultTwo:{
            
        }
            break;
        case ECRHomeUITypeKidOne:{
            self.bcName.textColor = [UIColor whiteColor];
        }
            break;
        case ECRHomeUITypeKidtwo:{
            
        }
            break;
    }
}
- (void)textDependsLauguage{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        _bcName.text = _model.en_name;
    }else{
        _bcName.text = _model.name;
    }
}

- (void)setModel:(ECRClassSortModel *)model{
    _model = model;
    [self textDependsLauguage];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    NSString *imgName = [NSString stringWithFormat:@"%@%ld",self.iconNameSufix,indexPath.item];
    [_icon setImage:[UIImage imageNamed:imgName]];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
    self.iconNameSufix = @"icon_bys_class_";
}

@end
