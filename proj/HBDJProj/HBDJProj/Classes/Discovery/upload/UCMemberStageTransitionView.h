//
//  UCMemberStageTransitionView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
#import "DJUploadPyqHeader.h"

@protocol UCMemberStageTransitionViewDelegate;

@interface UCMemberStageTransitionView : LGBaseView
+ (instancetype)memberStateTransitionView;
@property (weak,nonatomic) id<UCMemberStageTransitionViewDelegate> delegate;
- (void)setBigCloseBackgroundColor;
- (void)setBigCloseBackgroundColorClear;

@end

@protocol UCMemberStageTransitionViewDelegate <NSObject>
- (void)mstViewClose:(UCMemberStageTransitionView *)mstView;
@optional
- (void)mstView:(UCMemberStageTransitionView *)mstView action:(DJUploadPyqAction)action;

@end
