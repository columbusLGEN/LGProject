//
//  TCBIRecoCell.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

// 推荐cell

#import "TCBookInfoCell.h"


NS_ASSUME_NONNULL_BEGIN

static NSString * BIRCcell = @"TCBIRecoCell";

@class TCBookInfoRecoCollectionViewController;

@interface TCBIRecoCell : TCBookInfoCell
@property (strong,nonatomic) TCBookInfoRecoCollectionViewController *recovc;

@end

NS_ASSUME_NONNULL_END
