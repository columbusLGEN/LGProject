//
//  LGHTMLParser.h
//  picture&text
//
//  Created by Peanut Lee on 2018/3/29.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DTCoreText/DTCoreText.h>

typedef void(^ParseSuccess)(NSAttributedString *attrString);

@interface LGHTMLParser : NSObject

+ (void)HTMLSaxWithHTMLString:(NSString *)HTMLString success:(ParseSuccess)success;
+ (instancetype)sharedInstance;

/// 测试
- (NSString *)HTMLStringWithPlistName:(NSString *)plistName;
- (void)HTMLSax:(ParseSuccess)success;
@end
