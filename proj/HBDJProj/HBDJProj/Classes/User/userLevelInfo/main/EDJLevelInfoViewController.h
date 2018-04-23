//
//  EDJLevelInfoViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"
#import "LGBaseModel.h"

@interface EDJLevelInfoViewController : LGBaseViewController

@end


@interface EDJLevelInfoModel : LGBaseModel
@property (copy,nonatomic) NSString *itemTitle;
@property (strong,nonatomic) NSNumber *rate;
@property (copy,nonatomic) NSString *unit;
@property (strong,nonatomic) NSNumber *score;
@property (strong,nonatomic) NSNumber *upperLimit;

@end


@interface EDJLevelInfoCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) EDJLevelInfoModel *model;

@end
