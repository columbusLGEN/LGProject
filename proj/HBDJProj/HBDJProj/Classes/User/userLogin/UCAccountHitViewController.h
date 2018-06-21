//
//  UCAccountHitViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"
@protocol UCAccountHitViewControllerDelegate <NSObject>
- (void)ucanLoginWithTel:(NSString *)tel pwd:(NSString *)pwd;

@end

@interface UCAccountHitViewController : LGBaseViewController
@property (strong,nonatomic) NSMutableDictionary *activationDict;
@property (weak,nonatomic) id<UCAccountHitViewControllerDelegate> delegate;

@end
