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

@interface DCWriteQuestionViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (weak,nonatomic) UITextView *textView;
//@property (weak,nonatomic) UIButton *commit;
//@property (weak,nonatomic) UIButton *cancel;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) EDJSearchTagCollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) NSArray *headerModels;
@property (strong,nonatomic) NSMutableArray *selectTags;
@property (strong,nonatomic) NSMutableArray *netTags;
//@property (strong,nonatomic) NSArray *AllTags;

@end

@implementation DCWriteQuestionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    [_commit cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_commit.height / 2];
//    [_cancel cutBorderWithBorderWidth:1 borderColor:[UIColor EDJColor_E0B5B1] cornerRadius:_cancel.height / 2];
    
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
//            _AllTags = arrmu.copy;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self presentFailureTips:@"网络异常"];
    }];
}

#pragma mark - data source & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _headerModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _selectTags.count;
    }
    if (section == 1) {
        return _netTags.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EDJSearchTagModel *model;
    if (indexPath.section == 0) {
        model = _selectTags[indexPath.item];
    }
    if (indexPath.section == 1) {
        model = _netTags[indexPath.item];
    }
    EDJSearchTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[EDJSearchTagCollectionViewCell cellIdWithIndexPath:indexPath] forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    EDJSearchTagHeaderModel *headerModel = _headerModels[indexPath.section];
    EDJSearchTagHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderID forIndexPath:indexPath];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(tapHeader:)];
    header.userInteractionEnabled = YES;
    [header addGestureRecognizer:tap];
    
    header.model = headerModel;
    return header;
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
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectionView reloadData];
    }];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 40);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)tapHeader:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark - target
- (void)commitQuestion{
    
    [self.view endEditing:YES];
    
    NSMutableArray *tag_ids = NSMutableArray.new;
    for (NSInteger i = 0; i < _selectTags.count; i++) {
        EDJSearchTagModel *model = _selectTags[i];
        [tag_ids addObject:@(model.seqid)];
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

- (void)configUI{
    self.title = @"提问";
    
    UITextView *textView = [UITextView new];
    
    //    UIButton *commit = [UIButton new];
    //    UIButton *cancel = [UIButton new];
    
    [self.view addSubview:textView];
    
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
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(marginTwenty);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _headerModels = [EDJSearchTagHeaderModel loadLocalPlistWithPlistName:@"DCWriteQuestionTagHead"];
    [self.collectionView reloadData];
    
}

- (void)setNavLeftBackItem{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(lg_dismissViewController)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitQuestion)];
    self.navigationItem.rightBarButtonItem = right;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:reuseHeaderID bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:reuseHeaderID];
        
        //        [_collectionView registerNib:[UINib nibWithNibName:reuseID bundle:nil] forCellWithReuseIdentifier:reuseID];
        [_collectionView registerNib:[UINib nibWithNibName:hotCell bundle:nil] forCellWithReuseIdentifier:hotCell];
        [_collectionView registerNib:[UINib nibWithNibName:historyCell bundle:nil]
          forCellWithReuseIdentifier:historyCell];
        
    }
    return _collectionView;
}
- (EDJSearchTagCollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [EDJSearchTagCollectionViewFlowLayout new];
    }
    return _flowLayout;
}



@end
