//
//  OLExamViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamViewController.h"
#import "OLExamSingleViewController.h"
#import "OLExamViewBottomBar.h"
#import "OLExamCollectionViewCell.h"
#import "OLExamSingleModel.h"
#import "OLExamSingleFooterView.h"
#import "OLTestResultViewController.h"
#import "OLTkcsModel.h"
#import "DJOnlineNetorkManager.h"

static CGFloat bottomBarHeight = 60;
static NSString * const cellID = @"OLExamCollectionViewCell";

@interface OLExamViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
OLExamViewBottomBarDelegate
>

@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (weak,nonatomic) OLExamViewBottomBar *bottomBar;

@property (strong,nonatomic) NSArray *dataArray;

@property (assign,nonatomic) NSInteger willIndex;
@property (assign,nonatomic) NSInteger didEndIndex;

@end

@implementation OLExamViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    NSLog(@"题目控制器viewdidload");
}

- (void)setModel:(OLTkcsModel *)model{
    _model = model;
    
}

- (void)configUI{
    
    [self.view addSubview:self.collectionView];
    
    OLExamViewBottomBar *bottomBar = [OLExamViewBottomBar examViewBottomBar];
    _bottomBar = bottomBar;
    bottomBar.delegate = self;
    bottomBar.backLook = self.backLook;
    bottomBar.frame = CGRectMake(0, self.view.height - bottomBarHeight, kScreenWidth, bottomBarHeight);
    bottomBar.alreadyCount = 1;
    bottomBar.totalCount = self.dataArray.count;
    [self.view addSubview:bottomBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnQuestion:) name:OLExamTurnQuestionNotification object:nil];
    
    [self getNetData];
}

- (void)getNetData{
    
    [DJOnlineNetorkManager.sharedInstance frontSubjects_selectTitleDetailWithPortName:_portName titleid:_model.seqid offset:0 success:^(id responseObj) {
        
        NSArray *array = responseObj;
        BOOL arrIsNil = (array == nil || array.count == 0);
        if (arrIsNil) {
            return;
        }else{
            NSMutableArray *arrMu = [NSMutableArray new];
            for (NSInteger i = 0; i < array.count; i++) {
                OLExamSingleModel *model = [OLExamSingleModel mj_objectWithKeyValues:array[i]];
                model.backLook = self.backLook;
                model.index = i;
                model.questioTotalCount = array.count;
                [arrMu addObject:model];
            }
            
            self.dataArray = arrMu.copy;
            [self.collectionView reloadData];
            
            
        }
        
    } failure:^(id failureObj) {
        
    }];
}

#pragma mark - bottom bar delegate
- (void)examBottomBarClose:(OLExamViewBottomBar *)bottomBar{
    [self lg_dismissViewController];
}

#pragma mark - notification
- (void)turnQuestion:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger index = [userInfo[OLExamTurnQuestionNotificationIndexKey] integerValue];
    NSInteger turnTo = [userInfo[OLExamTurnQuestionNotificationTurnToKey] integerValue];
    if (turnTo == ExamTurnToLast) {
        if (index == 0 || index == NSNotFound) {
            return;
        }else{
            index--;
        }
    }else{
        index++;
        if (index == self.dataArray.count) {
            /// MARK: 交卷 提交成绩
            
            /// TODO: 将答题情况数据保存在本地
            if (!self.backLook) {                
                OLTestResultViewController *trvc = (OLTestResultViewController *)[self lgInstantiateViewControllerWithStoryboardName:OnlineStoryboardName controllerId:@"OLTestResultViewController"];
                trvc.pushWay = LGBaseViewControllerPushWayModal;
                LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:trvc];
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            return;
        }else{
        }
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - collection view data source & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OLExamSingleModel *model = self.dataArray[indexPath.row];
    OLExamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.willIndex = indexPath.item;
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.didEndIndex = indexPath.item;
    [self willDisplayCellIndex:self.willIndex didEndIndex:self.didEndIndex];
}
- (void)willDisplayCellIndex:(NSInteger)willIndex didEndIndex:(NSInteger)didEndIndex{
    if (willIndex == didEndIndex) {
        /// 维持在当前题目
    }else{
        if (willIndex < didEndIndex) {
            /// 下一题
        }
        if (willIndex > didEndIndex) {
            /// 上一题
        }
        _bottomBar.alreadyCount = willIndex + 1;
    }
}

#pragma mark - getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout.itemSize = CGSizeMake(kScreenWidth, self.itemHeight);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGRect frame = CGRectMake(0, kNavHeight, kScreenWidth, self.itemHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[OLExamCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

- (CGFloat)itemHeight{
    return kScreenHeight - kNavHeight - bottomBarHeight;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
