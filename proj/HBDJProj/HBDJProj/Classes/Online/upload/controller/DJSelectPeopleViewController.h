//
//  DJSelectPeopleViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

/** 选择人员类型 */
typedef NS_ENUM(NSUInteger, DJSelectPeopleType) {
    /** 参会人员 */
    DJSelectPeopleTypeCome,
    /** 缺席人员 */
    DJSelectPeopleTypeNotCome,
};

@class DJSelectPeopleViewController;

@protocol DJSelectPeopleViewControllerDelegate <NSObject>
- (void)selectPeopleDone:(DJSelectPeopleViewController *)vc peopleList:(NSArray *)peopleList spType:(DJSelectPeopleType)spType;

@end

@interface DJSelectPeopleViewController : LGBaseViewController
@property (weak,nonatomic) id<DJSelectPeopleViewControllerDelegate> delegate;
@property (assign,nonatomic) DJSelectPeopleType spType;

@end
