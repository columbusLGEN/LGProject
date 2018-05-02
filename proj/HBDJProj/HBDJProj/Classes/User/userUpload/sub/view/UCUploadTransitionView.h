//
//  UCUploadTransitionView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

typedef NS_ENUM(NSUInteger, UploadTransitionAction) {
    UploadTransitionActionMemeberStage,
    UploadTransitionActionMindReport,
    UploadTransitionActionSpeakCheap,
};

@protocol UCUploadTransitionViewDelegate;

@interface UCUploadTransitionView : LGBaseView
+ (instancetype)uploadTransitionView;
@property (weak,nonatomic) id<UCUploadTransitionViewDelegate> delegate;

@end

@protocol UCUploadTransitionViewDelegate <NSObject>

- (void)utViewClose:(UCUploadTransitionView *)utView;

@optional
- (void)utView:(UCUploadTransitionView *)utView action:(UploadTransitionAction)action;

@end
