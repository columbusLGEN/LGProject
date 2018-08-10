//
//  OLExamViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamViewController.h"
#import "OLExamViewBottomBar.h"
#import "OLExamCollectionViewCell.h"
#import "OLExamSingleModel.h"
#import "OLExamSingleFooterView.h"
#import "OLTestResultViewController.h"
#import "OLTkcsModel.h"
#import "DJOnlineNetorkManager.h"
#import "LGCountTimeLabel.h"
#import "LGFilePathManager.h"

static CGFloat bottomBarHeight = 60;
static NSString * const cellID = @"OLExamCollectionViewCell";

static NSString * const timeused_key = @"timeused";
static NSString * const index_key = @"currIndex";
static NSString * const userSelectOptions_key = @"userSelectOptions_key";

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

@property (weak,nonatomic) LGCountTimeLabel *ctlabel;

/** 本地答题记录 */
@property (strong,nonatomic) NSDictionary *localRecord;

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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_tkcsType == OLTkcsTypecs) {
        
        /// 获取用户已经做了的题，所选的选项
        NSMutableArray *arrmu = NSMutableArray.new;
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            OLExamSingleModel *singleModel = self.dataArray[i];
            if (singleModel.userRecord) {
                [arrmu addObject:singleModel.userRecord];
            }
        }
        NSArray *array = arrmu.copy;
        
        /// 用户退出测试页面，记录用户耗时 & 用户答题index
        NSDictionary *dict = @{timeused_key:@(_ctlabel.sec),
                               index_key:@(self.willIndex),
                               userSelectOptions_key:array
                               };
        
        NSString *fileName = [self testRecordFileName];
        
        BOOL write = [dict writeToFile:fileName atomically:YES];
        NSLog(@"写入: %d",write);
        
    }
    
}

- (void)configUI{
    
    [self.view addSubview:self.collectionView];
    
    /// 获取本地记录
    _localRecord = [NSDictionary dictionaryWithContentsOfFile:[self testRecordFileName]];
    
    if (_tkcsType == OLTkcsTypecs) {
        /// 从本地获取用户耗时
        NSNumber *sec_record = _localRecord[timeused_key];
        NSInteger sec = sec_record.integerValue;
        
        if (_backLook) {
            /// 回看状态下，显示用户耗时
            UILabel *timeused = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 75, 20)];
            timeused.textAlignment = NSTextAlignmentRight;
            timeused.text = self.model.timeused_string;
            UIBarButtonItem *rightItem = [UIBarButtonItem.alloc initWithCustomView:timeused];
            self.navigationItem.rightBarButtonItem = rightItem;
        }else{
            /// 答题转台下，计时
            LGCountTimeLabel *ctlabel = [LGCountTimeLabel.alloc initWithFrame:CGRectMake(0, 0, 75, 20) sec:sec];
            UIBarButtonItem *rightItem = [UIBarButtonItem.alloc initWithCustomView:ctlabel];
            _ctlabel = ctlabel;
            self.navigationItem.rightBarButtonItem = rightItem;
        }
    }
    
    
    OLExamViewBottomBar *bottomBar = [OLExamViewBottomBar examViewBottomBar];
    _bottomBar = bottomBar;
    bottomBar.delegate = self;
    bottomBar.backLook = _backLook;
    bottomBar.frame = CGRectMake(0, self.view.height - bottomBarHeight, kScreenWidth, bottomBarHeight);
    bottomBar.alreadyCount = 1;
    [self.view addSubview:bottomBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnQuestion:) name:OLExamTurnQuestionNotification object:nil];
    
    [self getNetData];
}

