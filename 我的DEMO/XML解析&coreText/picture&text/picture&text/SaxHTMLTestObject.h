//
//  SaxHTMLTestObject.h
//  picture&text
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^isolateBlock)(NSArray *arr);

@interface SaxHTMLTestObject : NSObject

- (void)lg_sax:(isolateBlock)isolateBlock;
+ (instancetype)sharedInstance;
@end
