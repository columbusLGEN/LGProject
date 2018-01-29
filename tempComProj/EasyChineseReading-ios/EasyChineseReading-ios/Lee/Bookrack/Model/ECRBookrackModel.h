//
//  ECRBookrackModel.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ECRBookModelDownloadState) {
    ECRBookModelDownloadStateNormal,
    ECRBookModelDownloadStateDownloading,   // 下载中
    ECRBookModelDownloadStatePause,         // 暂停
    ECRBookModelDownloadStateDone           // 下载完成
};

#import "BookModel.h"
@class ECRDownloadStateModel;

@interface ECRBookrackModel : BookModel<NSCopying>

/** 下载状态模型 */
@property (strong,nonatomic) ECRDownloadStateModel *dsModel;

@property (assign,nonatomic) NSInteger id;//
/** 书籍数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *books;
/** 已购买书籍数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *alreadyBuyBooks;
/** 书架分组名称 */
@property (copy,nonatomic)   NSString *groupName;
/** // 书籍名称 */
@property (copy,nonatomic)   NSString *name;
/** 书架分组id */
@property (assign,nonatomic) NSInteger groupId;
/** 1 = 全部图书，2 = 已购买 */
@property (assign,nonatomic) ECRBookrackCurrentPlace currentPlace;
/** 1 = 编辑状态，0 = 常规状态 */
@property (assign,nonatomic) BOOL isEditState;
/** 0;默认 1:本地导入 */
@property (assign,nonatomic) BOOL iTunesResource;

@property (strong,nonatomic) id lg_keyValues;//

/** 本地文件封面 */
@property (strong,nonatomic) UIImage *localFileCover;

- (void)createGroupWithFromModel:(ECRBookrackModel *)fromModel toModel:(ECRBookrackModel *)toModel currentPlace:(NSInteger)currentPlace;
- (void)addBooksWithFromModel:(ECRBookrackModel *)fromModel currentPlace:(NSInteger)currentPlace;

@end
