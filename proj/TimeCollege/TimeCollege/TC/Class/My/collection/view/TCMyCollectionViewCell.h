//
//  TCMyCollectionViewCell.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TCMyBookrackModel;

@interface TCMyCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) TCMyBookrackModel *model;

@end

NS_ASSUME_NONNULL_END
