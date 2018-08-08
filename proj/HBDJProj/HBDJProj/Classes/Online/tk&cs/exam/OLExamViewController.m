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

/// 记录用户开始答题的时间点
@property (assign,nonatomic) NSTimeInterval beginTimeInterval;

@end

@implementation OLExamViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    [self.view addSubview:self.collectionView];
    
    OLExamViewBottomBar *bottomBar = [OLExamViewBottomBar examViewBottomBar];
    _bottomBar = bottomBar;
    bottomBar.delegate = self;
    /// TODO: 回看状态
//    bottomBar.backLook = self.backLook;
    bottomBar.frame = CGRectMake(0, self.view.height - bottomBarHeight, kScreenWidth, bottomBarHeight);
    bottomBar.alreadyCount = 1;
    [self.view addSubview:bottomBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnQuestion:) name:OLExamTurnQuestionNotification object:nil];
    
    [self getNetData];
}

- (void)getNetData{
    
    /// 请求一套题
    [DJOnlineNetorkManager.sharedInstance frontSubjects_selectTitleDetailWithPortName:_portName titleid:_model.seqid offset:0 success:^(id responseObj) {
        
        /// MARK: 记录获取到题目是的时间
        _beginTimeInterval = [self currentTimeinterval];
        
        NSArray *array = responseObj;
        BOOL arrIsNil = (array == nil || array.count == 0);
        if (arrIsNil) {
            return;
        }else{
            NSMutableArray *arrMu = [NSMutableArray new];
            for (NSInteger i = 0; i < array.count; i++) {
                OLExamSingleModel *singleModel = [OLExamSingleModel mj_objectWithKeyValues:array[i]];
                singleModel.testPaper = self.model;
                /// 添加题干前的数字序号
                singleModel.subject = [[NSString stringWithFormat:@"%ld.",i + 1] stringByAppendingString:singleModel.subject];
                
                if (i == 0) {
                    singleModel.first = YES;
                }
                if (i == array.count - 1) {
                    singleModel.last = YES;
                }
                /// TODO: 回看
//                model.backLook = self.backLook;
                singleModel.index = i;
                [singleModel addSubjectModel];
                [arrMu addObject:singleModel];
            }
            
            self.dataArray = arrMu.copy;
            _bottomBar.totalCount = arrMu.count;
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
            
            /// TODO: 回看重构
            
            /// MARK: 提交答案
            
            /// 计算用户正确题数，错误题数，正确率
            self.model.rightCount = 0;
            for (NSInteger i = 0; i < self.dataArray.count; i++) {
                OLExamSingleModel *singleModel = self.dataArray[i];
                if (singleModel.isright) {
                    self.model.rightCount++;
                }
            }
            NSLog(@"rightCOUNT: %ld",self.model.rightCount);
            NSLog(@"wrongCOUNT: %ld",self.model.wrongCount);
            NSLog(@"总数: %ld",self.model.subcount);
            
            /// 计算用户耗时
            [self countUserTimeConsumed];
            
            /// 拼接需要提交的数据
            NSString *testid = [NSString stringWithFormat:@"%ld",self.model.seqid];
            
            NSMutableArray *answers = NSMutableArray.new;
            for (NSInteger i = 0; i < self.dataArray.count; i++) {
                OLExamSingleModel *singleModel = self.dataArray[i];
                NSDictionary *dict = @{@"subjectid":singleModel.subjectid,
                                       @"answer":singleModel.answer?singleModel.answer:@"",
                                       @"isright":[NSString stringWithFormat:@"%d",singleModel.isright],
                                       @"testid":testid};
                [answers addObject:dict];
            }
            
            NSDictionary *dict = @{@"testid":testid,
                                   @"timeused":[NSString stringWithFormat:@"%f",self.model.timeused_timeInterval],
                                   @"answers":answers.copy};
            
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
//            NSString *json = [NSString.alloc initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSLog(@"需要提交的测试结果json: %@",json);
            
            OLTestResultViewController *trvc = (OLTestResultViewController *)[self lgInstantiateViewControllerWithStoryboardName:OnlineStoryboardName controllerId:@"OLTestResultViewController"];
            trvc.pushWay = LGBaseViewControllerPushWayModal;
            trvc.model = self.model;
            LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:trvc];
            
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
//            [DJOnlineNetorkManager.sharedInstance frontSubjects_addTestWithPJSONDict:dict success:^(id responseObj) {
//                self.model.teststatus = 1;
//
//                /// 退出到试题列表控制器 & 展示用户答题正确率页面
//                /**
//                    将用户的答题数，正确率等信息，记录在 OLTkcsModel 模型中
//                 */
//
//                OLTestResultViewController *trvc = (OLTestResultViewController *)[self lgInstantiateViewControllerWithStoryboardName:OnlineStoryboardName controllerId:@"OLTestResultViewController"];
//                trvc.pushWay = LGBaseViewControllerPushWayModal;
//                trvc.model = self.model;
//                LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:trvc];
//
//                [self.navigationController presentViewController:nav animated:YES completion:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//
//            } failure:^(id failureObj) {
//                [self presentFailureTips:@"提交失败，请检查网络后重试"];
//            }];

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

- (NSTimeInterval)currentTimeinterval{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    return [date timeIntervalSince1970];
}

- (void)countUserTimeConsumed{
    NSTimeInterval endTimeinterval = [self currentTimeinterval];
    NSTimeInterval timeConsumed = floor(endTimeinterval - _beginTimeInterval);
    self.model.timeused_timeInterval = timeConsumed;
}

@end
