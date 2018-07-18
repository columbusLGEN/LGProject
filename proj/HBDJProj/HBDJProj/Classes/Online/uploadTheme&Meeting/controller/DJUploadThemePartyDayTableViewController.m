//
//  DJUploadThemePartyDayTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadThemePartyDayTableViewController.h"
#import "DJOnlineUploadTableModel.h"

@interface DJUploadThemePartyDayTableViewController ()

@end

@implementation DJUploadThemePartyDayTableViewController

@synthesize dataArray = _dataArray;

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [DJOnlineUploadTableModel loadLocalPlistWithPlistName:@"OLUplaodThemeTable"];
//        NSLog(@"_dataarray: %@",_dataArray);
    }
    return _dataArray;
}

- (void)setCoverFormDataWithUrl:(NSString *)url{
    /// 主题党日 index == 7，三会一课 index == 8
    [self setFormDataDictValue:url indexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
}
- (void)setImagesFormDataWithArray:(NSArray *)imgUrls{
    NSString *urls_string = [imgUrls componentsJoinedByString:@","];
    [self setFormDataDictValue:urls_string indexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
}

@end
