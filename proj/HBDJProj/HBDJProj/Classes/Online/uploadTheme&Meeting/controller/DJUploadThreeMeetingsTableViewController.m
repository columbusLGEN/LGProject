//
//  DJUploadThreeMeetingsTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadThreeMeetingsTableViewController.h"
#import "DJSelectMeetingTagViewController.h"

#import "DJOnlineUploadTableModel.h"

@interface DJUploadThreeMeetingsTableViewController ()<
DJSelectMeetingTagViewControllerDelegate>

@end

@implementation DJUploadThreeMeetingsTableViewController

@synthesize dataArray = _dataArray;

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [DJOnlineUploadTableModel loadLocalPlistWithPlistName:@"OLUplaodThreeMeetingsTable"];
    }
    return _dataArray;
}

/// MARK: DJSelectMeetingTagViewControllerDelegate
- (void)selectMeetingTag:(DJSelectMeetingTagViewController *)vc selectString:(NSString *)string{
    if (self.dataArray.count != 0) {
        DJOnlineUploadTableModel *firstModel = self.dataArray[0];
        firstModel.content = string;
        [self setFormDataDictValue:string indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    [self.tableView reloadData];
}
- (void)setCoverFormDataWithUrl:(NSString *)url{
    /// 主题党日 index == 7，三会一课 index == 8
    [self setFormDataDictValue:url indexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
}
- (void)setImagesFormDataWithArray:(NSArray *)imgUrls{
    NSString *urls_string = [imgUrls componentsJoinedByString:@","];
    [self setFormDataDictValue:urls_string indexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
}

@end
