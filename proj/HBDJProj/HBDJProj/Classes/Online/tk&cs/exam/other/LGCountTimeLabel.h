//
//  LGCountTimeLabel.h
//  countTime
//
//  Created by Peanut Lee on 2018/8/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGCountTimeLabel : UILabel

@property (assign,nonatomic,readonly) NSInteger sec;

- (instancetype)initWithFrame:(CGRect)frame sec:(NSInteger)sec;

NSString *timeStrWithSec(NSInteger sec);
@end
