//
//  TCBookDetaileBookBottomView.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TCDetaiBottomSubView;

@interface TCBookDetaileBookBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *borrowRead;
@property (weak, nonatomic) IBOutlet TCDetaiBottomSubView *conView;
@property (weak, nonatomic) IBOutlet UIButton *borrowAgain;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *tipRead;

+ (instancetype)bookDetailBottomv;

@end

NS_ASSUME_NONNULL_END
