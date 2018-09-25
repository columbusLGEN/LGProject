//
//  EDJOnlineController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

@class EDJOnlineFlowLayout;

@interface EDJOnlineController : NSObject
@property (strong,nonatomic) EDJOnlineFlowLayout *flowLayout;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *onlineModels;

/** 在线顶部展位图片 高度 */
+ (CGFloat)headerHeight;

/// testcode ---> 接入接口之后,参数由 plistName 调整为 接口请求名,另外酌情添加param 参数
- (void)getDataWithPlistName:(NSString *)plistName;

@end
