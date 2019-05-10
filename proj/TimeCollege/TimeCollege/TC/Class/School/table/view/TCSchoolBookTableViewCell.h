//
//  TCSchoolBookTableViewCell.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCSchoolBookTableViewCell : UITableViewCell
@property (strong,nonatomic) NSIndexPath *index;
- (void)index:(NSIndexPath *)index firstCellHiddenLine:(BOOL)firstCellHiddenLine;

@end

NS_ASSUME_NONNULL_END
