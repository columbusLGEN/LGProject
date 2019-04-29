//
//  TCBookInfoCell.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCBookInfoCell : UITableViewCell

@property (weak,nonatomic) UITableView *fatherTableView;
@property (strong,nonatomic) UILabel *itemName;
@property (strong,nonatomic) UIView *line;
@property (strong,nonatomic) id model;


+ (NSString *)cellReuseIdWith:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
