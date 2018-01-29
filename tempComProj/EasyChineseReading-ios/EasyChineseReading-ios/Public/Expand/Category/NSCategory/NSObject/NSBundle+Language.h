//
//  NSBundle+Language.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle(Language)

// 在App启动后就已经生成了一个Bundle，里面识别好了对应着自定义的appLanguage(系统的AppleLanguages)的国际化文件，在App运行期间设置这个字段，是不生效的，所以我们去修改这个Bundle

+ (void)setLanguage:(NSString *)language;

@end
