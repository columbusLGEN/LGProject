//
//  HPSearchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPSearchViewController.h"
#import "LGNavigationSearchBar.h"

@interface HPSearchViewController ()<
LGNavigationSearchBarDelelgate>
@property (strong,nonatomic) LGNavigationSearchBar *fakeNavgationBar;
@end

@implementation HPSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    fakeNavgationBar.isShowRightBtn = YES;
    fakeNavgationBar.rightButtonTitle = @"搜索";
    fakeNavgationBar.delegate = self;
    [self.view addSubview:fakeNavgationBar];
    _fakeNavgationBar = fakeNavgationBar;
    
    // TODO: 先加一个大白板，搜索到结果后，将大白板删除
    
}

#pragma - LGNavigationSearchBarDelelgate


- (NSArray<NSDictionary *> *)segmentItems{
    /**
     DCQuestionCommunityViewController
     DCSubPartStateTableViewController
     DCSubStageTableviewController
     */
    return @[@{LGSegmentItemNameKey:@"微党课",
               LGSegmentItemViewControllerClassKey:@"HPMicroLessonTableViewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"要闻",
               LGSegmentItemViewControllerClassKey:@"DCSubPartStateTableViewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}
- (CGFloat)segmentTopMargin{
    return kNavSingleBarHeight + marginTen;
}
@end
