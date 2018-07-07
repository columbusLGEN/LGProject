//
//  DJSelectMeetingTagViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@class DJSelectMeetingTagViewController;

@protocol DJSelectMeetingTagViewControllerDelegate <NSObject>
- (void)selectMeetingTag:(DJSelectMeetingTagViewController *)vc selectString:(NSString *)string;

@end

@interface DJSelectMeetingTagViewController : LGBaseViewController
@property (weak,nonatomic) id<DJSelectMeetingTagViewControllerDelegate> delegate;

@end
