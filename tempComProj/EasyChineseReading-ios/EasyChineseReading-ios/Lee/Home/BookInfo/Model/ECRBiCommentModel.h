//
//  ECRBiCommentModel.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRBiCommentModel : NSObject

@property (copy,nonatomic) NSString *id;
@property (copy,nonatomic) NSString *userName;
@property (copy,nonatomic) NSString *iconURL;
@property (assign,nonatomic) NSInteger *score;

@end
