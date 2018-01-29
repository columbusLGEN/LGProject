//
//  ECRSortTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

static CGFloat qbWidth = 74;
static CGFloat qbHeight = 30;
//static CGFloat margin  = 20;

#import "ECRSortTableViewCell.h"
#import "ECRClassSortModel.h"
#import "ECRMoreRowModel.h"

// "全部" 内边距
//#define abCorR 12
//#define abTBInsets 3
#define abLRInsets 12
#define abEdgeInsets UIEdgeInsetsMake(3, abLRInsets, 3, abLRInsets)

@interface ECRSortTableViewCell ()<
UIScrollViewDelegate
>
@property (strong,nonatomic) NSArray *buttons;
@property (strong,nonatomic) UIScrollView *cdbSrlView;
@property (strong,nonatomic) UIView *line;//

@property (assign,nonatomic) CGFloat totalW;
@property (assign,nonatomic) CGFloat abWidth;// "全部"的宽度
@property (assign,nonatomic) CGFloat margin;
@end

@implementation ECRSortTableViewCell

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
//    self.line.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];// 加到header上
}
- (void)setModel:(ECRMoreRowModel *)model{
    _model = model;
    UIColor *btnNoColor = [UIColor cm_blackColor_333333_1];
    UIColor *btnSeColor = [LGSkinSwitchManager currentThemeColor];
    CGFloat btnTxtSize  = 16;
    
    if (self.cdbSrlView.subviews.count) {
        for (UIView *view in self.cdbSrlView.subviews) {
            [view removeFromSuperview];
        }
    }
    _totalW = 0;
    NSMutableArray *buttonArrM = [NSMutableArray array];
    for (NSInteger i = 0; i < model.classArray.count; ++i) {
        ECRClassSortModel *classModel = model.classArray[i];
//        NSLog(@"model.name -- %@",classModel.btnTitle);
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:classModel.btnTitle
                forState:UIControlStateNormal];
        [button sizeToFit];// 计算button宽高
        if (i == 0) {
            _abWidth = button.width;
        }
        
        if (i == 0) {
            // subviews: “全部”， cdbSrlView, line(只有最后一行有)
            if (self.subviews.count > 2) {// 数据源中先赋值model，在赋值indexPath 这里就不需要 判断有2个还是3个子view了
                // 防止重复添加全部
            }else{
                [self addSubview:button];// MARK: 全部
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_left).offset(self.margin);
                    make.centerY.equalTo(self.contentView.mas_centerY);
                    make.width.equalTo(@(qbWidth));
                    make.height.equalTo(@(qbHeight));
                }];
            }
        }else{
            [self.cdbSrlView addSubview:button];
            if (i == 1) {
                // MAKR: scroll view 上的第一个button
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.cdbSrlView.mas_left);
                    make.centerY.equalTo(self.cdbSrlView.mas_centerY);
                }];
                
            }else{
                UIButton *last = buttonArrM[i - 1];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(last.mas_right).offset(self.margin);
                    make.centerY.equalTo(self.cdbSrlView.mas_centerY);
                }];
            }
        }
        
        
        if (_bookListType) {
            if (classModel.classType.integerValue == _bookListType) {
                classModel.lg_isSelected = YES;
            }
        }
        
        [button setTitleColor:btnNoColor   forState:UIControlStateNormal];
        [button setTitle:classModel.btnTitle             forState:UIControlStateSelected];
        [button setTitleColor:btnSeColor                 forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:btnTxtSize];
        button.tag             = i;
        button.selected        = classModel.lg_isSelected;
        
        
        if (i == 0) {
            // MARK: “全部”
            button.layer.cornerRadius  = button.height * 0.5 - 2;//abCorR;
            button.layer.borderColor   = [UIColor colorWithHexString:@"e3e3e3"].CGColor;
            button.layer.borderWidth   = 1;
            button.layer.masksToBounds = YES;
            [button setContentEdgeInsets:abEdgeInsets];
            [button setTitleColor:btnSeColor   forState:UIControlStateNormal];
            [button setTitleColor:btnSeColor   forState:UIControlStateSelected];
        }else{
            _totalW += (self.margin + button.bounds.size.width);
        }
        
        [buttonArrM addObject:button];
        [button     addTarget:self
                       action:@selector(testClick:)
             forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self.cdbSrlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(_abWidth + self.margin * 2 + abLRInsets * 2 +20);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
//    NSLog(@"totalw -- %f",_totalW);
    [self.cdbSrlView setContentSize:CGSizeMake(_totalW, 0)];
    
}


- (void)testClick:(UIButton *)sender{
    // MARK: 点击按钮时,切换模型的选中状态
    ECRClassSortModel *classModel = _model.classArray[sender.tag];
    if (classModel.lg_isSelected) {
        classModel.lg_isSelected = NO;
    }else{
        classModel.lg_isSelected = YES;
    }

    [_model.classArray enumerateObjectsUsingBlock:^(ECRClassSortModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@",obj);//.lg_isSelected);
        if (idx == 0) {
            // "全部"永远选中
        }else{
            if (classModel == obj) {
                // 点击的选中状态不变
                self.rowSelectModelId = obj.id;
            }else{
                // 未点击的,取消选中
                obj.lg_isSelected = NO;
            }
        }
    }];
    // MARK: 点击同一级button, 其余button 设置为未选中状态
    if ([self.delegate respondsToSelector:@selector(stbCell:classModel:indexPath:)]) {
        [self.delegate stbCell:self classModel:classModel indexPath:self.indexPath];
    }
//    if ([self.delegate respondsToSelector:@selector(stbCell:classModel:indexPath:rowSelectedModelId:)]) {
//        [self.delegate stbCell:self classModel:classModel indexPath:self.indexPath rowSelectedModelId:self.rowSelectModelId];
//    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加 scroll view
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.cdbSrlView];
        
        // 筛选条件 浅色背景色
        UIColor *color_fbf7ff = [LGSkinSwitchManager currentThemeFadeColor];
        self.cdbSrlView.backgroundColor = color_fbf7ff;
        self.contentView.backgroundColor = color_fbf7ff;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
// --

// MARK: UI group
- (UIScrollView *)cdbSrlView{
    if (_cdbSrlView == nil) {
        _cdbSrlView = [[UIScrollView alloc] init];
        _cdbSrlView.delegate = self;
        _cdbSrlView.backgroundColor = [UIColor whiteColor];
        _totalW = self.margin;
    }
    return _cdbSrlView;
}
- (UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc] init];
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@1);
        }];
    }
    return _line;
}

- (CGFloat)margin{
    // 间距，根据屏幕适配
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 16;
    }else{
        return 5;
    }
}

@end
