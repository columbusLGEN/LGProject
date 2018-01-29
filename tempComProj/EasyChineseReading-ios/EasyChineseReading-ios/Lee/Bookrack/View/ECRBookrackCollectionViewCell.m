//
//  ECRBookrackCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBookrackCollectionViewCell.h"
#import "ECRBookrackModel.h"
#import "ECRBookDownloadStateView.h"
#import "LGPImageOperator.h"
#import "ECRDownloadStateModel.h"

@interface ECRBookrackCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *bfName;// book or file

@property (weak, nonatomic) IBOutlet UIView *fileCoverView;// 文件夹封面view
@property (weak, nonatomic) IBOutlet UIView *bgBorderView;
@property (weak, nonatomic) IBOutlet UIButton *seBtn;
@property (weak, nonatomic) IBOutlet UIButton *didSelectedBtn;
/** 水印 */
@property (weak, nonatomic) IBOutlet UIImageView *fakeWatermark;
@property (weak, nonatomic) IBOutlet UIButton *rirghtTopSeBtn;

@end

@implementation ECRBookrackCollectionViewCell

- (void)setModel:(ECRBookrackModel *)model{
    _model = model;
    // 下载状态
    self.bdsView.model = model.dsModel;
    model.dsModel.dsView = self.bdsView;
    
    NSString *bfText = @"汉语读物";
    if (model.currentPlace == 1) {// 全部图书
        if (model.books == nil) {// 单本书
            if (model.bookName == nil) {
                bfText = @" \n";
            }else{
                bfText = [NSString stringWithFormat:@"%@\n",model.bookName];
            }
            //        bfText = [NSString stringWithFormat:@"%@\n",model.name];
            _fileCoverView.hidden = YES;
            self.icon.hidden = NO;
            
            if (model.iconUrl == nil) {
                self.icon.image = model.localFileCover; 
            }else{
                [self.icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]
                             placeholderImage:LGPlaceHolderImg];
                if (model.owendType == 0) {
                    // 如果是试读模型, 显示 "试读" image view
//                    self.fakeWatermark.hidden = NO;
                }else{
                }
            }
            
            self.icon.clipsToBounds = YES;
            self.seBtn.selected = model.isSelected;
            self.seBtn.hidden = !model.isEditState;
            self.didSelectedBtn.hidden = !model.isEditState;
            self.bdsView.hidden = model.isEditState;
            self.fakeWatermark.hidden = NO;
            self.fakeWatermark.image = [UIImage imageNamed:watermarkName(model.owendType)];
        }else{// 文件夹
            self.fakeWatermark.hidden = YES;
            bfText = [NSString stringWithFormat:@"%@\n",model.name];
            self.seBtn.hidden = YES;
            self.didSelectedBtn.hidden = YES;
            self.bdsView.hidden = YES;
            [self setFileCover];
        }
    }
    if (model.currentPlace == 2) {// 已购买
        if (model.alreadyBuyBooks.count == 0) {// 单本书
            if (model.bookName == nil) {
                bfText = @" \n";
            }else{
                bfText = [NSString stringWithFormat:@"%@\n",model.bookName];
            }
            //        bfText = [NSString stringWithFormat:@"%@\n",model.name];
            _fileCoverView.hidden = YES;
            self.icon.hidden = NO;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]
                         placeholderImage:LGPlaceHolderImg];
            self.icon.clipsToBounds = YES;
            
            self.seBtn.selected = model.isSelected;
            self.seBtn.hidden = !model.isEditState;
            self.didSelectedBtn.hidden = !model.isEditState;
            self.bdsView.hidden = model.isEditState;
            self.fakeWatermark.hidden = NO;
            self.fakeWatermark.image = [UIImage imageNamed:watermarkName(model.owendType)];
        }else{// 文件夹
            self.fakeWatermark.hidden = YES;
            bfText = [NSString stringWithFormat:@"%@\n",model.name];
            self.seBtn.hidden = YES;
            self.didSelectedBtn.hidden = YES;
            self.bdsView.hidden = YES;
            [self setFileCover];
        }
    }
    _bfName.text = bfText;

}

