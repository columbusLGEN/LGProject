//
//  DJMyCollectViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJMyCollectViewController.h"

@interface DJMyCollectViewController ()

@end

@implementation DJMyCollectViewController

- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"  微党课  ",
               LGSegmentItemViewControllerClassKey:@"HPSearchLessonController",/// HPSearchLessonController
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"   新闻   ",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"  学习问答  ",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"  支部动态  ",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"  党员舞台  ",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}

@end
