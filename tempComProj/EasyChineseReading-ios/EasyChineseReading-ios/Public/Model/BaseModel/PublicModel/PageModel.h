//
//  PageModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface PageModel : BaseModel

/**
 分页
 */

@property (assign, nonatomic) NSInteger P_Current_Page;  //当前页
@property (assign, nonatomic) NSInteger P_Item_Count;    //当前页显示的数量
@property (assign, nonatomic) NSInteger P_Last_Page;     //总页数
@property (assign, nonatomic) NSInteger P_Per_Page;      //当前页最大显示数量
@property (assign, nonatomic) NSInteger P_Query_Offset;  //当前的offset值
@property (assign, nonatomic) NSInteger P_Total_Page;    //总页数
@property (assign, nonatomic) NSInteger P_Total_Count;   //总记录数

@end
