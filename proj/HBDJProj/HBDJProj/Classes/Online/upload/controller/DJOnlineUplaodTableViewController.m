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
#import "DJSelectPeopleViewController.h"

#import "LGSelectImgManager.h"
#import "HXPhotoPicker.h"

@interface DJOnlineUplaodTableViewController ()<
DJSelectDateViewControllerDelegate,
DJSelectPeopleViewControllerDelegate,
DJOnlineUploadAddCoverCellDelegate>
@property (assign,nonatomic) OnlineModelType listType;
@property (strong,nonatomic) NSArray *array;

/** 选择图片管理者 */
@property (strong,nonatomic) LGSelectImgManager *simgr;

/// 上传时需要提交的 表单数据
@property (strong,nonatomic) NSMutableDictionary *formDataDict;

@property (strong,nonatomic) HXPhotoManager *coverSelectMgr;
@property (strong,nonatomic) NSURL *coverFileUrl;

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

#pragma mark - 上传数据
- (void)uploadData{
    NSLog(@"表单数据: %@",self.formDataDict);
    
    [[LGNetworkManager sharedInstance] uploadWithUrl:@"http://192.168.12.37:8080/APMKAFService/frontUserinfo/uploadFile" param:@{@"userid":[DJUser sharedInstance].userid,@"pic":@"",@"filename":@""} localFileUrl:_coverFileUrl fieldName:@"pic" fileName:@""];
    
    /// TODO: 先上传图片，拿到图片的地址回调，再上传JSON
//    [LGSelectImgManager.sharedInstance.tempImageUrls enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"图片本地url: %@",obj);
//    }];
        
}
/// MARK: DJOnlineUploadAddCoverCell 添加封面代理
- (void)addCoverClick:(DJOnlineUploadAddCoverCell *)cell{
    [self hx_presentAlbumListViewControllerWithManager:self.coverSelectMgr done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        [HXPhotoTools selectListWriteToTempPath:photoList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
            NSLog(@"cover_photoList: %@",photoList);
            /// 选择完成之后需要做  件事
            /// 1.更新UI
            /// 2.保存封面图片的本地临时路径
            if (photoList.count) {
                _coverFileUrl = imageUrls[0];
            }
        } error:^{
            NSLog(@"selectPhotoError");
        }];
        
    } cancel:^(HXAlbumListViewController *viewController) {
        
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
/// MARK: 暴露给cell，改变表单的值
- (void)setFormDataDictValue:(nonnull id)value indexPath:(NSIndexPath *)indexPath{
    NSString *key = [self keyWithIndexPath:indexPath];
    [self.formDataDict setValue:value forKey:key];
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
    
    if ([cell isKindOfClass:[DJOnlineUploadAddCoverCell class]]) {
        DJOnlineUploadAddCoverCell *addCoverCell = (DJOnlineUploadAddCoverCell *)cell;
        addCoverCell.delegate = self;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *model = self.array[indexPath.row];
    switch (model.itemClass) {
        case OLUploadTableModelClassSelectTime:{
            DJSelectDateViewController *selectTime = DJSelectDateViewController.new;
            selectTime.delegate = self;
            selectTime.cellIndex = indexPath;
            selectTime.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:selectTime animated:YES completion:nil];
        }
            break;
        case OLUploadTableModelClassSelectPeopleNotCome:{
            [self selectPeopleVcWithSpType:DJSelectPeopleTypeNotCome];
        }
            break;
        case OLUploadTableModelClassSelectPeople:{
            [self selectPeopleVcWithSpType:DJSelectPeopleTypeCome];
        }
            break;
        case OLUploadTableModelClassSelectCover:
            NSLog(@"选则封面: ");
        case OLUploadTableModelClassSelectImage:
            NSLog(@"选则会议图片: ");
        default:
            break;
    }
}

/// MARK: DJSelectDateViewController 日期选择回调
- (void)selectDate:(DJSelectDateViewController *)vc dateString:(NSString *)dateString cellIndex:(NSIndexPath *)cellIndex{
    DJOnlineUploadTableModel *model = self.array[cellIndex.row];
    model.content = dateString;
    [self setFormDataDictValue:dateString indexPath:cellIndex];
    
}
/// MARK: DJSelectPeopleViewControllerDelegate 选择人员回调
- (void)selectPeopleDone:(DJSelectPeopleViewController *)vc peopleList:(NSArray *)peopleList spType:(DJSelectPeopleType)spType{
    
    NSString *desc;
    if (spType == DJSelectPeopleTypeCome) {
        desc = @"参会";
    }
    if (spType == DJSelectPeopleTypeNotCome) {
        desc = @"缺席";
    }
    for (int i = 0; i < peopleList.count; i++) {
        NSLog(@"%@人员: %@",desc,[peopleList[i] valueForKey:@"name"]);
    }
    /// TODO: 设置参会人员和缺席人员到表单数据
    
}

#pragma mark - 私有方法
- (void)selectPeopleVcWithSpType:(DJSelectPeopleType)spType{
    DJSelectPeopleViewController *selectPeople = DJSelectPeopleViewController.new;
    selectPeople.spType = spType;
    selectPeople.delegate = self;
    selectPeople.pushWay = LGBaseViewControllerPushWayModal;
    selectPeople.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:selectPeople animated:YES completion:nil];
}
- (NSString *)keyWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:/// 主题
            return @"theme";
            break;
        case 1:/// 时间
            return @"time";
            break;
        case 2:/// 地点
            return @"site";
            break;
        case 3:/// 主题人
            return @"hostMan";
            break;
        case 4:/// 参会人员
            return @"memberCome";
            break;
        case 5:/// 缺席人员
            return @"memberNotCome";
            break;
        case 6:/// 活动内容
            return @"content";
            break;
        case 7:/// 封面链接
            return @"coverUrl";
            break;
        case 8:/// 图片链接
            return @"imgUrls";
            break;
        default:///
            return @"other";
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
- (HXPhotoManager *)coverSelectMgr {
    if (!_coverSelectMgr) {
        _coverSelectMgr = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _coverSelectMgr.configuration.singleSelected = YES;
        _coverSelectMgr.configuration.albumListTableView = ^(UITableView *tableView) {
            //            NSSLog(@"%@",tableView);
        };
        _coverSelectMgr.configuration.singleJumpEdit = YES;
        _coverSelectMgr.configuration.movableCropBox = YES;
        _coverSelectMgr.configuration.movableCropBoxEditSize = YES;
        //        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
    }
    return _coverSelectMgr;
}

@end
