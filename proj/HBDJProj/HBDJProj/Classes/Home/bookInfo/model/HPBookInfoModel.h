//
//  HPBookInfoModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface HPBookInfoModel : LGBaseModel

/// testcode
@property (assign,nonatomic) BOOL isHeader;
@property (copy,nonatomic) NSString *testPressTime;
@property (copy,nonatomic) NSString *testProgress;

@property (copy,nonatomic) NSString *coverUrl;
@property (copy,nonatomic) NSString *bookName;
@property (copy,nonatomic) NSString *author;
@property (copy,nonatomic) NSString *press;
@property (assign,nonatomic) CGFloat pressTime;
@property (assign,nonatomic) CGFloat readProgress;

/// --------------以下为 简介 或 目录用到的属性
/** 是否展开显示全部，默认为NO */
@property (assign,nonatomic) BOOL showAll;
/** 项目标题，“简介” 或者 “目录”*/
@property (copy,nonatomic) NSString *itemTitle;
/** 显示内容 */
@property (copy,nonatomic) NSString *content;

@end
