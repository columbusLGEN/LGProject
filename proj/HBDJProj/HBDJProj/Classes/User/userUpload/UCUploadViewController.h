//
//  UCUploadViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

typedef NS_ENUM(NSUInteger, UploadTyle) {
    UploadTyleMemberStage,
    UploadTyleMindReport,
    UploadTyleSpeakCheap,
};

@interface UCUploadViewController : LGBaseViewController
@property (assign,nonatomic) UploadTyle uploadType;

@end
