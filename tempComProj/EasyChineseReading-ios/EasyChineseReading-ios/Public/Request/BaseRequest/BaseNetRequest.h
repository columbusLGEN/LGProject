//
//  BaseNetRequest.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseNetRequest : NSObject

CM_SINGLETON_INTERFACE(BaseNetRequest)

//@property (strong, nonatomic) UserModel *user;

@property (strong, nonatomic) __block NSMutableArray *arrDataSource;

// ---------------- 9.19 备注 暂时应用不到 page 直接请求
//@property (nonatomic,strong) __block PageModel * page;

// 输入字符编码转义（主要用于搜索）
- (NSString *)encodeToPercentEscapeString:(NSString *)string;

@end
