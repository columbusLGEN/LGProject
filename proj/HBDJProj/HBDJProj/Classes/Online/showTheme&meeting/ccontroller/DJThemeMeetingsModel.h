//
//  DJThemeMeetingsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJOnlineUploadTableModel;

@interface DJThemeMeetingsModel : NSObject

/** 会议标签 */
@property (strong,nonatomic) NSString *meetTag;
/** 主题 */
@property (strong,nonatomic) NSString *title;
/** 时间 */
@property (strong,nonatomic) NSString *time;
/** 地点 */
@property (strong,nonatomic) NSString *location;
/** 主持人 */
@property (strong,nonatomic) NSString *host;
/** 到会人 */
@property (strong,nonatomic) NSString *presents;
/** 缺席人 */
@property (strong,nonatomic) NSString *absents;
/** 内容 */
@property (strong,nonatomic) NSString *meetContent;
/** 图片链接 */
@property (strong,nonatomic) NSString *imageUrls;

/// 将服务器返回的单个数据转换成表单数据
/// 0: 主题党日，1: 三会一课
- (NSArray<DJOnlineUploadTableModel *> *)tableModelsWithType:(NSInteger)type;

//- (void)setPropertyValueWithArray:(NSArray<DJOnlineUploadTableModel *> *)array;

@end
