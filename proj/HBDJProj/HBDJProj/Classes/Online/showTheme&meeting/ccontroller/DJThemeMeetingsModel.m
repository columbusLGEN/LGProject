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

- (NSString *)date{
    if (_date.length > length_timeString) {
        _date = [_date substringToIndex:(length_timeString + 1)];
    }
    return _date;
}

- (NSString *)createdtime{
    if (_createdtime.length > 10) {
        _createdtime = [_createdtime substringToIndex:10];
    }
    return _createdtime;
}

- (NSArray<DJOnlineUploadTableModel *> *)tableModelsWithType:(NSInteger)type{
    /// 获取自身属性列表
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
    
    /// 不显示封面
    for (NSInteger i = arrayMutable.count - 1; i > -1; i--) {
        DJOnlineUploadTableModel *model = arrayMutable[i];
        if (model.itemClass == OLUploadTableModelClassSelectCover) {
            [arrayMutable removeObject:model];
        }
    }

    /// 如果是三会一课模型，添加 会议标签
    for (int i = 0; i < arrayMutable.count; i++) {
        DJOnlineUploadTableModel *model = arrayMutable[i];

        if (i > pArray.count - 1){
            break;
        }
        NSString *key = pArray[i];
        id value = [self valueForKey:key];
        model.content = value;

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
