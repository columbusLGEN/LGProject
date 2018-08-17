//
//  DCRichTextBottomInfoView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
@class DCSubPartStateModel;

@interface DCRichTextBottomInfoView : LGBaseView
@property (strong,nonatomic) DCSubPartStateModel *model;
+ (instancetype)richTextBottomInfo;

@end
