//
//  EDJHomeImageLoopModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessionSubModel.h"

@interface EDJHomeImageLoopModel : EDJMicroPartyLessionSubModel
/** 图片地址 */
@property (strong,nonatomic) NSString *classimg;
/** BaseClassesId */
//@property (assign,nonatomic) BaseClassesId classid;


/** classname */
//@property (strong,nonatomic) NSString *classname;
/** newsid: 如果有值，表示详情；否则表示习近平要闻列表 */
@property (assign,nonatomic) NSObject *newsid;

/** parentclassid */
//@property (assign,nonatomic) NSInteger parentclassid;

/** classdescription */
//@property (strong,nonatomic) NSString *classdescription;

@end
