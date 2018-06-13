//
//  HPNetworkFailureView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@protocol HPNetworkFailureViewDelegate <NSObject>
- (void)djemptyViewClick;
@end

@interface HPNetworkFailureView : LGBaseView

@property (weak,nonatomic) id<HPNetworkFailureViewDelegate> delegate;
+ (instancetype)DJEmptyView;
@end
