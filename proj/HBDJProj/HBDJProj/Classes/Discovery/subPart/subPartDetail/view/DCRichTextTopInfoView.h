//
//  DCRichTextTopInfoView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@interface DCRichTextTopInfoView : LGBaseView
+ (instancetype)richTextTopInfoView;
/** 是否显示,查看次数,默认为NO，不显示 */
@property (assign,nonatomic) BOOL displayCounts;
@end
