//
//  ECRBookInfoTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//
//static CGFloat catalogFont = 12;
static CGFloat cellBottomMargin = 15;
static CGFloat catalogLineSpace = 6;
static CGFloat marginTotal = 40;// 计算内容高度时使用
static NSString *recoCell = @"ECRBiRecoCollectionViewCell";

#import "ECRBookInfoTableViewCell.h"
#import "ECRBookInfoModel.h"
#import "NSString+TOPExtension.h"
#import "ECRBiRecoCollectionViewCell.h"
#import "ECRClassfyBookModel.h"
#import "ECRRecoBook.h"

@interface ECRBookInfoTableViewCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
ECRBiRecoCollectionViewCellDelegate
>
@property (weak, nonatomic) IBOutlet UIView *adreV;// 标题前面的rect
@property (weak, nonatomic) IBOutlet UIView *adreV1;
@property (weak, nonatomic) IBOutlet UIView *adreV2;
@property (weak, nonatomic) IBOutlet UIView *adreV3;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;

// 1
@property (weak, nonatomic) IBOutlet UILabel *t0;// 标题
@property (weak, nonatomic) IBOutlet UILabel *publishCom;// 出版社
@property (weak, nonatomic) IBOutlet UILabel *pubTime;// 出版时间
@property (weak, nonatomic) IBOutlet UILabel *isbn;// isbn
@property (weak, nonatomic) IBOutlet UILabel *eisbn;// eisbn
@property (weak, nonatomic) IBOutlet UILabel *fl;// 所属分类
@property (weak, nonatomic) IBOutlet UILabel *zt;// 主题
@property (weak, nonatomic) IBOutlet UILabel *dx;// 对象
//@property (weak, nonatomic) IBOutlet UILabel *dj;// 等级

// 2
@property (weak, nonatomic) IBOutlet UILabel *t1;
@property (weak, nonatomic) IBOutlet UILabel *nr;// 内容简介

// 3
@property (weak, nonatomic) IBOutlet UILabel *t2;// 目录
@property (strong,nonatomic) UILabel *catalogLabel;//
//@property (strong,nonatomic) WKWebView *catalogWk;
/** 目录展开按钮 */
@property (weak, nonatomic) IBOutlet UIButton *foldUnfold;
/** 内容简介展开按钮 */
@property (weak, nonatomic) IBOutlet UIButton *nr_foldUnfold;

// 4
@property (weak, nonatomic) IBOutlet UILabel *t4;
@property (weak, nonatomic) IBOutlet UICollectionView *recoView;// 推荐书籍
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *reciFlowLayout;
@property (strong,nonatomic) NSArray *recoArr;// 推荐书籍数组

@property (assign,nonatomic) CGFloat catalogFont;//
@property (assign,nonatomic) CGFloat rbcWidth;// 推荐书籍cell width
@property (assign,nonatomic) CGFloat rbcHeight;// 推荐书籍cell height

@end

@implementation ECRBookInfoTableViewCell

- (void)birecoBookClick:(ECRBiRecoCollectionViewCell *)cell model:(ECRRecoBook *)recoBook{
    // 收到 点击推荐书籍代理回调
    if ([self.delegate respondsToSelector:@selector(bitbrecoBookClick:model:)]) {
        [self.delegate bitbrecoBookClick:self model:recoBook];
    }
}

- (IBAction)foldUnfold:(UIButton *)sender {// 目录展开收起
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    self.model.caFold = sender.selected;
    if ([self.delegate respondsToSelector:@selector(bitbnrcaFold:)]) {
        [self.delegate bitbnrcaFold:self];
    }
}
- (IBAction)nrFoldUnfold:(UIButton *)sender {// 内容简介展开收起
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    self.model.nrFold = sender.selected;
    if ([self.delegate respondsToSelector:@selector(bitbnrcaFold:)]) {
        [self.delegate bitbnrcaFold:self];
    }
}

