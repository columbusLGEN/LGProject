//
//  TCListHeaderTableViewCell.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * lhtCell = @"TCListHeaderTableViewCell";

@interface TCListHeaderTableViewCell : UITableViewCell
@property (strong,nonatomic) id model;
@end

NS_ASSUME_NONNULL_END
