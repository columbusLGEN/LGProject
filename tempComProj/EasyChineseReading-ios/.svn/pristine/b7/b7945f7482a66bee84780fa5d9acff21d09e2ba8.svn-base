//
//  ZAlertView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZAlertView.h"

@implementation ZAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if ( self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil])
    {
        
    }
    return self;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( 0 == buttonIndex )
    {
        if ( self.whenDidSelectCancelButton )
        {
            self.whenDidSelectCancelButton();
        }
    }
    else
    {
        if ( self.whenDidSelectOtherButton )
        {
            self.whenDidSelectOtherButton();
        }
    }
}

@end