- (void)textDependsLauguage{
    
    [_t0 setText:[LGPChangeLanguage localizedStringForKey:@"图书信息"]];
    [_t1 setText:[LGPChangeLanguage localizedStringForKey:@"内容简介"]];
    [_t2 setText:[LGPChangeLanguage localizedStringForKey:@"目录"]];
    [_t4 setText:[LGPChangeLanguage localizedStringForKey:@"购买此商品的顾客还购买过"]];
    
    [_foldUnfold setTitle:[LGPChangeLanguage localizedStringForKey:@"展开"] forState:UIControlStateNormal];
    [_nr_foldUnfold setTitle:[LGPChangeLanguage localizedStringForKey:@"展开"] forState:UIControlStateNormal];
    [_foldUnfold setTitle:[LGPChangeLanguage localizedStringForKey:@"收起"] forState:UIControlStateSelected];
    [_nr_foldUnfold setTitle:[LGPChangeLanguage localizedStringForKey:@"收起"] forState:UIControlStateSelected];
    
    CGFloat fcHeight_0;// first cell height
    CGFloat font_1;
    CGFloat addtional_1;
    CGFloat margin_3;
    CGFloat margin_4;
    CGFloat cellHeight_4;
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        fcHeight_0 = 180;
        font_1 = 16;
        addtional_1 = 80;
        margin_3 = 20;
        margin_4 = 40;
        cellHeight_4 = self.rbcHeight + 96;
    }else{
        fcHeight_0 = 120;
        font_1 = 12;
        addtional_1 = 50;
        margin_3 = 8;
        margin_4 = 20;
        cellHeight_4 = self.rbcHeight + 52;
    }
    addtional_1 += 16;
//    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
//            addtional_1 += 16;
//    }
    
    // 立即计算frame
    [self setNeedsLayout];
    [self layoutIfNeeded];
    NSString *press_name;// 出版社名
    NSString *contentValidity;
    NSString *catalog;
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        press_name = _model.en_press;
        contentValidity = _model.en_contentValidity;
        catalog = _model.en_catalog;
    }else{
        press_name = _model.press;
        contentValidity = _model.contentValidity;
        catalog = _model.catalog;
    }
    switch (self.indx.row) {
        case 0:{
            // 图书信息
            NSString *press = [LGPChangeLanguage localizedStringForKey:@"出版社"];
            _publishCom.text = [NSString stringWithFormat:@"%@: %@",press,press_name];
            NSString *pressTime = [LGPChangeLanguage localizedStringForKey:@"出版时间"];
            _pubTime.text = [NSString stringWithFormat:@"%@: %@",pressTime,_model.publicationTime?_model.publicationTime:@""];
            _isbn.text = [NSString stringWithFormat:@"ISBN: %@",_model.isbn?_model.isbn:@""];
            _eisbn.text = [NSString stringWithFormat:@"EISBN: %@",_model.eisbn?_model.eisbn:@""];
            
            for (NSInteger i = 0; i < _model.classifyBook.count; i++) {
                ECRClassfyBookModel *classifyModel = _model.classifyBook[i];
                NSString *mcName;
                if ([LGPChangeLanguage currentLanguageIsEnglish]) {
                    mcName = classifyModel.en_classifyName;
                }else{
                    mcName = classifyModel.classifyName;
                }
                if (i == 0) {
                    NSString *ssfl = [LGPChangeLanguage localizedStringForKey:@"所属分类"];
                    NSString *dj = [LGPChangeLanguage localizedStringForKey:@"等级"];
                    // TDOO: en_classifyName
                    _fl.text = [NSString stringWithFormat:@"%@: %@>%@",ssfl,dj,mcName];
                }
                if (i == 1) {
                    NSString *ztString = [LGPChangeLanguage localizedStringForKey:@"主题"];
                    _zt.text = [NSString stringWithFormat:@"%@>%@",ztString,mcName];
                }
                if (i == 2) {
                    NSString *dxString = [LGPChangeLanguage localizedStringForKey:@"对象"];
                    _dx.text = [NSString stringWithFormat:@"%@>%@",dxString,mcName];
                }
            }
            
            _rHeight = fcHeight_0;//CGRectGetMaxY(_dx.frame) + cellBottomMargin;
            _rHeight1 = _rHeight;
        }
            break;
        case 1:{
            // 内容简介
            [self setNeedsLayout];
            [self layoutIfNeeded];
            _nr.text = contentValidity;
            if (contentValidity == nil || [contentValidity isEqualToString:@""]) {
                self.nr_foldUnfold.hidden = YES;
            }else{
                self.nr_foldUnfold.hidden = NO;
            }
            // 计算文字内容高度
            
            CGSize textSize = [contentValidity sizeOfTextWithMaxSize:CGSizeMake(Screen_Width - marginTotal, 0) font:[UIFont systemFontOfSize:font_1]];
            
            self.nr_foldUnfold.selected = self.model.nrFold;
            if (self.model.nrFold) {
                _nr.numberOfLines = 0;
                _rHeight = textSize.height + addtional_1;
            }else{
                _nr.numberOfLines = 2;
                _rHeight = self.defaultHeight_nr_ca;
            }
            _rHeight2 = _rHeight;
        }
            break;
        case 2:{
            if (catalog == nil || [catalog isEqualToString:@""]) {
                self.catalogLabel.text = catalog;
                self.foldUnfold.hidden = YES;
            }else{
                self.catalogLabel.attributedText = [catalog setLineSpaceWithSpace:catalogLineSpace];
                self.foldUnfold.hidden = NO;
            }
            [self.contentView addSubview:self.catalogLabel];
            [self.catalogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_t2.mas_bottom).offset(margin_3);
                make.left.equalTo(_t2.mas_left);
                make.right.equalTo(self.contentView.mas_right).offset(-10);
                
            }];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            
            self.foldUnfold.selected = self.model.caFold;
            if (self.model.caFold) {
                _rHeight = CGRectGetMaxY(self.catalogLabel.frame) + cellBottomMargin + margin_4;
            }else{
                _rHeight = self.ca_default_height;
            }
            _rHeight3 = _rHeight;
        }
            break;
        case 3:{
            // 推荐书籍
            self.recoArr = _model.recommend;
            
            //            _rHeight = CGRectGetMaxY(_recoView.frame) + cellBottomMargin;
            _rHeight = cellHeight_4;
            _rHeight4 = _rHeight;
        }
            break;
    }
}

