//
//  TCMyBookrackEditMakesureView.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCMyBookrackEditMakesureView : UIView

/** 要删除的书籍 数量 */
@property (assign,nonatomic) NSInteger bookCount;

@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *done;
+ (instancetype)mbemsView;

@end

NS_ASSUME_NONNULL_END
