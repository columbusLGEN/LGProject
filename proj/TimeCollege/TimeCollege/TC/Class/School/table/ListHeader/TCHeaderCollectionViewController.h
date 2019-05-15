//
//  TCHeaderCollectionViewController.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGBaseCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class TCBookCatagoryLineModel;

@interface TCHeaderCollectionViewController : LGBaseCollectionViewController
@property (strong,nonatomic) TCBookCatagoryLineModel *lineModel;

@end

NS_ASSUME_NONNULL_END
