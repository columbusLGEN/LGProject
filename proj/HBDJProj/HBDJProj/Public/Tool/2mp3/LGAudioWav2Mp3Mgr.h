//
//  LGAudioWav2Mp3Mgr.h
//  2mp3Demo
//
//  Created by Peanut Lee on 2018/8/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^wav2mp3Success)();

@interface LGAudioWav2Mp3Mgr : NSObject

- (void)localPCMToMp3WithOriPath:(NSString *)oriPath desPath:(NSString *)desPath complete:(wav2mp3Success)complete;

@end
