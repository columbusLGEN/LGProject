//
//  HPAddBroseCountMgr.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPAddBroseCountMgr : NSObject

- (void)addBroseCountWithId:(NSInteger)seqid success:(void(^)())success;

@end
