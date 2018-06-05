//
//  EDJMicroPartyLessionSonModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// MARK: 微党课单条模型
#import "LGBaseModel.h"

@interface EDJMicroPartyLessionSubModel : LGBaseModel

@property (strong,nonatomic) NSNumber *peopleCount;
@property (strong,nonatomic) NSNumber *time;
@property (copy,nonatomic) NSString *imgUrl;

/** 专辑id */
@property (assign,nonatomic) NSInteger classid;
/** audio */
@property (strong,nonatomic) NSString *audio;
/** vedio */
@property (strong,nonatomic) NSString *vedio;
/** status */
@property (assign,nonatomic) NSInteger status;
/** resourcestate */
@property (strong,nonatomic) NSString *resourcestate;
/** label */
@property (strong,nonatomic) NSString *label;
/** playcount */
@property (assign,nonatomic) NSInteger playcount;
/** content */
@property (strong,nonatomic) NSString *content;
/** title */
@property (strong,nonatomic) NSString *title;
/** creatorid */
@property (assign,nonatomic) NSInteger creatorid;
/** source */
@property (strong,nonatomic) NSString *source;
/** createdtime */
@property (strong,nonatomic) NSString *createdtime;
/** praisecount */
@property (assign,nonatomic) NSInteger praisecount;
/** modaltype */
@property (assign,nonatomic) NSInteger modaltype;
/** contentvalidity */
@property (strong,nonatomic) NSString *contentvalidity;


/** parentclassid */
@property (strong,nonatomic) NSString *parentclassid;
/** classname */
@property (strong,nonatomic) NSString *classname;
/** classdescription */
@property (strong,nonatomic) NSString *classdescription;


@end
