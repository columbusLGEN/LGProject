//
//  TCInputDiscussView.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCInputDiscussView : UIView
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starIns;
@property (weak, nonatomic) IBOutlet UIButton *commitDis;
@property (weak, nonatomic) IBOutlet UITextView *disContent;
@property (weak, nonatomic) IBOutlet UIImageView *fadeImage;

+ (instancetype)inputDiscussv;

@end

NS_ASSUME_NONNULL_END
