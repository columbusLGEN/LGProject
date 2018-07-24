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
#import "DJOnlineNetorkManager.h"
#import "DJUploadDataManager.h"

@interface DJOnlineUplaodTableViewController ()<
DJSelectDateViewControllerDelegate,
DJSelectPeopleViewControllerDelegate,
DJOnlineUploadAddCoverCellDelegate,
DJSelectMeetingTagViewControllerDelegate,
DJOnlineUploadCellDelegate,
DJInputContentViewControllerDelegate>

/** 选择/上传图片管理者 */
@property (strong,nonatomic) DJUploadDataManager *uploadDataManager;

@property (strong,nonatomic) HXPhotoManager *coverManager;
@property (strong,nonatomic) HXPhotoManager *nineImageManager;
@property (strong,nonatomic) HXPhotoView *cellSelectedImageView;

@property (strong,nonatomic) NSArray *allPeople;
/** 出席人员 */
@property (strong,nonatomic) NSMutableArray *peoplePresent;
@property (strong,nonatomic) NSMutableArray *peoplePresentNames;
/** 缺席人员 */
@property (strong,nonatomic) NSMutableArray *peopleAbsent;
@property (strong,nonatomic) NSMutableArray *peopleAbsentNames;
/** 主持人 */
@property (strong,nonatomic) NSMutableArray *peopleHost;

@end

@implementation DJOnlineUplaodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self getOrganizeUser];
    
}

- (void)configUI{
    
    [self.tableView registerClass:[DJOnlineUploadCell class] forCellReuseIdentifier:inputTextCell];
    [self.tableView registerClass:[DJOnlineUploadAddPeopleCell class] forCellReuseIdentifier:addPeopleCell];
    [self.tableView registerClass:[DJOnlineUploadAddCoverCell class] forCellReuseIdentifier:addCoverCell];
    [self.tableView registerClass:[DJOnlineUploadAddImgCell class] forCellReuseIdentifier:addImgCell];
    [self.tableView registerClass:[DJOnlineUploadSelectMeetingTag class] forCellReuseIdentifier:selectMeetingTagCell];
    self.tableView.estimatedRowHeight = 1.0;
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadData)];
    self.navigationItem.rightBarButtonItem = send;
    
    /// 选择/上传 图片管理者封装
    _uploadDataManager = DJUploadDataManager.new;
    
    _coverManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    //    _coverSelectMgr.configuration.singleSelected = YES;
    //    _coverSelectMgr.configuration.albumListTableView = ^(UITableView *tableView) {
    //    };
    //    _coverSelectMgr.configuration.singleJumpEdit = YES;
    //    _coverSelectMgr.configuration.movableCropBox = YES;
    //    _coverSelectMgr.configuration.movableCropBoxEditSize = YES;
    
    _nineImageManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    _cellSelectedImageView = [[HXPhotoView alloc] initWithManager:_nineImageManager];
    _cellSelectedImageView.delegate = _uploadDataManager;
}

- (void)getOrganizeUser{
    /// MARK: 获取机构的人员
    NSMutableArray *arrMutable = NSMutableArray.new;
    [DJOnlineNetorkManager.sharedInstance frontUserinfoSuccess:^(id responseObj) {
        NSArray *array = responseObj;
        if (array == nil || array.count == 0) {
            /// 人员为空
            
        }else{
            for (NSInteger i = 0; i < array.count; i++) {
                DJSelectPeopleModel *model = [DJSelectPeopleModel mj_objectWithKeyValues:array[i]];
                
                /// 默认全员出席
                model.attend = DJMemeberAttendTypePresent;
                model.select_present = YES;
                
                [arrMutable addObject:model];
            }
            _allPeople = arrMutable.copy;
        }
    } failure:^(id failureObj) {
        /// 请求失败
        
    }];
}

