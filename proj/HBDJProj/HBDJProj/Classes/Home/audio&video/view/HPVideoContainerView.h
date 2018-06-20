//
//  HPVideoContainerView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
@class DJDataBaseModel,HPAudioVideoViewController;

@interface HPVideoContainerView : LGBaseView
@property (weak,nonatomic) HPAudioVideoViewController *vc;
@property (strong,nonatomic) DJDataBaseModel *model;
- (void)stop;

@end
