//
//  OLVoteDetailHeaderView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLVoteDetailHeaderModel;

@interface OLVoteDetailHeaderView : UIView
+ (instancetype)headerForVoteDetail;
@property (strong,nonatomic) OLVoteDetailHeaderModel *model;

@end
