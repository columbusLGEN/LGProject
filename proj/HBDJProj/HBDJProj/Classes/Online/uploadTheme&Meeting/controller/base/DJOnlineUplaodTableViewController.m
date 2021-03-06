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

/** 若为YES，表示正在上传中，禁止用户重复操作 */
@property (assign,nonatomic) BOOL uploading;

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
    self.tableView.estimatedRowHeight = 100.0;
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(uploadData)];
    self.navigationItem.rightBarButtonItem = send;
    
    /// 选择/上传 图片管理者封装
    _uploadDataManager = DJUploadDataManager.new;
    
    _coverManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    _coverManager.configuration.singleSelected = YES;
    _coverManager.configuration.movableCropBox = YES;
    _coverManager.configuration.movableCropBoxEditSize = YES;
    _coverManager.configuration.movableCropBoxCustomRatio = CGPointMake(16, 9);
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
                
//                /// 默认全员出席
//                model.attend = DJMemeberAttendTypePresent;
//                model.select_present = YES;
                
                // TODO: Zup_默认全不选
                model.attend = DJMemeberAttendTypeDefault;
//                model.select_absent = YES;

                
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
    
    if (_uploading) {
        return;
    }
    
    /// MARK: 数据校验
    NSString *msg = [_uploadDataManager msgByFormdataVerifyWithTableModels:self.dataArray];
    
    if (msg) {
        /// TODO: 弹窗提示改为系统弹窗吗?
        [self presentFailureTips:[NSString stringWithFormat:@"%@不能为空",msg]];
        return;
    }
    
    /// MARK: 上传内容图片
    MBProgressHUD *uploadTipView = [MBProgressHUD wb_showActivityMessage:@"上传中..." toView:self.view];
    _uploading = YES;

    [_uploadDataManager uploadContentImageWithSuccess:^(NSArray *imageUrls, NSDictionary *formData) {
        
        [uploadTipView hideAnimated:YES];
        
        if (imageUrls != nil) {/// 如果有图片
            [self setImagesFormDataWithArray:imageUrls.copy];
        }

        /// MARK: 发送上传数据请求
        [self requestUploadWithFormData:formData success:^(id responseObj) {
//            NSLog(@"上传成功: %@",responseObj);
            
            [self presentSuccessTips:@"上传成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(threeMeetingOrThemeUploadDone)]) {
                    [self.delegate threeMeetingOrThemeUploadDone];
                }
                _uploading = NO;
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(id failureObj) {
            _uploading = NO;
            [self presentMessageTips:@"上传失败，请稍后重试"];
//            NSLog(@"上传失败: %@",failureObj);
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
    } success:^(id dict) {
//        NSLog(@"上传封面回调: %@",dict);
        NSString *path = dict[path_key];
        /// 设置表单数据
        [self setCoverFormDataWithUrl:path];
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
            selectTime.lastMonth = YES;
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
    
    /// 选择缺席人员 和 到会人员 数据如何联动？
    /// 其实此时数组中的数据已经同步了，当前问题就是 如何 修改model的content？
    /// 选择到会人员时，怎么修改缺席人员的content
    /// 选择缺席人员时，怎么修改到会人员的content
    
    [self.peoplePresent removeAllObjects];
    [self.peoplePresentNames removeAllObjects];
    [self.peopleAbsent removeAllObjects];
    [self.peopleAbsentNames removeAllObjects];
    
    NSMutableArray *host = NSMutableArray.new;
    
    for (int i = 0; i < self.allPeople.count; i++) {
        DJSelectPeopleModel *peolple_model = self.allPeople[i];
        
        // TODO: Zup_可以全不选择，直接全员归属为另一部分
//        if (peolple_model.select_present) {
//            /// 出席人员
//            [self.peoplePresent addObject:@(peolple_model.seqid)];
//            [self.peoplePresentNames addObject:peolple_model.name];
//        }
//        if (peolple_model.select_absent) {
//            /// 缺席人员
//            [self.peopleAbsent addObject:@(peolple_model.seqid)];
//            [self.peopleAbsentNames addObject:peolple_model.name];
//        }
        if (spType == DJSelectPeopleTypePresent) { // 选择的是出席
            if (peolple_model.select_present) {
                /// 出席人员
                [self.peoplePresent addObject:@(peolple_model.seqid)];
                [self.peoplePresentNames addObject:peolple_model.name];
            } else {
                /// 缺席人员
                [self.peopleAbsent addObject:@(peolple_model.seqid)];
                [self.peopleAbsentNames addObject:peolple_model.name];
            }
        } else if (spType == DJSelectPeopleTypeAbsent) { // 选择的是缺席
            if (peolple_model.select_absent) {
                /// 缺席人员
                [self.peopleAbsent addObject:@(peolple_model.seqid)];
                [self.peopleAbsentNames addObject:peolple_model.name];
            } else {
                /// 出席人员
                [self.peoplePresent addObject:@(peolple_model.seqid)];
                [self.peoplePresentNames addObject:peolple_model.name];
            }
        }
        
        if (peolple_model.select_host) {
            [host addObject:@(peolple_model.seqid)];
        }
    }
    NSString *peoples;
    NSString *peopleNames;
    switch (spType) {
        case DJSelectPeopleTypePresent:{
            /// 当前模型是到会人员
            /// 获取缺席人员模型
            
            NSInteger index = [self.dataArray indexOfObject:model] + 1;
            DJOnlineUploadTableModel *absentModel = self.dataArray[index];
            NSString *absentString = [self.peopleAbsentNames componentsJoinedByString:@"、"];
            /// 如果没有缺席人员，给缺席人员赋值为 无
            if ([absentString isEqualToString:@""] || absentString == nil) {
                absentString = @"无";
            }
            absentModel.content = absentString;
            [_uploadDataManager setUploadValue:[self.peopleAbsent componentsJoinedByString:@","] key:absentModel.uploadJsonKey];/// 提交给后台的数据 人的id
            
            peoples = [self.peoplePresent componentsJoinedByString:@","];
            peopleNames = [self.peoplePresentNames componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeAbsent:{
            
            /// 当前模型是缺席人员
            /// 获取到会人员模型
            NSInteger index = [self.dataArray indexOfObject:model] - 1;
            DJOnlineUploadTableModel *presentModel = self.dataArray[index];
            presentModel.content = [self.peoplePresentNames componentsJoinedByString:@"、"];
            [_uploadDataManager setUploadValue:[self.peoplePresent componentsJoinedByString:@","] key:presentModel.uploadJsonKey];
            
            peoples = [self.peopleAbsent componentsJoinedByString:@","];
            peopleNames = [self.peopleAbsentNames componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeHost:{
            
            if (host.count) {
                peoples = host[0];                
            }
            peopleNames = model.content;
        }
            break;
    }
    
    [_uploadDataManager setUploadValue:peoples key:model.uploadJsonKey];/// 提交给后台的数据 人的id
    // TODO: Zup_如果没有选中的人员，显示无
    model.content = peopleNames.length > 0 ? peopleNames : @"无";/// 显示在页面上的数据 name
    NSLog(@"peoplename %@", peopleNames);
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
//- (void)requestUploadWithFormData:(NSDictionary *)formData success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
//    
//}
- (void)setCoverFormDataWithUrl:(NSString *)url{
    
}
- (void)setImagesFormDataWithArray:(NSArray *)imgUrls{
    
}

@end