#pragma mark - 上传数据
- (void)uploadData{
    /// TODO: 上传数据前的判空校验
//    if (!_coverFileUrl) {
//        NSLog(@"请选择封面: ");
//        return;
//    }
    
    /// MARK: 上传内容图片
    [_uploadDataManager uploadContentImageWithSuccess:^(NSArray *imageUrls, NSDictionary *formData) {
        
        /// TODO: 上传数据之前数据校验，如果用户选图片，如何上传？
        
        [self setImagesFormDataWithArray:imageUrls.copy];
        
        /// MARK: 发送上传数据请求
        [self requestUploadWithFormData:formData success:^(id responseObj) {
            NSLog(@"上传成功: %@",responseObj);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(id failureObj) {
            NSLog(@"上传失败: %@",failureObj);
        }];
    }];
        
}

/// MARK: DJOnlineUploadAddCoverCell 添加封面 代理方法
- (void)addCoverClick:(DJOnlineUploadAddCoverCell *)cell{
    
    /// MARK: 选择并上传封面
    [_uploadDataManager presentAlbunListViewControllerWithViewController:self manager:_coverManager selectSuccess:^(NSURL *coverFileUrl) {
        cell.model.coverBackUrl = coverFileUrl;
        [self.tableView reloadData];
    } uploadProgress:^(NSProgress *uploadProgress) {
        NSLog(@"上传封面: %f",
              (CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSString *imgUrl_sub) {
        /// 设置表单数据
        [self setCoverFormDataWithUrl:imgUrl_sub];
    } failure:^(id uploadFailure) {
        
    }];

}

/// MARK: DJOnlineUploadCellDelegate 弹出文本输入框
- (void)userWantBeginInputWithModel:(DJOnlineUploadTableModel *)model cell:(DJOnlineUploadCell *)cell{
    [self presentViewController:[DJInputContentViewController modalInputvcWithModel:model delegate:self] animated:YES completion:nil];
}
/// MARK: DJInputContentViewControllerDelegate 输入文本代理回调
- (void)inputContentViewController:(DJInputContentViewController *)vc model:(DJOnlineUploadTableModel *)model{
    [_uploadDataManager setUploadValue:model.content key:model.uploadJsonKey];
    [self.tableView reloadData];
}

#pragma mark -  setter
/// MARK: 暴露给cell，改变表单的值
- (void)setFormDataDictValue:(nonnull id)value indexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *model = self.dataArray[indexPath.row];
    NSString *key = model.uploadJsonKey;
    [_uploadDataManager setUploadValue:value key:key];
}

#pragma mark - delegate
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
    
    [self.peoplePresent removeAllObjects];
    [self.peoplePresentNames removeAllObjects];
    [self.peopleAbsent removeAllObjects];
    [self.peopleAbsentNames removeAllObjects];
    
    for (int i = 0; i < self.allPeople.count; i++) {
        DJSelectPeopleModel *model = self.allPeople[i];
        if (model.select_present) {
            /// 出席人员
            [self.peoplePresent addObject:@(model.seqid)];
            [self.peoplePresentNames addObject:model.name];
        }   
        if (model.select_absent) {
            /// 缺席人员
            [self.peopleAbsent addObject:@(model.seqid)];
            [self.peopleAbsentNames addObject:model.name];
        }
    }
    NSString *peoples;
    NSString *peopleNames;
    switch (spType) {
        case DJSelectPeopleTypePresent:{
            peoples = [self.peoplePresent componentsJoinedByString:@","];
            peopleNames = [self.peoplePresentNames componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeAbsent:{
            peoples = [self.peopleAbsent componentsJoinedByString:@","];
            peopleNames = [self.peopleAbsentNames componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeHost:{
            peoples = [NSString stringWithFormat:@"%ld",(long)model.seqid];
            peopleNames = model.content;
        }
            break;
    }
    NSLog(@"peoples: %@",peoples);
    NSLog(@"peopleNames: %@",peopleNames);
    [_uploadDataManager setUploadValue:peoples key:model.uploadJsonKey];/// 提交给后台的数据 人的id
    model.content = peopleNames;/// 显示在页面上的数据 name
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

- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    [[DJOnlineNetorkManager sharedInstance] uploadImageWithLocalFileUrl:localFileUrl uploadProgress:progress success:success failure:failure];
}

#pragma mark - lazy load & getter
- (NSMutableArray *)peoplePresent{
    if (!_peoplePresent) {
        _peoplePresent = NSMutableArray.new;
    }
    return _peoplePresent;
}
- (NSMutableArray *)peoplePresentNames{
    if (!_peoplePresentNames) {
        _peoplePresentNames = NSMutableArray.new;
    }
    return _peoplePresentNames;
}
- (NSMutableArray *)peopleAbsent{
    if (!_peopleAbsent) {
        _peopleAbsent = NSMutableArray.new;
    }
    return _peopleAbsent;
}
- (NSMutableArray *)peopleAbsentNames{
    if (!_peopleAbsentNames) {
        _peopleAbsentNames = NSMutableArray.new;
    }
    return _peopleAbsentNames;
}
- (NSMutableArray *)peopleHost{
    if (!_peopleHost) {
        _peopleHost = NSMutableArray.new;
    }
    return _peopleHost;
}

/// MARK: DJSelectMeetingTagViewControllerDelegate 选择会议标签回调
- (void)selectMeetingTag:(DJSelectMeetingTagViewController *)vc selectString:(NSString *)string{
    /// 父类不处理
}

/// 给子类实现
- (void)requestUploadWithFormData:(NSDictionary *)formData success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
}
- (void)setCoverFormDataWithUrl:(NSString *)url{
    
}
- (void)setImagesFormDataWithArray:(NSArray *)imgUrls{
    
}

@end
