//
//  DCWriteQuestionViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCWriteQuestionViewController.h"
#import "UITextView+Extension.h"
#import "EDJSearchTagCollectionViewFlowLayout.h"
#import "EDJSearchTagModel.h"
#import "EDJSearchTagHistoryCell.h"
#import "EDJSearchTagHotCell.h"

#import "EDJSearchTagHeader.h"
#import "EDJSearchTagHeaderModel.h"
#import "DJDiscoveryNetworkManager.h"
#import "UITextView+Extension.h"

#import "DJDsSearchTagView.h"
#import "LGRecordButtonLoader.h"

@interface DCWriteQuestionViewController ()<
UITextViewDelegate>
@property (weak,nonatomic) UITextView *textView;
@property (strong,nonatomic) NSArray *headerModels;
@property (strong,nonatomic) NSMutableArray *selectTags;
@property (strong,nonatomic) NSMutableArray *netTags;
//@property (strong,nonatomic) NSArray *AllTags;
@property (strong,nonatomic) UILabel *wordLimitLable;

@property (strong,nonatomic) DJDsSearchTagView *labelView;
@property (strong,nonatomic) LGRecordButtonLoader *rbLoader;

@end

@implementation DCWriteQuestionViewController{
    CGFloat selectHeight;
    CGFloat allHeight;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    _selectTags = NSMutableArray.new;
    
    /// 获取标签
    [DJDiscoveryNetworkManager.sharedInstance frontLabel_selectWithSuccess:^(id responseObj) {
        NSArray *array = responseObj;
        if (array == nil || array.count == 0) {
            return;
        }else{
            NSMutableArray *arrmu = NSMutableArray.new;
            for (NSInteger i = 0; i < array.count; i++) {
                EDJSearchTagModel *model = [EDJSearchTagModel mj_objectWithKeyValues:array[i]];
                model.oriIndex = i;
                [arrmu addObject:model];
            }
            _netTags = arrmu;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                /// 全部标签
                [self setupAllLabelButton];
                [self.labelView hideSelectLabelViewWithAllHeight:allHeight];
            }];
        }
        
    } failure:^(id failureObj) {
        [self presentFailureTips:@"网络异常"];
    }];
}

- (void)allLabelClick:(UIButton *)button{
    [self.view endEditing:YES];
    NSInteger index = button.tag;
    EDJSearchTagModel *allModel = _netTags[index];
    
    if (_selectTags.count >= 3) {
        [self presentFailureTips:@"最多添加三个"];
        return;
    }
    [_selectTags addObject:allModel];
    [_netTags removeObject:allModel];
    
    [self setupAllLabelButton];/// 需要先执行
    [self setupSelectLabelButton];
    
}

- (void)selectLabelClick:(UIButton *)button{
    [self.view endEditing:YES];
    NSInteger index = button.tag;
    EDJSearchTagModel *alreadySelectModel = _selectTags[index];
    
    [_selectTags removeObject:alreadySelectModel];
    [_netTags addObject:alreadySelectModel];
    
    /// 根据oriIndex 重新排序，保证标签回到原来的位置
    for (NSInteger i = 0; i < _netTags.count; i++) {
        for (NSInteger j = 0; j < _netTags.count - 1 - i; j++) {
            EDJSearchTagModel *tag_j = _netTags[j];
            EDJSearchTagModel *tag_j_next = _netTags[j+1];
            if (tag_j.oriIndex > tag_j_next.oriIndex) {
                [_netTags exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
    [self setupAllLabelButton];
    [self setupSelectLabelButton];
}

/** 设置全部标签 */
- (void)setupAllLabelButton{
    NSMutableArray *buttonArray1 = [NSMutableArray array];
    [_netTags enumerateObjectsUsingBlock:^(EDJSearchTagModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self.rbLoader buttonWithText:obj.name frame:CGRectZero];
        button.tag = idx;
        [buttonArray1 addObject:button];
    }];
    [self.rbLoader addButtonToContainerView:self.labelView.hisConView viewController:self array:buttonArray1 action:@selector(allLabelClick:) heightBlock:^(CGFloat height) {
        allHeight = height;
    }];
}
/** 设置已添加标签 */
- (void)setupSelectLabelButton{
    
    NSMutableArray *buttonArray1 = [NSMutableArray array];
    [self.selectTags enumerateObjectsUsingBlock:^(EDJSearchTagModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self.rbLoader hotButtonWithText:obj.name frame:CGRectZero];
        button.tag = idx;
        [buttonArray1 addObject:button];
    }];
    [self.rbLoader addButtonToContainerView:self.labelView.conHot viewController:self array:buttonArray1 action:@selector(selectLabelClick:) heightBlock:^(CGFloat height) {
        selectHeight = height;
    }];
    
    if (self.selectTags.count == 0) {
        /// 不展示 已添加的标签 这一项
        [self.labelView showFirstItemWith:NO selectHeight:selectHeight allHeight:allHeight];
    }else{
        /// 显示 它
        [self.labelView showFirstItemWith:YES selectHeight:selectHeight allHeight:allHeight];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    EDJSearchTagModel *model;
    if (indexPath.section == 0) {
        model = _selectTags[indexPath.item];
        [_selectTags removeObject:model];
        [_netTags addObject:model];
        
        /// 根据oriIndex 重新排序，保证标签回到原来的位置
        for (NSInteger i = 0; i < _netTags.count; i++) {
            for (NSInteger j = 0; j < _netTags.count - 1 - i; j++) {
                EDJSearchTagModel *tag_j = _netTags[j];
                EDJSearchTagModel *tag_j_next = _netTags[j+1];
                if (tag_j.oriIndex > tag_j_next.oriIndex) {
                    [_netTags exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
            }
        }
        
    }
    if (indexPath.section == 1) {
        model = _netTags[indexPath.item];
        if (_selectTags.count >= 3) {
            [self presentFailureTips:@"最多添加三个"];
            return;
        }
        [_selectTags addObject:model];
        [_netTags removeObject:model];
        
    }
    
}

#pragma mark - target
- (void)commitQuestion{
    
    [self.view endEditing:YES];
    
    NSMutableArray *tag_ids = NSMutableArray.new;
    for (NSInteger i = 0; i < _selectTags.count; i++) {
        EDJSearchTagModel *model = _selectTags[i];
        [tag_ids addObject:@(model.seqid)];
    }
    
    if ([_textView.text isEqualToString:@""] || _textView.text == nil) {
        [self presentMessageTips:@"请输入您的问题"];
        return;
    }
    
    if (tag_ids.count == 0) {
        [self presentFailureTips:@"请至少选择一个标签"];
        return;
    }
    
    NSString *label = [tag_ids componentsJoinedByString:@","];
    [DJDiscoveryNetworkManager.sharedInstance frontQuestionanswer_addWithQuestion:_textView.text label:label success:^(id responseObj) {
        [self presentSuccessTips:uploadNeedsCheckString];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            [self lg_dismissViewController];
        });
    } failure:^(id failureObj) {
        [self presentSuccessTips:@"提交失败，请稍后重试"];
    }];
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > limitTextLength.integerValue) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, limitTextLength.integerValue)];
        [textView.undoManager removeAllActions];
        [textView becomeFirstResponder];
        self.wordLimitLable.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)textView.text.length, limitTextLength];
        return;
    }
    self.wordLimitLable.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)textView.text.length, limitTextLength];
}


