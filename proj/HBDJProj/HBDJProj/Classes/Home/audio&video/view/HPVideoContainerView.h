//
//  HPVideoContainerView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
@class DJDataBaseModel,
DJLessonDetailViewController,
PLPlayerView;

@protocol HPVideoContainerViewDelegate <NSObject>
- (void)videoConViewPlayCheckWithPlayerView:(PLPlayerView *)playeView;

@end

@interface HPVideoContainerView : LGBaseView

@property (weak,nonatomic) DJLessonDetailViewController *lessonDetailVc;
@property (strong,nonatomic) DJDataBaseModel *model;
@property (weak,nonatomic) id<HPVideoContainerViewDelegate> delegate;
- (void)stop;

@end
