//
//  HPPartyBuildDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPartyBuildDetailViewController.h"
//#import "LGThreeRightButtonView.h"
#import "LGThreeRightButtonView.h"

@interface HPPartyBuildDetailViewController ()

@end

@implementation HPPartyBuildDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    CGFloat bottomHeight = 60;
    BOOL isiPhoneX = ([LGDevice sharedInstance].currentDeviceType == LGDeviecType_iPhoneX);
    if (isiPhoneX) {
//        bottomHeight = 90;
    }
    LGThreeRightButtonView *pbdBottom = [[LGThreeRightButtonView alloc] initWithFrame:CGRectMake(0, kScreenHeight - bottomHeight, kScreenWidth, bottomHeight)];
    
    [pbdBottom setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                    TRConfigImgNameKey:@"dc_like_normal",
                                    TRConfigSelectedImgNameKey:@"dc_like_selected",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_6CBEFC]
                                    },
                                  @{TRConfigTitleKey:@"99+",
                                    TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                    },
                               @{TRConfigTitleKey:@"",
                                 TRConfigImgNameKey:@"uc_icon_fenxiang_gray",
                                 TRConfigSelectedImgNameKey:@"uc_icon_fenxiang_green",
                                 TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                 TRConfigTitleColorSelectedKey:[UIColor EDJColor_8BCA32]
                                 }]];
    
    [self.view addSubview:pbdBottom];
}

#pragma mark - LGThreeRightButtonViewDelegate



@end
