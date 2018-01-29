//
//  ZAlertView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZAlertViewBlock)(void);

@interface ZAlertView : UIAlertView

@property (copy, nonatomic) ZAlertViewBlock whenDidSelectCancelButton;
@property (copy, nonatomic) ZAlertViewBlock whenDidSelectOtherButton;

@end
