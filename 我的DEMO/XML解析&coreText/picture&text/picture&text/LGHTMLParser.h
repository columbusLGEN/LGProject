//
//  LGHTMLParser.h
//  picture&text
//
//  Created by Peanut Lee on 2018/3/29.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ParseSuccess)(id objc);

@interface LGHTMLParser : NSObject

- (void)HTMLSax:(ParseSuccess)success;
@end
