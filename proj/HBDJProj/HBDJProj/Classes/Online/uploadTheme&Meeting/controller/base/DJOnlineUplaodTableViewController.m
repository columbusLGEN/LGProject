//
//  DJOnlineUplaodTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUplaodTableViewController.h"

#import "DJOnlineUploadTableModel.h"
#import "DJSelectPeopleModel.h"

#import "DJOnlineUplaodBaseCell.h"
#import "DJOnlineUploadCell.h"
#import "DJOnlineUploadAddPeopleCell.h"
#import "DJOnlineUploadAddCoverCell.h"
#import "DJOnlineUploadAddImgCell.h"
#import "DJOnlineUploadSelectMeetingTag.h"

#import "DJSelectDateViewController.h"
#import "DJSelectPeopleViewController.h"
#import "DJSelectMeetingTagViewController.h"
#import "DJInputContentViewController.h"

#import "LGSelectImgManager.h"
#import "HXPhotoPicker.h"

@interface DJOnlineUplaodTableViewController ()<
DJSelectDateViewControllerDelegate,
DJSelectPeopleViewControllerDelegate,
DJOnlineUploadAddCoverCellDelegate,
DJSelectMeetingTagViewControllerDelegate,
DJOnlineUploadCellDelegate,
DJInputContentViewControllerDelegate>

/** 选择图片管理者 */
@property (strong,nonatomic) LGSelectImgManager *simgr;

/// 上传时需要提交的 表单数据
@property (strong,nonatomic) NSMutableDictionary *formDataDict;

@property (strong,nonatomic) HXPhotoManager *coverSelectMgr;
@property (strong,nonatomic) NSURL *coverFileUrl;

@property (strong,nonatomic) HXPhotoView *cellSelectedImageView;

@property (strong,nonatomic) NSArray *allPeople;
/** 出席人员 */
@property (strong,nonatomic) NSMutableArray *peoplePresent;
/** 缺席人员 */
@property (strong,nonatomic) NSMutableArray *peopleAbsent;
/**主持人 */
@property (strong,nonatomic) NSMutableArray *peopleHost;

@end

@implementation DJOnlineUplaodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[DJOnlineUploadCell class] forCellReuseIdentifier:inputTextCell];
    [self.tableView registerClass:[DJOnlineUploadAddPeopleCell class] forCellReuseIdentifier:addPeopleCell];
    [self.tableView registerClass:[DJOnlineUploadAddCoverCell class] forCellReuseIdentifier:addCoverCell];
    [self.tableView registerClass:[DJOnlineUploadAddImgCell class] forCellReuseIdentifier:addImgCell];
    [self.tableView registerClass:[DJOnlineUploadSelectMeetingTag class] forCellReuseIdentifier:selectMeetingTagCell];
    self.tableView.estimatedRowHeight = 1.0;
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadData)];
    self.navigationItem.rightBarButtonItem = send;
    
    _cellSelectedImageView = [[HXPhotoView alloc] initWithFrame:CGRectZero manager:self.simgr.hxPhotoManager];
}

