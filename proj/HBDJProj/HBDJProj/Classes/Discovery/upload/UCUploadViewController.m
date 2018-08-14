//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadViewController.h"
#import "DJUploadDataManager.h"

#import "DJUploadMindReportBaseCell.h"
#import "DJUploadPYQTextCell.h"
#import "DJUploadPYQImageCell.h"
#import "DJUploadMindReportLineModel.h"
#import "DJInputContentViewController.h"

@interface UCUploadViewController ()<DJInputContentViewControllerDelegate>
@property (strong,nonatomic) NSArray *array;
@property (strong,nonatomic) HXPhotoView *cellSelectedImageView;
@property (strong,nonatomic) HXPhotoManager *nineImageManager;
@property (strong,nonatomic) DJUploadDataManager *uploadDataManager;

@end

@implementation UCUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    
    /// 导航部分
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont fontWithName:textBold size:17];/// 加粗
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.navigationItem.rightBarButtonItem = send;
    
    [self.tableView registerClass:[DJUploadPYQTextCell class] forCellReuseIdentifier:uploadPYQTextCell];
    [self.tableView registerClass:[DJUploadPYQImageCell class] forCellReuseIdentifier:uploadPYQImageCell];
    self.tableView.estimatedRowHeight = 1.0;
    
    /// 图片 & 视频
    if (_uploadAction == DJUPloadPyqActionImg) {
        _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    if (_uploadAction == DJUPloadPyqActionVideo) {
        _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypeVideo];
    }
    _cellSelectedImageView = [HXPhotoView.alloc initWithManager:_nineImageManager];
    _cellSelectedImageView.delegate = _uploadDataManager;
    
    /// TODO: 音频 从上个页面拿到音频文件（链接）
    if (_uploadAction == DJUPloadPyqActionAudio) {
        /// 音频
        self.dataArray = [DJUploadMindReportLineModel loadLocalPlistWithPlistName:@"UCUploadPyqAudioConfig"];
    }else{
        /// 视频和图片
        /// 备注：文字上传页面不在此页面进行操作
        self.dataArray = [DJUploadMindReportLineModel loadLocalPlistWithPlistName:@"UCUploadPyqPhotoConfig"];
    }
    
    [self.tableView reloadData];
}

/// MARK: 文本输入控制器代理回调
- (void)inputContentViewController:(DJInputContentViewController *)vc model:(DJOnlineUploadTableModel *)model{
    /// MARK: 设置表单数据
    [_uploadDataManager setUploadValue:model.content key:model.uploadJsonKey];
    [self.tableView reloadData];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DJUploadMindReportLineModel *model = self.dataArray[indexPath.row];
    DJUploadMindReportBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DJUploadMindReportBaseCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    
    cell.model = model;
    
    if ([cell isMemberOfClass:[DJUploadPYQImageCell class]]) {
        DJUploadPYQImageCell *pyqImageCell  = (DJUploadPYQImageCell *)cell;
        pyqImageCell.photoView = _cellSelectedImageView;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJUploadMindReportLineModel *model = self.dataArray[indexPath.row];
    if (model.lineType == DJUploadMindReportLineTypePyqText) {
        /// 进入文本输入
        [self presentViewController:[DJInputContentViewController modalInputvcWithModel:model delegate:self] animated:YES completion:nil];
    }
}

#pragma mark - target
- (void)cancelClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendClick{
    NSLog(@"发送 -- ");
    
}

@end
