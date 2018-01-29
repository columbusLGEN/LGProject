//
//  ECRBookrackDownloadCenter.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookrackDownloadCenter.h"
#import "ECRDownloadStateModel.h"
#import "ECRBookrackModel.h"
#import "ECRBookDownloadStateView.h"

@interface ECRBookrackDownloadCenter ()


@end

@implementation ECRBookrackDownloadCenter


- (void)combineWithdsModel:(ECRDownloadStateModel *)dsModel{
    
    if (self.currentPlace == 1) {
        // 遍历已购买 -> 文件中 alreadyBooks
        [self.bookrackModels enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.alreadyBuyBooks.count) {
                [obj.alreadyBuyBooks enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull floderModel, NSUInteger floderModel_idx, BOOL * _Nonnull floderModel_stop) {
                    if (floderModel.bookId == dsModel.brModel.bookId) {
                        floderModel.dsModel.dsView.model = dsModel;
                        
                    }
                }];
            }else{
                if (obj.bookId == dsModel.brModel.bookId) {
                    // 已购买模型的下载状态需要改变
                    obj.dsModel.dsView.model = dsModel;
                }
            }
        }];
    }
    if (self.currentPlace == 2) {
        // 遍历全部图书
        [self.allBookModels enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.books.count) {
                [obj.books enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull floderModel, NSUInteger idx_floderModel, BOOL * _Nonnull stop_floderModel) {
                    if (floderModel.bookId == dsModel.brModel.bookId) {
                        floderModel.dsModel.dsView.model = dsModel;
                        
                    }
                }];
            }else{
                if (obj.bookId == dsModel.brModel.bookId) {
                    // 已购买模型的下载状态需要改变
                    obj.dsModel.dsView.model = dsModel;
                }
            }
        }];
    }
    
}

//- (void)traversalWithArray:(NSArray<ECRBookrackModel *> *)array dsModel:(ECRDownloadStateModel *)dsModel{
//    [array enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (<#condition#>) {
//            <#statements#>
//        }
//
//    }];
//}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
