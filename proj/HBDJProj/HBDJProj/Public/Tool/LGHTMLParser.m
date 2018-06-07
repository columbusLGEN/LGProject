//
//  LGHTMLParser.m
//  picture&text
//
//  Created by Peanut Lee on 2018/3/29.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LGHTMLParser.h"

@interface LGHTMLParser ()<DTHTMLParserDelegate>
/** 解析成功回调 */
@property (copy,nonatomic) ParseSuccess success;

@end

@implementation LGHTMLParser

+ (void)HTMLSaxWithHTMLString:(NSString *)HTMLString success:(ParseSuccess)success{
    [[self sharedInstance] HTMLSaxWithHTMLString:HTMLString success:success];
}
- (void)HTMLSaxWithHTMLString:(NSString *)HTMLString success:(ParseSuccess)success{
    NSData *HTMLData = [HTMLString dataUsingEncoding:NSUTF8StringEncoding];
    DTHTMLAttributedStringBuilder *builder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:HTMLData options:nil documentAttributes:nil];
    
    NSAttributedString *attrString = [builder generatedAttributedString];
    success(attrString);
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (NSString *)HTMLStringWithPlistName:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}
- (void)HTMLSax:(ParseSuccess)success{
    _success = success;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"detaiTtest" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self HTMLSaxWithHTMLString:htmlString success:success];
}
@end
