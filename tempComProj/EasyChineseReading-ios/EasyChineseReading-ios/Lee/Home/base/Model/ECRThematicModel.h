//
//  ECRThematicModel.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRThematicModel : NSObject

@property (assign,nonatomic) NSInteger seqid;//
/** 首页封面 */
@property (copy,nonatomic) NSString *specialPic;
/** 专题页封面 */
@property (copy,nonatomic) NSString *templetimg;
@property (copy,nonatomic) NSString *thematicName;//
/** 英文主题名称 */
@property (copy,nonatomic) NSString *en_thematicName;


@end