#pragma mark - 上传数据
- (void)uploadData{
    NSLog(@"表单数据: %@",self.formDataDict);
    if (!_coverFileUrl) {
        NSLog(@"请选择封面: ");
        return;
    }
    /// http://123.59.199.170:8081
    /// http://192.168.12.93:8080
    
    [[LGNetworkManager sharedInstance] uploadImageWithUrl:@"http://123.59.199.170:8081/APMKAFService/frontUserinfo/uploadFile" param:@{@"userid":[DJUser sharedInstance].userid,@"pic":@"",@"filename":@""} localFileUrl:_coverFileUrl fieldName:@"pic" fileName:@"" uploadProgress:^(NSProgress *uploadProgress) {
        NSLog(@"上传封面进度: %f",(CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSString *imgUrl_sub) {
        NSLog(@"上传封面成功，图片路径: %@",imgUrl_sub);
        
    } failure:^(id uploadFailure) {
        NSLog(@"上传封面失败: %@",uploadFailure);
    }];
    
    /// TODO: 先上传图片，拿到图片的地址回调，再上传JSON
//    [LGSelectImgManager.sharedInstance.tempImageUrls enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"图片本地url: %@",obj);
//    }];
        
}
/// MARK: DJOnlineUploadAddCoverCell 添加封面 代理方法
- (void)addCoverClick:(DJOnlineUploadAddCoverCell *)cell{
    [self hx_presentAlbumListViewControllerWithManager:self.coverSelectMgr done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        [HXPhotoTools selectListWriteToTempPath:photoList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
//            NSLog(@"cover_photoList: %@",photoList);
            
            /// 选择完成之后需要做  件事
            /// 1.更新UI
            
            /// 2.保存封面图片的本地临时路径
            if (photoList.count) {
                _coverFileUrl = imageUrls[0];
                
                cell.model.coverBackUrl = _coverFileUrl;
                [self.tableView reloadData];
            }
        } error:^{
            NSLog(@"selectPhotoError");
        }];
        
    } cancel:^(HXAlbumListViewController *viewController) {
        
    }];
}
/// MARK: DJSelectMeetingTagViewControllerDelegate 选择会议标签回调
- (void)selectMeetingTag:(DJSelectMeetingTagViewController *)vc selectString:(NSString *)string{
//    NSLog(@"父类选中了: %@",string);
}

/// MARK: DJOnlineUploadCellDelegate 文本输入框代理
- (void)userWantBeginInputWithModel:(DJOnlineUploadTableModel *)model cell:(DJOnlineUploadCell *)cell{
    DJInputContentViewController *vc = DJInputContentViewController.new;
    vc.model = model;
    vc.delegate = self;
    vc.pushWay = LGBaseViewControllerPushWayModal;
    LGBaseNavigationController *nav = [LGBaseNavigationController.alloc initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
/// MARK: DJInputContentViewControllerDelegate 输入文本代理回调
- (void)inputContentViewController:(DJInputContentViewController *)vc model:(DJOnlineUploadTableModel *)model{
    [self.formDataDict setValue:model.content forKey:model.uploadJsonKey];
    [self.tableView reloadData];
}

#pragma mark -  setter
/// MARK: 暴露给cell，改变表单的值
- (void)setFormDataDictValue:(nonnull id)value indexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *model = self.dataArray[indexPath.row];
    NSString *key = model.uploadJsonKey;
    [self.formDataDict setValue:value forKey:key];
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}
/// MARK: tableview datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJOnlineUploadTableModel *model = self.dataArray[indexPath.row];
    
    DJOnlineUplaodBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DJOnlineUplaodBaseCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.vc = self;
    cell.model = model;
    if ([cell isMemberOfClass:[DJOnlineUploadAddImgCell class]]) {
        DJOnlineUploadAddImgCell *addImageCell = (DJOnlineUploadAddImgCell *)cell;
        addImageCell.photoView = _cellSelectedImageView;
    }
    
    if ([cell isMemberOfClass:[DJOnlineUploadAddCoverCell class]]) {
        DJOnlineUploadAddCoverCell *addCoverCell = (DJOnlineUploadAddCoverCell *)cell;
        addCoverCell.delegate = self;
    }
    if ([cell isMemberOfClass:[DJOnlineUploadCell class]]) {
        DJOnlineUploadCell *textInputCell = (DJOnlineUploadCell *)cell;
        textInputCell.delegate = self;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *model = self.dataArray[indexPath.row];
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
            [self selectPeopleVcWithSpType:DJSelectPeopleTypeAbsent model:model];
        }
            break;
        case OLUploadTableModelClassSelectPeople:{
            [self selectPeopleVcWithSpType:DJSelectPeopleTypePresent model:model];
        }
            break;
        case OLUploadTableModelClassSelectCover:NSLog(@"封面: ");
            break;
        case OLUploadTableModelClassSelectImage:NSLog(@"会议图片: ");
            break;
        case OLUploadTableModelClassSelectMeetingTag:{
            /// 选择会议标签
            DJSelectMeetingTagViewController *selectMeetingTag = DJSelectMeetingTagViewController.new;
            selectMeetingTag.delegate = self;
            selectMeetingTag.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:selectMeetingTag animated:YES completion:nil];
        }
        case OLUploadTableModelClassSelectHost:{
            [self selectPeopleVcWithSpType:DJSelectPeopleTypeHost model:model];
        }
        default:
            break;
    }
}

