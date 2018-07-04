//
//  DJOnlineUplaodTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUplaodTableViewController.h"

#import "DJOnlineUploadTableModel.h"

#import "DJOnlineUplaodBaseCell.h"
#import "DJOnlineUploadCell.h"
#import "DJOnlineUploadAddPeopleCell.h"
#import "DJOnlineUploadAddCoverCell.h"
#import "DJOnlineUploadAddImgCell.h"

#import "DJSelectDateViewController.h"

#import "LGSelectImgManager.h"

@interface DJOnlineUplaodTableViewController ()
@property (assign,nonatomic) OnlineModelType listType;
@property (strong,nonatomic) NSArray *array;

/** 选择图片管理者 */
@property (strong,nonatomic) LGSelectImgManager *simgr;

@end

@implementation DJOnlineUplaodTableViewController

- (instancetype)initWithListType:(OnlineModelType)listType{
    self.listType = listType;
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[DJOnlineUploadCell class] forCellReuseIdentifier:inputTextCell];
    [self.tableView registerClass:[DJOnlineUploadAddPeopleCell class] forCellReuseIdentifier:addPeopleCell];
    [self.tableView registerClass:[DJOnlineUploadAddCoverCell class] forCellReuseIdentifier:addCoverCell];
    [self.tableView registerClass:[DJOnlineUploadAddImgCell class] forCellReuseIdentifier:addImgCell];
    self.tableView.estimatedRowHeight = 1.0;
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadData)];
    self.navigationItem.rightBarButtonItem = send;
}

- (void)uploadData{
    NSLog(@"上传:");
    /// TODO: 先上传图片，拿到图片的地址回调，再上传JSON
    [LGSelectImgManager.sharedInstance.tempImageUrls enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"image: %@",[UIImage imageWithContentsOfFile:obj.relativePath]);
    }];
}

#pragma mark -  setter
- (void)setListType:(OnlineModelType)listType{
    _listType = listType;
    switch (listType) {
        case OnlineModelTypeThreeMeetings:
            self.array = self.threeMeetingsItems;
            break;
        case OnlineModelTypeThemePartyDay:            
            self.array = self.themePartyDayItems;
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
/// MARK: tableview datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJOnlineUploadTableModel *model = self.array[indexPath.row];
    
    DJOnlineUplaodBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DJOnlineUplaodBaseCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.vc = self;
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *model = self.array[indexPath.row];
    switch (model.itemClass) {
        case OLUploadTableModelClassSelectTime:{
            DJSelectDateViewController *selectTime = DJSelectDateViewController.new;
            selectTime.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:selectTime animated:YES completion:nil];
        }
            break;
        case OLUploadTableModelClassSelectPeople:
            NSLog(@"选人: ");
            break;
        case OLUploadTableModelClassSelectCover:
            NSLog(@"选则封面: ");
        case OLUploadTableModelClassSelectImage:
            NSLog(@"选则会议图片: ");
        default:
            break;
    }
}

#pragma mark - lazy load getter
- (NSArray *)themePartyDayItems{
    return [DJOnlineUploadTableModel loadLocalPlistWithPlistName:@"OLUplaodThemeTable"];
}
- (NSArray *)threeMeetingsItems{
    return @[@"会议标签:",
             @"会议主题:",
             @"会议时间:",
             @"会议地点:",
             @"会议主持人:",
             @"到会人员:",
             @"缺席人员:",
             @"会议内容:",
             @"添加图片:"];
}
- (LGSelectImgManager *)simgr{
    if (!_simgr) {
        _simgr = LGSelectImgManager.sharedInstance;
    }
    return _simgr;
}
- (NSMutableDictionary *)formDataDict{
    if (!_formDataDict) {
        _formDataDict = NSMutableDictionary.new;
    }
    return _formDataDict;
}

@end
