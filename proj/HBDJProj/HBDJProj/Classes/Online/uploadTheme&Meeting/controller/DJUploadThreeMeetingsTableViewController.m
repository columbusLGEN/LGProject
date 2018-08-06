//
//  DJUploadThreeMeetingsTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadThreeMeetingsTableViewController.h"
#import "DJSelectMeetingTagViewController.h"
#import "DJOnlineNetorkManager.h"
#import "DJOnlineUploadTableModel.h"

/** 支部党员大会 */
static NSString *zhibudangyuandahui = @"支部党员大会";
/** 党支部委员会 */
static NSString *dangzhibuweiyuanhui = @"党支部委员会";
/** 党小组会 */
static NSString *dangGroup = @"党小组会";
/** 党课 */
static NSString *dangLesson = @"党课";

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

/// MARK: 选择会议标签 DJSelectMeetingTagViewControllerDelegate
- (void)selectMeetingTag:(DJSelectMeetingTagViewController *)vc selectString:(NSString *)string{
    if (self.dataArray.count != 0) {
        DJOnlineUploadTableModel *firstModel = self.dataArray[0];
        firstModel.content = string;
        [self setFormDataDictValue:@([self meetingTagIdWithString:string]) indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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

/// 上传 三会一课
- (void)requestUploadWithFormData:(NSDictionary *)formData success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [DJOnlineNetorkManager.sharedInstance addSessionsWithFormdict:[formData mutableCopy] success:success failure:failure];
    
}

+ (NSArray *)tagStrings{
    return @[zhibudangyuandahui,
             dangzhibuweiyuanhui,
             dangGroup,
             dangLesson,];
}

- (NSInteger)meetingTagIdWithString:(NSString *)string{
    if ([string isEqualToString:zhibudangyuandahui]) {
        return 1;
    }else if ([string isEqualToString:dangzhibuweiyuanhui]){
        return 2;
    }else if ([string isEqualToString:dangGroup]){
        return 3;
    }else if ([string isEqualToString:dangLesson]){
        return 4;
    }else{
        return 0;
    }
}

@end
