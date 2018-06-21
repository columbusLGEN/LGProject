//
//  UCAccountHitSuccessView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@class UCAccountHitSuccessView;

@protocol UCAccountHitSuccessViewDelegate <NSObject>
- (void)removehsView;

@end

@interface UCAccountHitSuccessView : LGBaseView
@property (weak,nonatomic) id<UCAccountHitSuccessViewDelegate> delegate;

@end
