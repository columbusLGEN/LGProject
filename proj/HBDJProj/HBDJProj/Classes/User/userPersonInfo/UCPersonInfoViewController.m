//
//  UCPersonInfoViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPersonInfoViewController.h"
#import "UCPersonInfoModel.h"
#import "UCPersonInfoTableViewCell.h"
#import "DJUploadDataManager.h"

@interface UCPersonInfoViewController ()
@property (strong,nonatomic) NSArray *array;
@property (strong,nonatomic) DJUploadDataManager *uploadDataManager;
@property (strong,nonatomic) HXPhotoManager *coverManager;

@end

@implementation UCPersonInfoViewController{
    MBProgressHUD *uploadTipView;
    BOOL avadaterUpdated;/// 是否更新了头像
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    self.title = @"个人信息";
    _array = [UCPersonInfoModel userInfoArray];
    [self.tableView reloadData];
    
    self.tableView.estimatedRowHeight = 100.0f;
    _uploadDataManager = DJUploadDataManager.new;
    _coverManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    _coverManager.configuration.singleSelected = YES;
    _coverManager.configuration.singleJumpEdit = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUserinfo)];
    
    uploadTipView = [MBProgressHUD.alloc initWithView:self.view];
    uploadTipView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    uploadTipView.mode = MBProgressHUDModeIndeterminate;
    uploadTipView.label.text = @"上传中...";
    
    [uploadTipView hideAnimated:NO];
}

- (void)getUserinfo{
    [DJUserNetworkManager.sharedInstance frontUserinfo_selectSuccess:^(id responseObj) {
        [self.tableView.mj_header endRefreshing];
        
        DJUser *user = [DJUser mj_objectWithKeyValues:responseObj];
        
        [self updateInfoWithUser:user];
        
    } failure:^(id failureObj) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)updateInfoWithUser:(DJUser *)user{
    /// 用户信息本地化
    [user keepUserInfo];
    
    /// 将本地用户信息赋值给单利对象,保证每次用户重新登录之后，都会重新赋值
    [[DJUser sharedInstance] getLocalUserInfo];
    
    _array = [UCPersonInfoModel userInfoArray];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCPersonInfoModel *model = _array[indexPath.row];
    UCPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCPersonInfoTableViewCell cellReuseIdWithModel:model]];
    cell.model = model;
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 46;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentCameraViewController];
        }];
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentAlbunListViewController];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        
        [camera setValue:UIColor.EDJGrayscale_11 forKey:@"titleTextColor"];
        [photo setValue:UIColor.EDJGrayscale_11 forKey:@"titleTextColor"];
        [cancel setValue:UIColor.EDJMainColor forKey:@"titleTextColor"];
        
        [alertvc addAction:camera];
        [alertvc addAction:photo];
        [alertvc addAction:cancel];
        [self presentViewController:alertvc animated:YES completion:nil];
        
    }
    
}

- (void)presentAlbunListViewController{
    
    [UIApplication.sharedApplication.keyWindow addSubview:uploadTipView];
    
    [_uploadDataManager lg_presentAlbunListViewControllerWithViewController:self noticeView:uploadTipView manager:_coverManager selectSuccess:^(NSURL *coverFileUrl) {
        
    } uploadProgress:^(NSProgress *uploadProgress) {
        NSLog(@"上传头像_相册选择: %f",
              (CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(id dict) {
        
        [self sendUpdateRequestWithDict:dict];
    } failure:^(id uploadFailure) {
        [self hideAndRemoveTipView];
    }];
    

}
- (void)presentCameraViewController{
    
    [UIApplication.sharedApplication.keyWindow addSubview:uploadTipView];
    
    [_uploadDataManager lg_presentCustomCameraViewControllerWithViewController:self noticeView:uploadTipView manager:_coverManager selectSuccess:^(NSURL *coverFileUrl) {
        
    } uploadProgress:^(NSProgress *uploadProgress) {
        NSLog(@"上传头像_相机选择: %f",
              (CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(id dict) {
        [self sendUpdateRequestWithDict:dict];
        
    } failure:^(id uploadFailure) {
        [self hideAndRemoveTipView];
    }];
}

- (void)sendUpdateRequestWithDict:(id)dict{
    NSString *path = dict[path_key];
    
    /// 上传数据
    NSDictionary *param = @{dj_updateUserInfoKey(DJUpdateUserInfoKeyImage):path};
    [DJUserNetworkManager.sharedInstance frontUserinfo_updateWithInfoDict:param success:^(id responseObj) {
        /// 更新cell上的头像
        NSString *iconUrl = responseObj[@"path"];
        DJUser.sharedInstance.image = iconUrl;
        [self updateInfoWithUser:DJUser.sharedInstance];
        [self hideAndRemoveTipView];
        avadaterUpdated = YES;
        
    } failure:^(id failureObj) {
        [self hideAndRemoveTipView];
    }];
}
- (void)hideAndRemoveTipView{
    [uploadTipView hideAnimated:YES];
    [uploadTipView removeFromSuperview];
}

- (void)dealloc{
    if (avadaterUpdated) {
        if ([self.delegate respondsToSelector:@selector(pivcUpdateAvadater:)]) {
            [self.delegate pivcUpdateAvadater:[NSURL URLWithString:DJUser.sharedInstance.image]];
        }
    }
}

@end
