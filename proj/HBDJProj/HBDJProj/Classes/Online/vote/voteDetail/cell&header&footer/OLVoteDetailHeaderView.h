//
//  OLVoteDetailHeaderView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLVoteDetailHeaderModel,OLVoteDetailHeaderView;

@protocol OLVoteDetailHeaderViewDelegate <NSObject>
- (void)voteDetailHeaderReCallHeight:(OLVoteDetailHeaderView *)header;

@end

@interface OLVoteDetailHeaderView : UIView
+ (instancetype)headerForVoteDetail;
@property (strong,nonatomic) OLVoteDetailHeaderModel *model;
@property (weak,nonatomic) id<OLVoteDetailHeaderViewDelegate> delegate;
- (CGFloat)headerHeight;

@end