- (void)setRecoArr:(NSArray *)recoArr{
    _recoArr = recoArr;
    [self.recoView reloadData];
}

- (void)setModel:(ECRBookInfoModel *)model{
    _model = model;
    [self textDependsLauguage];
    
}

+ (NSString *)gainReuseID:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        return @"ECRBookInfoTableViewCell1";
            break;
        case 1:
        return @"ECRBookInfoTableViewCell2";
            break;
        case 2:
        return @"ECRBookInfoTableViewCell3";
            break;
        case 3:
        return @"ECRBookInfoTableViewCell4";
            break;
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _reciFlowLayout.itemSize = CGSizeMake(self.rbcWidth, self.rbcHeight);
    
    _reciFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    _reciFlowLayout.minimumInteritemSpacing = 20;
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        _reciFlowLayout.minimumLineSpacing = 42;// item 横向间距
    }else{
        _reciFlowLayout.minimumLineSpacing = 8;// item 横向间距
    }
    
    [_recoView registerNib:[UINib nibWithNibName:recoCell bundle:nil] forCellWithReuseIdentifier:recoCell];
    _recoView.dataSource = self;
    _recoView.delegate = self;
    _adreV.backgroundColor = [LGSkinSwitchManager currentThemeColor];
    _adreV1.backgroundColor = [LGSkinSwitchManager currentThemeColor];
    _adreV2.backgroundColor = [LGSkinSwitchManager currentThemeColor];
    _adreV3.backgroundColor = [LGSkinSwitchManager currentThemeColor];
}

#pragma mark - collcetion view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECRBiRecoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recoCell forIndexPath:indexPath];
    ECRRecoBook *model = self.recoArr[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (UILabel *)catalogLabel{
    if (_catalogLabel == nil) {
        _catalogLabel = [[UILabel alloc] init];
        _catalogLabel.numberOfLines = 0;
        _catalogLabel.font = [UIFont systemFontOfSize:self.catalogFont];
        _catalogLabel.textColor = [UIColor cm_blackColor_333333_1];
    }
    return _catalogLabel;
}

- (CGFloat)catalogFont{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 16;
    }else{
        return 12;
    }
}

// iPad 适配： 推荐书籍 item size
- (CGFloat)rbcWidth{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 87;
    }else{
        return 100;
    }
}
- (CGFloat)rbcHeight{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 163;
    }else{
        return 200;
    }
}
- (CGFloat)defaultHeight_nr_ca{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return 120;
    }else{
        return 90;
    }
}

- (CGFloat)ca_default_height{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return 115;
    }else{
        return 82;
    }
}

@end


