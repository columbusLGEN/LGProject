//
//  DJListPlayNoticeView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/19.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJListPlayNoticeView : UIView
- (void)showNoticeWithView:(UIView *)view complete:(void(^)(void))complete;

@end
