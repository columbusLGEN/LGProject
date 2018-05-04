//
//  OLVoteDetailFooterView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLVoteDetailFooterView;

@protocol OLVoteDetailFooterViewDelegate <NSObject>
- (void)voteFooterCommit:(OLVoteDetailFooterView *)voteFooter;

@end

@interface OLVoteDetailFooterView : UIView

+ (instancetype)footerForVoteDetail;
@property (weak,nonatomic) id<OLVoteDetailFooterViewDelegate> delegate;

@end