- (void)configUI{
    self.title = @"提问";
    
    UITextView *textView = [UITextView new];
    textView.delegate = self;
    
    //    UIButton *commit = [UIButton new];
    //    UIButton *cancel = [UIButton new];
    
    [self.view addSubview:textView];
    
    [textView lg_setLimitTextLabelWithLength:limitTextLength superView:self.view label:self.wordLimitLable];
    
    //    [self.view addSubview:commit];
    //    [self.view addSubview:cancel];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        if (@available(iOS 11.0, *)) {
        //            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(9);
        //        }else{
        //            make.top.equalTo(self.view.mas_topMargin).offset(9);
        //        }
        make.top.equalTo(self.view.mas_top).offset(kNavHeight + 9);
        make.left.equalTo(self.view.mas_left).offset(marginTwelve);
        make.right.equalTo(self.view.mas_right).offset(-marginTwelve);
        make.height.mas_equalTo(200);
    }];
    
    //    [commit mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(textView.mas_bottom).offset(57);
    //        make.height.mas_equalTo(38);
    //        make.left.equalTo(self.view.mas_left).offset(50);
    //        make.right.equalTo(self.view.mas_right).offset(-50);
    //    }];
    //    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(commit.mas_bottom).offset(24);
    //        make.left.equalTo(commit.mas_left);
    //        make.height.equalTo(commit.mas_height);
    //        make.width.equalTo(commit.mas_width);
    //    }];
    
    /// 样式
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor EDJGrayscale_33];
    [textView cutBorderWithBorderWidth:0.5 borderColor:[UIColor EDJColor_E0B5B1] cornerRadius:0];
    [textView lg_setplaceHolderTextWithText:@"请写下您的问题" textColor:[UIColor EDJColor_E0B5B1] font:15];
    
    //    [commit setTitle:@"提交" forState:UIControlStateNormal];
    //    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [commit setBackgroundColor:[UIColor EDJMainColor]];
    //    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    //    [cancel setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    //    [cancel setBackgroundColor:[UIColor whiteColor]];
    
    
    _textView = textView;
    
    //    _commit = commit;
    //    _cancel = cancel;
    
    [self.view addSubview:self.labelView];
    [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(marginTwenty);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _headerModels = [EDJSearchTagHeaderModel loadLocalPlistWithPlistName:@"DCWriteQuestionTagHead"];
//    [self.collectionView reloadData];
    
    
}

- (void)setNavLeftBackItem{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(lg_dismissViewController)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitQuestion)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)lg_dismissViewController{
    [self.view endEditing:YES];
    [super lg_dismissViewController];
}

- (UILabel *)wordLimitLable{
    if (!_wordLimitLable) {
        _wordLimitLable = UILabel.new;
    }
    return _wordLimitLable;
}

- (DJDsSearchTagView *)labelView{
    if (!_labelView) {
        _labelView = DJDsSearchTagView.new;
        _labelView.removeHis.hidden = YES;
        _labelView.firstTitle = @"已添加的标签";
        _labelView.secondTitle = @"全部标签";
        NSInteger font = 17;
        _labelView.fontOfFirstTitle = font;
        _labelView.fontOfSecondTitle = font;
        UIColor *textColor = UIColor.EDJGrayscale_33;
        _labelView.textColorFirstTitle = textColor;
        _labelView.textColorSecondTitle = textColor;
        
        UILabel *subTitle = UILabel.new;
        subTitle.tag = -1;/// 防止更新标签是被删掉
        subTitle.text = @"最多添加3个";
        subTitle.textColor = UIColor.EDJColor_c2c0c0;
        subTitle.font = [UIFont systemFontOfSize:13];
        _labelView.subTitleOfFirstItem = subTitle;
        
    }
    return _labelView;
}

- (LGRecordButtonLoader *)rbLoader{
    if (!_rbLoader) {
        _rbLoader = [[LGRecordButtonLoader alloc] init];
    }
    return _rbLoader;
}

@end
