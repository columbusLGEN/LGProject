//
//  NSDictionary+LGExtension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/18.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "NSDictionary+LGExtension.h"

@implementation NSDictionary (LGExtension)

- (NSString *)dictToString{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    return [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
}

@end
