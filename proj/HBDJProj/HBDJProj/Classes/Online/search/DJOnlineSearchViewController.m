//
//  DJOnlineSearchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineSearchViewController.h"
#import "LGLocalSearchRecord.h"
#import "HPVoiceSearchView.h"
#import "HPSearchHistoryView.h"
#import "DJSearchReultVoteListController.h"
#import "DJSearchResultTestListController.h"
#import "DJSearchWorkPlantformListViewController.h"
#import "DJDataBaseModel.h"
#import "EDJMicroBuildModel.h"
#import "DJOnlineNetorkManager.h"
#import "DJThemeMeetingsModel.h"
#import "OLVoteListModel.h"
#import "OLTkcsModel.h"

@interface DJOnlineSearchViewController ()

@end

@implementation DJOnlineSearchViewController

- (void)setChildvcSearchContent:(NSString *)searchContent{
    
    DJSearchWorkPlantformListViewController *workvc = self.childViewControllers[0];
    DJSearchReultVoteListController *voteListvc = self.childViewControllers[1];
    DJSearchResultTestListController *testListvc = self.childViewControllers[2];
    
    /// 给控制器 赋值 search content
    workvc.searchContent = searchContent;
    voteListvc.searchContent = searchContent;
    testListvc.searchContent = searchContent;
    
}
- (void)sendSerachRequestWithSearchContent:(NSString *)searchContent{
    
    [[LGLoadingAssit sharedInstance] homeAddLoadingViewTo:self.view];
    [DJOnlineNetorkManager.sharedInstance frontIndex_onlineSearchWithContent:searchContent type:0 offset:0 success:^(id responseObj) {
        
        /// MARK: 刷新子可控制器视图
        [self.vsView removeFromSuperview];
        self.vsView = nil;
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        
        NSArray *sessions = responseObj[@"sessions"];
        NSArray *votes = responseObj[@"votes"];
        NSArray *tests = responseObj[@"tests"];
        
        DJSearchWorkPlantformListViewController *workvc = self.childViewControllers[0];
        if (sessions == nil || sessions.count == 0) {
            workvc.dataArray = nil;
        }else{
            NSMutableArray *arrmu = NSMutableArray.new;
            for (NSInteger i = 0; i < sessions.count; i++) {
                DJThemeMeetingsModel *model = [DJThemeMeetingsModel mj_objectWithKeyValues:sessions[i]];
                [arrmu addObject:model];
            }
            workvc.dataArray = arrmu.copy;
        }
        
        DJSearchReultVoteListController *voteListvc = self.childViewControllers[1];
        if (votes == nil || votes.count == 0) {
            voteListvc.dataArray = nil;
        }else{
            NSMutableArray *arrmu = NSMutableArray.new;
            for (NSInteger i = 0; i < votes.count; i++) {
                OLVoteListModel *model = [OLVoteListModel mj_objectWithKeyValues:votes[i]];
                [arrmu addObject:model];
            }
            voteListvc.dataArray = arrmu.copy;
        }
        
        DJSearchResultTestListController *testListvc = self.childViewControllers[2];
        if (tests == nil || tests.count == 0) {
            testListvc.dataArray = nil;
        }else{
            NSMutableArray *arrmu = NSMutableArray.new;
            for (NSInteger i = 0; i < tests.count; i++) {
                OLTkcsModel *model = [OLTkcsModel mj_objectWithKeyValues:tests[i]];
                /// 搜索结果仅支持搜索在线测试，不搜题库
                model.tkcsType = OLTkcsTypecs;
                [arrmu addObject:model];
            }
            testListvc.dataArray = arrmu.copy;

        }
        
        if (sessions.count || votes.count || tests.count) {
            self.searchHistory.hidden = YES;
        }
        if (sessions.count == 0 && votes.count == 0 && tests.count == 0) {
            self.searchHistory.hidden = NO;
            [self.view presentFailureTips:@"没有搜到您想要的内容"];
        }
        
        
    } failure:^(id failureObj) {
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        NSLog(@"faillureObject -- %@",failureObj);
        if ([failureObj isKindOfClass:[NSError class]]) {
            [self presentFailureTips:@"网络异常"];
        }else{
            [self presentFailureTips:@"没有数据"];
        }
    }];
    
}
- (NSInteger)searchRecordExePart{
    return SearchRecordExePartOnline;
}

- (NSArray<NSDictionary *> *)segmentItems{

    return @[@{LGSegmentItemNameKey:@"党建工作台账",
               LGSegmentItemViewControllerClassKey:@"DJSearchWorkPlantformListViewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"在线投票",
               LGSegmentItemViewControllerClassKey:@"DJSearchReultVoteListController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"知识测试",
               LGSegmentItemViewControllerClassKey:@"DJSearchResultTestListController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}

@end
