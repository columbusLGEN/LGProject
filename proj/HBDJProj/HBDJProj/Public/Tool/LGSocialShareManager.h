//
//  LGSocialShareManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGSocialShareManager : NSObject
+ (void)showShareMenuWithThumbUrl:(NSString *)thumbUrl content:(NSString *)content webpageUrl:(NSString *)webpageUrl vc:(UIViewController *)vc;
@end
