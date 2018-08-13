//
//  DJOnlineUplaodTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewController.h"

@protocol DJOnlineUplaodTableViewControllerDelegate <NSObject>
- (void)threeMeetingOrThemeUploadDone;

@end

@interface DJOnlineUplaodTableViewController : LGBaseTableViewController

@property (weak,nonatomic) id<DJOnlineUplaodTableViewControllerDelegate> delegate;

/// MARK: 暴露给cell，改变表单的值
- (void)setFormDataDictValue:(nonnull id)value indexPath:(NSIndexPath *)indexPath;

/// MARK: 需要暴露给子类的
/** 上传时需要提交的 表单数据 */ 
//@property (strong,nonatomic) NSMutableDictionary *formDataDict;
- (void)setCoverFormDataWithUrl:(NSString *)url;
- (void)setImagesFormDataWithArray:(NSArray *)imgUrls;
- (void)requestUploadWithFormData:(NSDictionary *)formData success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

@end
