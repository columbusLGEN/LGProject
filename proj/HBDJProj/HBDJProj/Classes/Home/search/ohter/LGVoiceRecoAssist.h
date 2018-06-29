//
//  LGVoiceRecoAssist.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LGVoiceRecoAssistDelegate <NSObject>
/// 正在识别
- (void)voiceRecoAssistRecoganizing:(NSInteger)second;
/// 结束识别
- (void)voiceRecoAssistEndRecoganize;

@end

@interface LGVoiceRecoAssist : NSObject

@property (weak,nonatomic) id<LGVoiceRecoAssistDelegate> delegate;

- (void)start;

@end
