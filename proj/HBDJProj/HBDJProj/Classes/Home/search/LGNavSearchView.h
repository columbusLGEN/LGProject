//
//  LGNavSearchView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGNavSearchViewDelegate;

@interface LGNavSearchView : UIView

@property (weak,nonatomic) id<LGNavSearchViewDelegate> delegate;

@end

@protocol LGNavSearchViewDelegate <NSObject>

- (void)navSearchViewBack:(LGNavSearchView *)navSearchView;

@end
