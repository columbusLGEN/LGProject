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

@implementation UCPersonInfoViewController

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
    
    _uploadDataManager = DJUploadDataManager.new;
    _coverManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUserinfo)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"更换头像: ");
        [_uploadDataManager presentAlbunListViewControllerWithViewController:self manager:_coverManager selectSuccess:^(NSURL *coverFileUrl) {
            
        } uploadProgress:^(NSProgress *uploadProgress) {
            NSLog(@"上传封面: %f",
                  (CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(id dict) {
            //        NSLog(@"上传封面回调: %@",dict);
            NSString *path = dict[path_key];
            
            /// 上传数据
            NSDictionary *param = @{dj_updateUserInfoKey(DJUpdateUserInfoKeyImage):path};
            [DJUserNetworkManager.sharedInstance frontUserinfo_updateWithInfoDict:param success:^(id responseObj) {
                /// 更新cell上的头像
                NSString *iconUrl;
//                iconUrl = responseObj[@"iconUrl"];
                /// TODO: 头像链接赋值
                DJUser.sharedInstance.image = iconUrl;
                [self updateInfoWithUser:DJUser.sharedInstance];
                
                
            } failure:^(id failureObj) {
                
            }];

        } failure:^(id uploadFailure) {
            
        }];
    }
    
}


@end
