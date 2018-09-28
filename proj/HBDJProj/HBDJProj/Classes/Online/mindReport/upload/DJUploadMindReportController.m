//
//  DJUploadMindReportController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadMindReportController.h"
#import "DJUploadMindReportLineModel.h"
#import "DJUploadMindReportBaseCell.h"
#import "DJUploadMindReportTextCell.h"
#import "DJUploadMindReportImageCell.h"
#import "DJUploadMindReportCoverCell.h"
#import "DJInputContentViewController.h"
#import "DJOnlineNetorkManager.h"
#import "DJUploadDataManager.h"

@interface DJUploadMindReportController ()<
DJInputContentViewControllerDelegate,
DJUploadMindReportCoverCellDelegate>

@property (strong,nonatomic) HXPhotoView *cellSelectedImageView;
@property (strong,nonatomic) HXPhotoManager *nineImageManager;
@property (strong,nonatomic) HXPhotoManager *coverManager;

@property (strong,nonatomic) NSURL *coverFileUrl;
/** 记录了所选照片的本地临时路径 */
@property (strong,nonatomic) NSMutableArray *tempImageUrls;

@property (strong,nonatomic) DJUploadDataManager *uploadDataManager;
/** 若为YES，表示正在上传中，禁止用户重复操作 */
@property (assign,nonatomic) BOOL uploading;

@end

@implementation DJUploadMindReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    UIBarButtonItem *cancel = [UIBarButtonItem.alloc initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(baseViewControllerDismiss)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIButton *sendButton = UIButton.new;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:UIColor.EDJMainColor forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(uploadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *send = [UIBarButtonItem.alloc initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = send;
    
    [self.tableView registerClass:[DJUploadMindReportTextCell class] forCellReuseIdentifier:uploadMRTextCell];
    [self.tableView registerClass:[DJUploadMindReportCoverCell class] forCellReuseIdentifier:uploadMRAddCoverCell];
    [self.tableView registerClass:[DJUploadMindReportImageCell class] forCellReuseIdentifier:uploadMRAddImageCell];
    self.tableView.estimatedRowHeight = 100.0;
    
    self.dataArray = [DJUploadMindReportLineModel loadLocalPlistWithPlistName:@"DJOnlineUploadConfig"];
    [self.tableView reloadData];
    
    
    /// MARK: 选择图片 & 上传图 管理者
    _uploadDataManager = DJUploadDataManager.new;
    
    _coverManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypePhoto];
    _coverManager.configuration.singleSelected = YES;
    _coverManager.configuration.movableCropBox = YES;
    _coverManager.configuration.movableCropBoxEditSize = YES;
    _coverManager.configuration.movableCropBoxCustomRatio = CGPointMake(16, 9);
    _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypePhoto];
    _cellSelectedImageView = [HXPhotoView.alloc initWithManager:_nineImageManager];
    _cellSelectedImageView.delegate = _uploadDataManager;
    
}

- (void)uploadData{
    
    if (_uploading) {
        return;
    }
    
    /// MARK: 数据校验
    NSString *msg = [_uploadDataManager msgByFormdataVerifyWithTableModels:self.dataArray];
    
    if (msg) {
        /// TODO: 弹窗提示改为系统弹窗吗？
        [self presentFailureTips:[NSString stringWithFormat:@"%@不能为空",msg]];
        return;
    }
    
    /// MARK: 上传内容图片
    MBProgressHUD *uploadTipView = [MBProgressHUD wb_showActivityMessage:@"上传中..." toView:self.view];
    _uploading = YES;
    
    /// 上传图片
    [_uploadDataManager uploadContentImageWithSuccess:^(NSArray *imageUrls, NSDictionary *formData) {
        
        [uploadTipView hideAnimated:YES];
        
        DJUploadMindReportLineModel *imageLineModle = [self.dataArray lastObject];
        if (imageUrls) {        
            [_uploadDataManager setUploadValue:[imageUrls componentsJoinedByString:@","] key:imageLineModle.uploadJsonKey];
        }
        
        [DJOnlineNetorkManager.sharedInstance frontUgc_addWithFormData:[formData mutableCopy] ugctype:(self.listType - 4) filetype:1 success:^(id responseObj) {
            
            [self presentMessageTips:uploadNeedsCheckString];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _uploading = NO;
                [self baseViewControllerDismiss];

            });
            
        } failure:^(id failureObj) {
            _uploading = NO;
            [self presentMessageTips:@"上传失败，请稍后重试"];
        }];
        
    }];
}

/// MARK: DJOnlineUploadAddCoverCell 添加封面 代理方法
- (void)addCoverClick:(DJUploadMindReportCoverCell *)cell{
    [_uploadDataManager presentAlbunListViewControllerWithViewController:self manager:_coverManager selectSuccess:^(NSURL *coverFileUrl) {
        cell.model.coverBackUrl = coverFileUrl;
        [self.tableView reloadData];
    } uploadProgress:^(NSProgress *uploadProgress) {
        NSLog(@"思想汇报&述职述廉_上传封面: %f",
              (CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(id dict) {
        NSString *path = dict[path_key];
        /// 设置表单数据
        [_uploadDataManager setUploadValue:path key:cell.model.uploadJsonKey];
    } failure:^(id uploadFailure) {
        NSLog(@"思想汇报&述职述廉_上传封面失败: %@",uploadFailure);
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJUploadMindReportLineModel *model = self.dataArray[indexPath.row];
    DJUploadMindReportBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DJUploadMindReportBaseCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    
    cell.model = model;
    
    if ([cell isMemberOfClass:[DJUploadMindReportImageCell class]]) {
        DJUploadMindReportImageCell *imageCell = (DJUploadMindReportImageCell *)cell;
        imageCell.photoView = _cellSelectedImageView;
    }
    
    if ([cell isMemberOfClass:[DJUploadMindReportCoverCell class]]) {
        DJUploadMindReportCoverCell *addCoverCell  = (DJUploadMindReportCoverCell *)cell;
        addCoverCell.delegate = self;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJUploadMindReportLineModel *model = self.dataArray[indexPath.row];
    if (model.lineType == DJUploadMindReportLineTypeText) {
        /// 进入文本输入
        [self presentViewController:[DJInputContentViewController modalInputvcWithModel:model delegate:self] animated:YES completion:nil];
    }
}

/// MARK: 文本输入控制器代理回调
- (void)inputContentViewController:(DJInputContentViewController *)vc model:(DJOnlineUploadTableModel *)model{
    /// MARK: 设置表单数据
    [_uploadDataManager setUploadValue:model.content key:model.uploadJsonKey];
    [self.tableView reloadData];
}
#pragma mark - 私有方法

- (void)baseViewControllerDismiss{
    [super baseViewControllerDismiss];
}

@end
