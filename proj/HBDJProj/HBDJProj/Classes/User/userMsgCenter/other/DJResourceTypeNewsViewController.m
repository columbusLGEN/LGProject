//
//  DJResourceTypeNewsViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJResourceTypeNewsViewController.h"
#import "UCMsgModel.h"
#import "DJDataBaseModel.h"

@interface DJResourceTypeNewsViewController ()

@end

@implementation DJResourceTypeNewsViewController

- (void)setResourceid:(NSInteger)resourceid{
    _resourceid = resourceid;
    
    /// 请求要闻数据
    [DJHomeNetworkManager homePointNewsDetailWithId:resourceid type:DJDataPraisetypeNews success:^(id responseObj) {
        self.contentModel = [DJDataBaseModel mj_objectWithKeyValues:responseObj];
        
    } failure:^(id failureObj) {
        
    }];
}

- (void)setMsgModel:(UCMsgModel *)msgModel{
    _msgModel = msgModel;
    self.resourceid = msgModel.resourceid;
    
}

@end
