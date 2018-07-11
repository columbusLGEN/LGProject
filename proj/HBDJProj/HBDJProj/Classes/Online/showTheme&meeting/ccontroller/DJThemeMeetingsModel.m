//
//  DJThemeMeetingsModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThemeMeetingsModel.h"
#import "DJOnlineUploadTableModel.h"

@implementation DJThemeMeetingsModel

/// 返回主题党日数组
- (NSArray<DJOnlineUploadTableModel *> *)tableModelsWithType:(NSInteger)type{
    NSMutableArray *pArray = [self propertyArray];
    NSString *plistName;
    if (type == 0) {
        /// 主题党日
        [pArray removeObjectAtIndex:0];
        plistName = @"OLUplaodThemeTable";
    }
    if (type == 1) {
        /// 三会一课
        plistName = @"OLUplaodThreeMeetingsTable";
    }
    NSArray *tableModels = [DJOnlineUploadTableModel loadLocalPlistWithPlistName:plistName];
    NSMutableArray *arrayMutable = [NSMutableArray arrayWithArray:tableModels];
    
    /// 删除 封面cell
    for (NSInteger i = arrayMutable.count - 1; i > -1; i--) {
        DJOnlineUploadTableModel *model = arrayMutable[i];
        if (model.itemClass == OLUploadTableModelClassSelectCover) {
            [arrayMutable removeObject:model];
        }
    }
    
    /// 如果是会议模型，需要多添加一个属性 会议标签 怎么加？
    
    for (int i = 0; i < arrayMutable.count; i++) {
        DJOnlineUploadTableModel *model = arrayMutable[i];

        if (i > pArray.count - 1){
            break;
        }
        NSString *key = pArray[i];
        id value = [self valueForKey:key];
        model.content = value;
        NSLog(@"value: %@",value);
    }
    return arrayMutable.copy;
}

- (NSMutableArray *)propertyArray{
    u_int count = 0;
    
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    
    NSMutableArray *arrayProperty = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertys[i]);
        [arrayProperty addObject:[NSString stringWithUTF8String:propertyName]];
    }
    //    NSLog(@"propertys: %@",arrayProperty);
    return arrayProperty;
}

//- (void)setPropertyValueWithArray:(NSArray<DJOnlineUploadTableModel *> *)array{
//    for (int i = 0; i < array.count; i++) {
//        DJOnlineUploadTableModel *tableModel = array[i];
//        if (i > self.propertyArray.count - 1) {
//            break;
//        }
//        NSString *key = self.propertyArray[i];
//
//        if (tableModel.content == nil) {
//            continue;
//        }
//        [self setValue:tableModel.content forKey:key];
//    }
//}

@end
