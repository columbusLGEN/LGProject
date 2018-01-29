//
//  ECRmultiObject.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRMultiObject.h"
#import "ECRRowObject.h"

@interface ECRMultiObject ()


@end

@implementation ECRMultiObject

+ (BOOL)isiPhoneX{
    if ([[IPhoneVersion deviceName] isEqualToString:@"iPhone X"]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)userYue{
    return [UserRequest sharedInstance].user.virtualCurrency;
}
+ (NSInteger)userScore{
    return UserRequest.sharedInstance.user.score;
}

/** 首页推荐&系列书籍间距 */
+ (CGFloat)homeBookCoverSpace{
    return [[self sharedInstance] homeBookCoverSpace];
}
- (CGFloat)homeBookCoverSpace{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return 20;
    }else{
        return 10;
    }
}
+ (CGFloat)homebcwhRate{
    return [[self sharedInstance] homebcwhRate];
}
- (CGFloat)homebcwhRate{
    return 13.0 / 18.0;
}

// 将 array 中的数据 两两取出 返回新的数组
// [1,2,3,4] --> [{[1,2]},{[3,4]}]
// [1,2,3]   --> [{[1,2]},{[3]}]
- (NSArray *)doubleArrayWithOriginArray:(NSArray *)array rowKey:(NSString *)rowKey{
    if (array == nil || array.count == 0) {
    }else{
        NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:10];
        NSUInteger takeTheRemainderOf2 = array.count%2;
        if (takeTheRemainderOf2) {// 结果为1，count 为奇数
            for (NSInteger i = 0; i < array.count; i += 2) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
                NSMutableArray *arrRow = [NSMutableArray arrayWithCapacity:10];
                if (i == array.count - 1) {
                    [arrRow addObject:array[i]];
                }else{
                    [arrRow addObject:array[i]];
                    [arrRow addObject:array[i + 1]];
                }
                dict[rowKey] = arrRow;
                [arrm addObject:dict];
            }
        }else{
            for (NSInteger i = 0; i < array.count - 1; i += 2) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
                NSMutableArray *arrRow = [NSMutableArray arrayWithCapacity:10];
                [arrRow addObject:array[i]];
                [arrRow addObject:array[i + 1]];
                dict[rowKey] = arrRow;
                [arrm addObject:dict];
            }
        }
        return arrm.copy;
    }
    return nil;
}
- (NSArray *)singleLineDoubleModelWithOriginArr:(NSArray *)array{
    if (array == nil || array.count == 0) {
        return nil;
    }else{
        NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:10];
        NSUInteger takeTheRemainderOf2 = array.count%2;
        if (takeTheRemainderOf2) {// 结果为1，count 为奇数
            for (NSInteger i = 0; i < array.count; i += 2) {
                ECRRowObject *rowObj = [[ECRRowObject alloc] init];
                if (i == array.count - 1) {
                    [rowObj.modelArray addObject:array[i]];
                }else{
                    [rowObj.modelArray addObject:array[i]];
                    [rowObj.modelArray addObject:array[i + 1]];
                }
                [arrm addObject:rowObj];
            }
        }else{
            for (NSInteger i = 0; i < array.count - 1; i += 2) {
                ECRRowObject *rowObj = [[ECRRowObject alloc] init];
                [rowObj.modelArray addObject:array[i]];
                [rowObj.modelArray addObject:array[i + 1]];
                [arrm addObject:rowObj];
            }
        }
        return arrm.copy;
    }
}

+ (BOOL)userInterfaceIdiomIsPad{
    return ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}
+ (UIUserInterfaceIdiom)userInterfaceIdiom{
    return [[self sharedInstance] userInterfaceIdiom];
}
- (UIUserInterfaceIdiom)userInterfaceIdiom{
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
