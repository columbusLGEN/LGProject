//
//  OLTestResultViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTestResultViewController.h"
#import "OLExamViewController.h"
#import "OLTkcsModel.h"
#import "DJOnlineNetorkManager.h"
#import "OLTestBackLookModel.h"
#import "OLTestBackLookDetailModel.h"

@interface OLTestResultViewController ()
/** 正确率 */
@property (weak, nonatomic) IBOutlet UILabel *rate;
/** 总题数 */
@property (weak, nonatomic) IBOutlet UIButton *totalCount;
/** 正确数 */
@property (weak, nonatomic) IBOutlet UIButton *rightCount;
/** 错误数 */
@property (weak, nonatomic) IBOutlet UIButton *wrongCount;
/** 耗时 */
@property (weak, nonatomic) IBOutlet UIButton *timeConsume;
/** 回看按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backLook;

@property (strong,nonatomic) OLTestBackLookModel *backLookModel;

/// se 屏幕需要修改的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateContainerViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateContainerViewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateContainerViewTopMarginCons;

@end

@implementation OLTestResultViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_backLook cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_backLook.height / 2];
    [_totalCount cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_totalCount.height / 2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self getNetData];
}

- (void)configUI{
    [_totalCount setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
    
    if (kScreenWidth < 375) {
        /// iPhone SE
        _rate.font = [UIFont systemFontOfSize:60];
        _rateContainerViewWidthCons.constant = 165;
        _rateContainerViewHeightCons.constant = 165;
        _rateContainerViewTopMarginCons.constant = 20;
    }
}

- (void)getNetData{
    [DJOnlineNetorkManager.sharedInstance frontSubjects_selectTestsPlayBackWithTestid:_model.seqid success:^(id responseObj) {
        OLTestBackLookModel *model = [OLTestBackLookModel mj_objectWithKeyValues:responseObj];
        model.detail.subCount = model.subjects.count;
        _backLookModel = model;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (self.model == nil) {
                self.model = OLTkcsModel.new;
            }
            self.model.subcount = model.subjects.count;
            self.model.rightCount = model.detail.isrightnum;
            self.model.timeused_timeInterval = model.detail.timeused;
            
            _rate.text = [NSString stringWithFormat:@"%ld",self.model.rightRate];
            [_totalCount setTitle:[NSString stringWithFormat:@"总题数: %ld",self.model.subcount] forState:UIControlStateNormal];
            [_rightCount setTitle:[NSString stringWithFormat:@"正确: %ld",self.model.rightCount] forState:UIControlStateNormal];
            [_wrongCount setTitle:[NSString stringWithFormat:@"错误: %ld",self.model.wrongCount] forState:UIControlStateNormal];
            [_timeConsume setTitle:[NSString stringWithFormat:@"用时: %@",self.model.timeused_string] forState:UIControlStateNormal];
        }];
        
    } failure:^(id failureObj) {
        
    }];
}

- (IBAction)close:(id)sender {
    /// MARK: 关闭
    [self lg_dismissViewController];
}

- (IBAction)backLookClick:(UIButton *)sender {
    
    /// 进入 试题回看
    OLExamViewController *backLookExamVc = [OLExamViewController new];
    backLookExamVc.model = self.model;
    backLookExamVc.backLook = YES;
    backLookExamVc.backLookArray = _backLookModel.subjects;
    backLookExamVc.tkcsType = OLTkcsTypecs;
    [self.navigationController pushViewController:backLookExamVc animated:YES];
    if (_backLookModel) {
    }
}


@end
