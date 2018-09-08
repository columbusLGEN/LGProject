//
//  DJResourceTypeBranchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJResourceTypeBranchViewController.h"
#import "UCMsgModel.h"
#import "DCSubPartStateModel.h"

@interface DJResourceTypeBranchViewController ()

@end

@implementation DJResourceTypeBranchViewController

- (void)setMsgModel:(UCMsgModel *)msgModel{
    _msgModel = msgModel;
    
    [DJUserNetworkManager.sharedInstance frontBranch_selectDetailWithSeqid:msgModel.resourceid success:^(id responseObj) {
        
        self.model = [DCSubPartStateModel mj_objectWithKeyValues:responseObj];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self dataSettings];
        }];
        
    } failure:^(id failureObj) {
        
    }];
}

@end
