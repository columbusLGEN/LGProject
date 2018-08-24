//
//  DCQuestionSearchResultVc.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCQuestionCommunityViewController.h"
@protocol DJDsSearchChildVcDelegate;

@interface DCQuestionSearchResultVc : DCQuestionCommunityViewController
@property (strong,nonatomic) NSString *searchContent;
@property (assign,nonatomic) NSInteger tagId;
@property (weak,nonatomic) id<DJDsSearchChildVcDelegate> delegate;

@end
