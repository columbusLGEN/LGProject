//
//  DJUploadDataManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 上传图片管理者

#import <Foundation/Foundation.h>
#import <HXWeiboPhotoPicker/HXPhotoView.h>

typedef void(^DJSelectCoverSuccess)(NSURL *coverFileUrl);
//typedef void(^DJUploadCoverProgress)(CGFloat rate);
//typedef void(^DJUploadCoverSuccess)(NSString *imageUrl);
//typedef void(^DJUploadCoverFailure)(id error);
typedef void (^DJUploadImageComplete)(NSArray *imageUrls,NSDictionary *formData);
typedef void (^DJUploadFileComplete)(id dict);

@interface DJUploadDataManager : NSObject<HXPhotoViewDelegate>

/** 记录了所选照片的本地临时路径 */
@property (strong,nonatomic) NSMutableArray *tempImageUrls;

/**
 formdata 判空校验

 @param array 表单模型数组
 @return 必填项为空的项目名，如果为空，表示所有必填项都有值
 */
- (NSString *)msgByFormdataVerifyWithTableModels:(NSArray *)array;

/**
 设置表单数据的 value for key

 @param value 值
 @param key 键
 */
- (void)setUploadValue:(id)value key:(NSString *)key;

/** 发现党员舞台上传文件接口,目前仅用作上传视频 */
- (void)ugc_uploadFileWithMimeType:(NSString *)mimeType success:(DJUploadImageComplete)completeBlock singleFileComplete:(DJUploadFileComplete)singleFileComplete;

/**
 上传图片

 @param localFileUrl 图片本地URL
 @param progress 上传进度
 @param success 上传成功回调
 @param failure 上传失败回调
 */
- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure;


/**
 选择并上传封面

 @param vc 需要弹出封面选择页面的控制器
 @param manager hx框架的相册管理者
 @param selectSuccess 确认封面后的回调，用于在vc上显示已选择的封面
 @param progress 上传封面到服务器的进度
 @param success 上传封面到服务器成功回调
 @param failure 上传封面到服务器失败回调
 */
- (void)presentAlbunListViewControllerWithViewController:(UIViewController *)vc manager:(HXPhotoManager *)manager selectSuccess:(DJSelectCoverSuccess)selectSuccess uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure;

/** 上传内容图片,本地图片源: tempImageUrls */
- (void)uploadContentImageWithSuccess:(DJUploadImageComplete)completeBlock;

@end
