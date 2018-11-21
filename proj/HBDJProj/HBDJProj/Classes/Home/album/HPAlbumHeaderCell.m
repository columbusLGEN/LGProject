//
//  HPAlbumHeaderCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAlbumHeaderCell.h"
#import "DJDataBaseModel.h"

@interface HPAlbumHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *sotrAcce;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *more;


@end

@implementation HPAlbumHeaderCell

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    _text.text = model.classdescription;
    
    // TODO: Zup_文本少于三行时，不显示更多
    CGFloat titleHeight = [_text.text sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:17]].height;
    if (titleHeight < 61) { // 三行文本高度 60.86
        _more.hidden = YES;
        _arrow.hidden = YES;
    }
}

- (IBAction)moreClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        _text.numberOfLines = 0;
        _arrow.transform = CGAffineTransformMakeRotation(-M_PI);
    }else{
        _text.numberOfLines = 3;
        _arrow.transform = CGAffineTransformIdentity;
    }
    if ([self.delegate respondsToSelector:@selector(albumListHeaderReCalHeight)]) {
        [self.delegate albumListHeaderReCalHeight];
    }
}


- (IBAction)timeSort:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        _sotrAcce.transform = CGAffineTransformIdentity;
    }else{
        sender.selected = YES;
        _sotrAcce.transform = CGAffineTransformMakeRotation(M_PI);
    }
    if ([self.delegate respondsToSelector:@selector(albumListHeaderTimeSort)]) {
        [self.delegate albumListHeaderTimeSort];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _imgHeightConstraint.constant = homeImageLoopHeight * rateForMicroLessonCellHeight();
    _text.numberOfLines = 3;
}

- (CGFloat)headerHeight{
    CGFloat textHeight = [_model.classdescription sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:17]].height;
    // TODO: Zup_项目经理要求文本高度不超过三行时不要固定高度; (homeImageLoopHeightn * rateForMicroLessonCellHeight()) --> kHeigh_ScreedWidth9_16
    /// 19:文字到图片的间距 8:(文字到按钮的间距) 15:更多按钮高度 8:分割线到高度 44:时间排序所在view的高度
    CGFloat defaultHeight = kHeigh_ScreedWidth9_16 + 19 + 8 + 44;
    if (textHeight < 61) { // 少于三排文本，不显示更多
        return defaultHeight + textHeight + 19;
    } else {
        if (_more.isSelected){
            return defaultHeight + textHeight + 8 + 15;
        }else{
            return defaultHeight + 22 * 3 + 8 + 15;
        }
    }
//    if (_more.isSelected){
//        return homeImageLoopHeight * rateForMicroLessonCellHeight() + 19 + textHeight + 8 + 15 + 8 + 44;
//    }else{
//        return homeImageLoopHeight * rateForMicroLessonCellHeight() + 19 + 21 * 3 + 8 + 15 + 8 + 44;
//    }
}

@end