// MARK: 编辑状态下 模型的选中状态切换
- (IBAction)editStateDidClick:(UIButton *)sender {
    if (self.model.isSelected) {
        self.model.isSelected = NO;
    }else{
        self.model.isSelected = YES;
    }
    if ([self.delegate respondsToSelector:@selector(brCellBookEditDidClick:inx:model:)]) {
        [self.delegate brCellBookEditDidClick:self inx:self.inx model:self.model];
    }
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIColor *borderColor0 = [UIColor colorWithHexString:@"cccccc"];
    UIColor *borderColor1 = [UIColor colorWithHexString:@"e3e3e3"];
    _fileCoverView.layer.borderWidth = 1;
    _fileCoverView.layer.borderColor = borderColor0.CGColor;
    _bgBorderView.layer.borderWidth = 1;
    _bgBorderView.layer.borderColor = borderColor1.CGColor;
    
    self.icon.clipsToBounds = YES;
    self.icon.contentMode = UIViewContentModeScaleAspectFit;
    self.clipsToBounds = NO;
    
    self.seBtn.selected = YES;
    [self.seBtn setImage:[UIImage imageNamed:@"icon_selected_no"] forState:UIControlStateNormal];
    [self.seBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
}

- (void)setFileCover{
    _fileCoverView.hidden = NO;
    
    [_fileCoverView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    self.icon.hidden = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGFloat margin = 5;
    CGFloat imgX = margin;
    CGFloat imgY = margin;
    CGFloat imgW = (_fileCoverView.width - 3 * margin) / 2;
    CGFloat cHeight;
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        cHeight = 170;
    }else{
        if (Screen_Width < 414){
            cHeight = 100;
        }else{
            cHeight = 130;
        }
    }
    CGFloat imgH = (cHeight - 3 * margin) / 2;
    //    CGFloat imgH = (_fileCoverView.height - 3 * margin) / 2;
    
    if (self.model.currentPlace == 2) {// 已购买
        NSInteger count = (_model.alreadyBuyBooks.count > 4) ? 4 : _model.alreadyBuyBooks.count;
        //    NSLog(@"filecoverview.frame -- %@",NSStringFromCGRect(_fileCoverView.frame));
        for (NSInteger idx = 0; idx < count; idx++) {
            ECRBookrackModel *obj = _model.alreadyBuyBooks[idx];
            UIImageView *fileBookCover = [[UIImageView alloc] init];
            CGFloat ex_line_num = 0;
            if (idx > 1) {
                ex_line_num = 2;
                imgY = margin * 2 + imgH;
            }
            //        NSLog(@"idx%ld --Y: %f",idx,imgY);
            imgX = margin * (idx + 1 - ex_line_num) + imgW * (idx - ex_line_num);
            fileBookCover.frame = CGRectMake(imgX, imgY, imgW, imgH);
            fileBookCover.contentMode = UIViewContentModeScaleAspectFill;
            fileBookCover.clipsToBounds = YES;
//            NSLog(@"buyedbookname %@ -- iconurl %@",obj.bookName,obj.iconUrl);
            [fileBookCover sd_setImageWithURL:[NSURL URLWithString:obj.iconUrl] placeholderImage:LGPlaceHolderImg];
            [_fileCoverView addSubview:fileBookCover];
        }
    }else{
        NSInteger count = (_model.books.count > 4) ? 4 : _model.books.count;
        //    NSLog(@"filecoverview.frame -- %@",NSStringFromCGRect(_fileCoverView.frame));
        for (NSInteger idx = 0; idx < count; idx++) {
            ECRBookrackModel *obj = _model.books[idx];
            UIImageView *fileBookCover = [[UIImageView alloc] init];
            
            CGFloat ex_line_num = 0;
            if (idx > 1) {
                ex_line_num = 2;
                imgY = margin * 2 + imgH;
            }
            //        NSLog(@"idx%ld --Y: %f",idx,imgY);
            imgX = margin * (idx + 1 - ex_line_num) + imgW * (idx - ex_line_num);
            fileBookCover.frame = CGRectMake(imgX, imgY, imgW, imgH);
            fileBookCover.contentMode = UIViewContentModeScaleAspectFill;
            fileBookCover.clipsToBounds = YES;
//            NSLog(@"allbooksbookname %@ --iconurl %@",obj.bookName,obj.iconUrl);
            [fileBookCover sd_setImageWithURL:[NSURL URLWithString:obj.iconUrl] placeholderImage:LGPlaceHolderImg];
            [_fileCoverView addSubview:fileBookCover];
        }
    }

}

// 根据 拥有类型返回 水印icon name
NSString *watermarkName(BookModelOwnedType type){
    switch (type) {
        case BookModelOwnedTypeNotOwned:// 试读
            return @"icon_read_water_try";
            break;
        case BookModelOwnedTypeAccess:// 授权
            return @"icon_read_water_access";
            break;
        case BookModelOwnedTypeOwned:// 购买
            return @"icon_read_water_buyed";
            break;
            case BookModelOwnedTypeRent:
            return @"icon_read_water_rent";
        default:
            return @"";
            break;
    }
}

@end