/// MARK: DJSelectDateViewController 选择日期回调
- (void)selectDate:(DJSelectDateViewController *)vc dateString:(NSString *)dateString cellIndex:(NSIndexPath *)cellIndex{
    DJOnlineUploadTableModel *model = self.dataArray[cellIndex.row];
    model.content = dateString;
    [self setFormDataDictValue:dateString indexPath:cellIndex];
    
}
/// MARK: DJSelectPeopleViewControllerDelegate 选人回调
- (void)selectPeopleDone:(DJSelectPeopleViewController *)vc model:(DJOnlineUploadTableModel *)model spType:(DJSelectPeopleType)spType{
    
    for (int i = 0; i < self.allPeople.count; i++) {
        DJSelectPeopleModel *model = self.allPeople[i];
        if (model.select_present) {
            /// 出席人员
            [self.peoplePresent addObject:model.name];
        }
        if (model.select_absent) {
            /// 缺席人员
            [self.peopleAbsent addObject:model.name];
        }
    }
    NSString *peoples;
    switch (spType) {
        case DJSelectPeopleTypePresent:{
            peoples = [self.peoplePresent componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeAbsent:{
            peoples = [self.peopleAbsent componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeHost:{
            peoples = model.content;
        }
            break;
    }
    [self.formDataDict setValue:peoples forKey:model.uploadJsonKey];
    model.content = peoples;
    /// 更新cell中的数据
    [self.tableView reloadData];
}


#pragma mark - 私有方法
- (void)selectPeopleVcWithSpType:(DJSelectPeopleType)spType model:(DJOnlineUploadTableModel *)model{
    switch (spType) {
        case DJSelectPeopleTypePresent:
            [self.peoplePresent removeAllObjects];
            break;
        case DJSelectPeopleTypeAbsent:
            [self.peopleAbsent removeAllObjects];
            break;
        case DJSelectPeopleTypeHost:
            
            break;
    }
    /// MARK: 创建并弹出选人控制器
    DJSelectPeopleViewController *selectPeople = DJSelectPeopleViewController.new;
    selectPeople.model = model;
    selectPeople.spType = spType;
    selectPeople.delegate = self;
    selectPeople.allPeople = self.allPeople;
    selectPeople.pushWay = LGBaseViewControllerPushWayModal;
    selectPeople.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:selectPeople animated:YES completion:nil];
    
}

#pragma mark - lazy load & getter
- (LGSelectImgManager *)simgr{
    if (!_simgr) {
        _simgr = LGSelectImgManager.new;
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
        };
        _coverSelectMgr.configuration.singleJumpEdit = YES;
        _coverSelectMgr.configuration.movableCropBox = YES;
        _coverSelectMgr.configuration.movableCropBoxEditSize = YES;
    }
    return _coverSelectMgr;
}
- (NSMutableArray *)peoplePresent{
    if (!_peoplePresent) {
        _peoplePresent = NSMutableArray.new;
    }
    return _peoplePresent;
}
- (NSMutableArray *)peopleAbsent{
    if (!_peopleAbsent) {
        _peopleAbsent = NSMutableArray.new;
    }
    return _peopleAbsent;
}
- (NSMutableArray *)peopleHost{
    if (!_peopleHost) {
        _peopleHost = NSMutableArray.new;
    }
    return _peopleHost;
}
- (NSArray *)allPeople{
    if (!_allPeople) {
        NSMutableArray *arrMutable = NSMutableArray.new;
        for (int i = 0; i < self.tmpNames.count; i++) {
            DJSelectPeopleModel *model = DJSelectPeopleModel.new;
            model.name = self.tmpNames[i];
            /// 默认全员出席
            model.attend = DJMemeberAttendTypePresent;
            model.select_present = YES;
            [arrMutable addObject:model];
        }
        _allPeople = arrMutable.copy;
    }
    return _allPeople;
}
- (NSArray *)tmpNames{
    return @[@"党伟大",@"李建国",@"张爱国",@"网钢铁",@"孙建军",@"赵爱民",@"刘国庆"];
}

@end
