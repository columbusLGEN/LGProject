//
//  LGVoiceRecoganizer.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

static NSString *LGVoiceRecoganizerEndOfSpeechNotification = @"LGVoiceRecoganizerEndOfSpeechNotification";
static NSString *LGVoiceRecoganizerTextKey = @"LGVoiceRecoganizerTextKey";

#import <Foundation/Foundation.h>

@interface LGVoiceRecoganizer : NSObject

+ (void)lg_start;
+ (instancetype)sharedInstance;
@end


