//
//  DJSegmentView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSegmentView.h"

@interface DJSegmentView ()


@end

@implementation DJSegmentView

- (instancetype)initWithSegConfigs:(NSArray *)segConfigs frame:(CGRect)frame{
    
    for (NSInteger i = 0; i < segConfigs.count; i++) {
        NSDictionary *configDict = segConfigs[i];
        
    }
    return [self initWithFrame:frame];
}

@end
