//
//  DJHomeSearchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJHomeSearchViewController.h"
#import "LGLocalSearchRecord.h"
#import "HPVoiceSearchView.h"
#import "HPSearchHistoryView.h"
//#import "OLVoteListController.h"
//#import "OLTkcsTableViewController.h"
#import "DJDataBaseModel.h"
#import "EDJMicroBuildModel.h"

#import "HPSearchLessonController.h"
#import "HPSearchBuildPoineNewsController.h"

@interface DJHomeSearchViewController ()

@end

@implementation DJHomeSearchViewController

- (void)setChildvcSearchContent:(NSString *)searchContent{
    HPSearchLessonController *microvc = self.childViewControllers[0];
    HPSearchBuildPoineNewsController *partyvc = self.childViewControllers[1];
    microvc.searchContent = searchContent;
    partyvc.searchContent = searchContent;
    
}
- (void)sendSerachRequestWithSearchContent:(NSString *)searchContent{
    [[LGLoadingAssit sharedInstance] homeAddLoadingViewTo:self.view];
    [DJHomeNetworkManager homeSearchWithString:searchContent type:0 offset:0 length:10 sort:0 success:^(id responseObj) {
        /// MARK: 刷新子可控制器视图
        [self.vsView removeFromSuperview];
        self.vsView = nil;
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        
        NSArray *classes = responseObj[@"classes"];
        NSArray *news = responseObj[@"news"];
        
        HPSearchLessonController *microvc = self.childViewControllers[0];
        if (classes == nil || classes.count == 0) {
            microvc.dataArray = nil;
        }else{
            NSMutableArray *microModels = [NSMutableArray array];
            
            for (int i = 0; i < classes.count; i++) {
                id obj = classes[i];
                DJDataBaseModel *model = [DJDataBaseModel mj_objectWithKeyValues:obj];
                [microModels addObject:model];
            }
            
            microvc.dataArray = microModels.copy;
        }
        
        /// 党建要闻
        HPSearchBuildPoineNewsController *partyvc = self.childViewControllers[1];
        if (news == nil || news.count == 0) {
            partyvc.dataArray = nil;
        }else{
            NSMutableArray *partyModels = [NSMutableArray array];
            
            for (int i = 0; i < news.count; i++) {
                id obj = news[i];
                EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
                [partyModels addObject:model];
            }
            
            partyvc.dataArray = partyModels.copy;
        }
        
        if (classes.count || news.count) {
            self.searchHistory.hidden = YES;
        }
        if (classes.count == 0 && news.count == 0) {
            self.searchHistory.hidden = NO;
            [self.view presentFailureTips:@"没有搜到想要的内容"];
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

/// testcode
- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"微党课",
               LGSegmentItemViewControllerClassKey:@"HPSearchLessonController",/// HPSearchLessonController
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"要闻",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}

@end
