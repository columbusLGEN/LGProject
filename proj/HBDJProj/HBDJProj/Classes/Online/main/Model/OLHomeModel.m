//
//  OLHomeModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLHomeModel.h"

@implementation OLHomeModel

+ (instancetype)loadItemOfMore{
    NSArray *localArray = [OLHomeModel loadLocalPlistWithPlistName:@"OLHomeItems"];
    return localArray[0];
}

- (OnlineModelType)modelType{
    return self.seqid;
}

@end
