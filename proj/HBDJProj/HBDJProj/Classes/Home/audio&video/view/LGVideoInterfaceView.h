//
//  LGVideoInterfaceView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@protocol LGVideoInterfaceViewDelegate;

@interface LGVideoInterfaceView : LGBaseView

@property (strong,nonatomic) UISlider *progress;
@property (weak,nonatomic) id<LGVideoInterfaceViewDelegate> delegate;
@property (weak,nonatomic) id<LGVideoInterfaceViewDelegate> delegate_fullScreen;

@property (strong,nonatomic) NSString *curTimeStr;
@property (strong,nonatomic) NSString *totTimeStr;

@end

@protocol LGVideoInterfaceViewDelegate <NSObject>

@optional
- (void)userDragProgress:(LGVideoInterfaceView *)videoInterfaceView value:(float)value;
- (void)videoInterfaceIViewFullScreenClick:(LGVideoInterfaceView *)videoInterface;

@end
