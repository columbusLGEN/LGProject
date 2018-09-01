//
//  EDJLevelInfoViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@class EDJLevelInfoModel;

@interface EDJLevelInfoViewController : LGBaseViewController

@end


@interface EDJLevelInfoCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) EDJLevelInfoModel *model;

@end
