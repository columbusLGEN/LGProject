//
//  ECRBookrackDownloadCenter.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECRBookrackModel,ECRDownloadStateModel;

@interface ECRBookrackDownloadCenter : NSObject
/** 1 = 全部图书，2 = 已购买 */
@property (assign,nonatomic) ECRBookrackCurrentPlace currentPlace;
/** 全部图书模型数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *allBookModels;
/** 已购买模型数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *bookrackModels;


/**
 关联全部图书 和 已购买图书的下载状态

 @param dsModel 下载模型
 */
- (void)combineWithdsModel:(ECRDownloadStateModel *)dsModel;

+ (instancetype)sharedInstance;
@end
