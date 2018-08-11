//
//  DJSearchResultTestListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSearchResultTestListController.h"
#import "DJOnlineNetorkManager.h"
@interface DJSearchResultTestListController ()

@end

@implementation DJSearchResultTestListController

- (void)getNetDataWithOffset:(NSInteger)offset{
    [DJOnlineNetorkManager.sharedInstance frontIndex_onlineSearchWithContent:_searchContent type:3 offset:offset success:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
}

@end
