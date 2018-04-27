//
//  DCSubPartStateWithoutImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateWithoutImgCell.h"
#import "LGThreeRightButtonView.h"

@interface DCSubPartStateWithoutImgCell ()
@property (weak, nonatomic) IBOutlet LGThreeRightButtonView *boInterView;


@end

@implementation DCSubPartStateWithoutImgCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _boInterView.backgroundColor = [UIColor whiteColor];
    [_boInterView setBtnConfigs:@[@{TRConfigTitleKey:@"收藏",
                                   TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow"
                                   },
                                 @{TRConfigTitleKey:@"点赞",
                                   TRConfigImgNameKey:@"dc_like_normal",
                                   TRConfigSelectedImgNameKey:@"dc_like_selected"
                                   },
                                 @{TRConfigTitleKey:@"评论",
                                   TRConfigImgNameKey:@"dc_discuss_normal",
                                   TRConfigSelectedImgNameKey:@"dc_discuss_selected"
                                   }]];
}


@end
