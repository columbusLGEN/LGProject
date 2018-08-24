//
//  LGAudioWav2Mp3Mgr.m
//  2mp3Demo
//
//  Created by Peanut Lee on 2018/8/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGAudioWav2Mp3Mgr.h"
#include "mp3Encoder.hpp"

@implementation LGAudioWav2Mp3Mgr

- (void)localPCMToMp3WithOriPath:(NSString *)oriPath desPath:(NSString *)desPath complete:(wav2mp3Success)complete{
    
    /// 采样率 44100 和 通道数 2 要与录音时的一直，否则导致声音异常
    Mp3Encoder encode;
    encode.Init([oriPath cStringUsingEncoding:NSUTF8StringEncoding], [desPath cStringUsingEncoding:NSUTF8StringEncoding], 44100, 2, 128);
    
    //开始编码
    encode.EncodeLocalFile();
    
    //释放资源
    encode.Destroy();
    
    /// 转换完成 回调
    if (complete) complete();
    
}

@end