- (void)getNetData{
    
    if (_backLook) {
        /// 回看
        for (NSInteger i = 0; i < _backLookArray.count; i++) {
            OLExamSingleModel *singleModel = _backLookArray[i];
            singleModel.index = i;
            /// 设置回看状态
            singleModel.backLook = _backLook;
            if (i == 0) {
                singleModel.first = YES;
            }
            if (i == _backLookArray.count - 1) {
                singleModel.last = YES;
            }
            /// 添加题干
            [singleModel addSubjectModel];
            /// 添加参考答案行
            [singleModel addReferAnswer];
        }
        
        self.dataArray = _backLookArray;
        _bottomBar.totalCount = _backLookArray.count;
        [self.collectionView reloadData];
        
    }else{
        /// 普通测试
        /// 请求试卷
        [DJOnlineNetorkManager.sharedInstance frontSubjects_selectTitleDetailWithPortName:_portName titleid:_model.seqid offset:0 success:^(id responseObj) {
            [self dataTranWith:responseObj];
            
        } failure:^(id failureObj) {
            
        }];
    }
    
    
}


- (void)dataTranWith:(id)responseObj{
    NSArray *array = responseObj;
    BOOL arrIsNil = (array == nil || array.count == 0);
    if (arrIsNil) {
        return;
    }else{
        
        NSArray *userAlreadySelect = nil;
        if (_localRecord[userSelectOptions_key]) {
            userAlreadySelect = _localRecord[userSelectOptions_key];
        }
        
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
            singleModel.index = i;
            /// 添加题干
            [singleModel addSubjectModel];
            [arrMu addObject:singleModel];
        }
        
        if (userAlreadySelect) {/// 如果本地有用户选中的记录
            for (NSDictionary *dict in userAlreadySelect) {
                NSNumber *optionSeqid = dict[@"id"];// 获取本地选中的题目id
                NSString *selectOptionSeqids = dict[@"options"];// 获取本地记录的选项id
                for (OLExamSingleModel *singleModel in arrMu) {
                    if (singleModel.seqid == optionSeqid.integerValue) {// 如果数组中的题目id与本地记录的题目id相同，表示这道题用户之前已经选了某个答案
                        NSArray *selectIds = [selectOptionSeqids componentsSeparatedByString:@","];
                        /// 将用户选中的选项id字符串转为数组
                        for (NSString *optionId in selectIds) {
                            for (OLExamSingleLineModel *sinleLineModel in singleModel.frontSubjectsDetail) {
                                if ([optionId isEqualToString:[NSString stringWithFormat:@"%ld",sinleLineModel.seqid]]) {
                                    /// 如果本地记录的选项id 和 选项模型的id相同，表示用户之前选中了该选项
                                    sinleLineModel.selected = YES;
                                    if (singleModel.subjecttype == 2) {
                                        /// 如果是多选，还需要将 选项加入到题目模型的 selectOptions 中
                                        [singleModel.selectOptions addObject:sinleLineModel];
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                
            }
        }
        
        self.dataArray = arrMu.copy;
        _bottomBar.totalCount = arrMu.count;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
            
            /// 如果本地有答题记录，直接跳转
            NSNumber *index = _localRecord[index_key];
            if (index.integerValue != 0) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index.integerValue inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                _bottomBar.alreadyCount = index.integerValue + 1;
            }
        }];
    }
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
        NSNumber *canNext = userInfo[OLExamTurnQuestionNotificationCanNextKey];
        if (!_backLook) {
            if (!canNext.boolValue) {
                [self presentFailureTips:@"请至少选择一个选项"];
                return;
            }            
        }
        
        index++;
        if (index == self.dataArray.count) {
            
            if (!_backLook) {/// 如果不是回看
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
                
                /// TODO: 提交试卷,打开即可
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
                
            }else{
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
    cell.backLook = _backLook;
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
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[OLExamCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

- (CGFloat)itemHeight{
    return kScreenHeight - kNavHeight - bottomBarHeight;
}

- (NSTimeInterval)currentTimeinterval{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    return [date timeIntervalSince1970];
}

- (void)countUserTimeConsumed{
    NSNumber *sec_record = _localRecord[timeused_key];
    self.model.timeused_timeInterval = sec_record.integerValue;
}

- (NSString *)testRecordFileName{
    return [LGFilePathManager.sharedInstance dj_testFileNamePathWithTestid:self.model.testid];
}

@end
