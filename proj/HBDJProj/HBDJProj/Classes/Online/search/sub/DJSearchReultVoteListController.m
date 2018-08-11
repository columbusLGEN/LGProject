//
//  DJSearchReultVoteListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSearchReultVoteListController.h"
#import "DJOnlineNetorkManager.h"

@interface DJSearchReultVoteListController ()

@end

@implementation DJSearchReultVoteListController

- (void)getNetDataWithOffset:(NSInteger)offset{
    [DJOnlineNetorkManager.sharedInstance frontIndex_onlineSearchWithContent:_searchContent type:2 offset:offset success:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
}

@end
