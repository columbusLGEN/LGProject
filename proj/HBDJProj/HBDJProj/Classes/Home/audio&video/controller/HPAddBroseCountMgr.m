//
//  HPAddBroseCountMgr.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAddBroseCountMgr.h"

@implementation HPAddBroseCountMgr

- (void)addBroseCountWithId:(NSInteger)seqid success:(void(^)(void))success{
    [[DJHomeNetworkManager sharedInstance] homeAddcountWithId:[NSString stringWithFormat:@"%ld",seqid] success:^(id responseObj) {
        NSLog(@"homeAddcountWithId_responseobject: %@",responseObj);
        if (success) success();
    } failure:^(id failureObj) {
        
    }];
}

@end
