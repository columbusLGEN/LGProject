//
//  LGVoiceRecoganizer.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGVoiceRecoganizer.h"
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"
//#import "IATConfig.h"

@interface LGVoiceRecoganizer ()<IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//Recognition conrol without view
@property (nonatomic, strong) NSString * result;

@property (strong,nonatomic) NSMutableString *voiceString;

@end

@implementation LGVoiceRecoganizer

/// TODO: 适当的时候清空 voiceString

#pragma mark - IFlySpeechRecognizerDelegate
- (void)onCompleted:(IFlySpeechError *)errorCode{
    NSLog(@"errorCode.errorDesc -- %@",errorCode.errorDesc);
}
////识别结果返回代理
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    _result =[NSString stringWithFormat:@"%@",resultString];
    
    NSString * resultFromJson =  nil;
    
//    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //The result type must be utf8, otherwise an unknown error will happen.
//                                [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    

    resultFromJson = [ISRDataHelper stringFromJson:resultString];

    [self.voiceString appendString:resultFromJson];
    NSLog(@"print_voiceString -- %@",_voiceString);
}

//识别会话结束返回代理
- (void)onError: (IFlySpeechError *) error{

}
//停止录音回调
- (void) onEndOfSpeech{
    NSDictionary *dict = @{LGVoiceRecoganizerTextKey:_voiceString};
    [[NSNotificationCenter defaultCenter] postNotificationName:LGVoiceRecoganizerEndOfSpeechNotification object:nil userInfo:dict];
    _voiceString = nil;
}
//开始录音回调
- (void) onBeginOfSpeech{
    NSLog(@"开始识别 -- ");
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
    
}
//会话取消回调
- (void) onCancel{

}


- (void)lg_start{
    //启动识别服务
    BOOL success = [_iFlySpeechRecognizer startListening];
    NSLog(@"voiceRecoSuccess -- %d",success);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //创建语音识别对象
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        _iFlySpeechRecognizer.delegate = self;
        
//        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置为听写模式
        [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
        [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
    }
    return self;
}
+ (void)lg_start{
    [[self sharedInstance] lg_start];
}
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (NSMutableString *)voiceString{
    if (!_voiceString) {
        _voiceString = [[NSMutableString alloc] initWithCapacity:10];
    }
    return _voiceString;
}
@end
