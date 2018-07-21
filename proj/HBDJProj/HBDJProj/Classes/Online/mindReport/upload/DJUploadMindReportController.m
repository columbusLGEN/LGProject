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
#import "DJUploadMindReportCoverCell.h"
#import "DJUploadMindReportImageCell.h"
#import "HXPhotoPicker.h"
#import "DJInputContentViewController.h"

@interface DJUploadMindReportController ()<
HXPhotoViewDelegate,
DJInputContentViewControllerDelegate,
DJUploadMindReportCoverCellDelegate>
@property (strong,nonatomic) NSMutableDictionary *formData;

@property (strong,nonatomic) HXPhotoView *cellSelectedImageView;
@property (strong,nonatomic) HXPhotoManager *hxPhotoManager;

@property (strong,nonatomic) HXPhotoManager *nineImageManager;
@property (strong,nonatomic) NSURL *coverFileUrl;

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
    self.tableView.estimatedRowHeight = 1.0;
    
    self.dataArray = [DJUploadMindReportLineModel loadLocalPlistWithPlistName:@"DJOnlineUploadConfig"];
    [self.tableView reloadData];
    
    _hxPhotoManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypePhoto];
    
    _cellSelectedImageView = [HXPhotoView.alloc initWithManager:_hxPhotoManager];
    _cellSelectedImageView.delegate = self;
    
    _formData = NSMutableDictionary.new;
    
    _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypePhoto];
}

- (void)uploadData{
    NSLog(@"发送数据: 开始上传");
}

#pragma mark - HXPhotoViewDelegate
/// MARK: 选择图片回调
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    
}

/// MARK: DJOnlineUploadAddCoverCell 添加封面 代理方法
- (void)addCoverClick:(DJUploadMindReportCoverCell *)cell{
    NSLog(@"cell: %@",cell);
    NSLog(@"cell.model: %@",cell.model);
    [self hx_presentAlbumListViewControllerWithManager:_nineImageManager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        [HXPhotoTools selectListWriteToTempPath:photoList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
            /// 选择完成之后需要做  件事
            /// 1.更新UI
            /// 2.保存封面图片的本地临时路径
            if (imageUrls.count) {
                _coverFileUrl = imageUrls[0];

//                /// MARK: 上传封面
//                [self uploadImageWithLocalFileUrl:_coverFileUrl uploadProgress:^(NSProgress *uploadProgress) {
//                    NSLog(@"上传封面: %f",
//                          (CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//                } success:^(NSString *imgUrl_sub) {
//                    NSLog(@"上传封面成功: %@",imgUrl_sub);
//                    /// 主题党日 index == 7，三会一课 index == 8
//                    /// 子类分别实现
//                    [self setCoverFormDataWithUrl:imgUrl_sub];
//                } failure:^(id uploadFailure) {
//                    NSLog(@"上传封面失败: %@",uploadFailure);
//                }];
//
                cell.model.coverBackUrl = _coverFileUrl;
                [self.tableView reloadData];
                
            }
        } error:^{
            NSLog(@"selectPhotoError");
        }];
        
    } cancel:^(HXAlbumListViewController *viewController) {
        
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
    
    [_formData setValue:model.content forKey:model.uploadJsonKey];
    [self.tableView reloadData];
}


@end
