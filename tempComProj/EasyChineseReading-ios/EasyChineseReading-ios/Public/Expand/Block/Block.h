//
//  Block.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#ifndef Block_h
#define Block_h

/** 网络请求返回结果 */
typedef void(^ReturnBlock)(id object,NSError *error);
/** 网络状态放回结果 */
typedef void(^NetworkStateBlock)(id networkState);

#endif /* Block_h */
