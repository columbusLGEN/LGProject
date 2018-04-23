//
//  UCUploadViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@interface LGSegmentViewController : LGBaseViewController
@property (strong,nonatomic) NSArray *segmentItems;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (assign,nonatomic) CGFloat segmentHeight;
@end
