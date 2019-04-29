//
//  TCBookInfoHeaderView.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/28.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCBookInfoHeaderView : UIView

@property (strong,nonatomic) id model;

+ (instancetype)biHeader;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *bookname;
@property (weak, nonatomic) IBOutlet UILabel *public;
@property (weak, nonatomic) IBOutlet UIButton *readNow;


@end

NS_ASSUME_NONNULL_END
