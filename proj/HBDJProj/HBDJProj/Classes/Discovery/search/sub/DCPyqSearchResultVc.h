//
//  DCPyqSearchResultVc.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageTableviewController.h"
@protocol DJDsSearchChildVcDelegate;

@interface DCPyqSearchResultVc : DCSubStageTableviewController
@property (strong,nonatomic) NSString *searchContent;
@property (assign,nonatomic) NSInteger tagId;
@property (weak,nonatomic) id<DJDsSearchChildVcDelegate> delegate;

@end
