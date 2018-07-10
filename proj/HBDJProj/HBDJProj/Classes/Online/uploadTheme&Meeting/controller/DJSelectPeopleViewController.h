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
    /** 出席 */
    DJSelectPeopleTypePresent,
    /** 缺席 */
    DJSelectPeopleTypeAbsent,
    /** 主持人 */
    DJSelectPeopleTypeHost
};

@class DJSelectPeopleViewController,DJOnlineUploadTableModel;

@protocol DJSelectPeopleViewControllerDelegate <NSObject>
- (void)selectPeopleDone:(DJSelectPeopleViewController *)vc model:(DJOnlineUploadTableModel *)model spType:(DJSelectPeopleType)spType;

@end

@interface DJSelectPeopleViewController : LGBaseViewController
@property (weak,nonatomic) id<DJSelectPeopleViewControllerDelegate> delegate;
@property (assign,nonatomic) DJSelectPeopleType spType;
@property (strong,nonatomic) DJOnlineUploadTableModel *model;

@property (strong,nonatomic) NSArray *allPeople;

@end
