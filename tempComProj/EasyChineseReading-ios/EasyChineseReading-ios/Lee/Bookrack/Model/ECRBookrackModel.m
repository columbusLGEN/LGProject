//
//  ECRBookrackModel.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBookrackModel.h"
#import "SDWebImageDownloader.h"
#import "LGPImageOperator.h"

@interface ECRBookrackModel ()

@end

@implementation ECRBookrackModel

- (id)copyWithZone:(NSZone *)zone{
    ECRBookrackModel *copyModel = [[ECRBookrackModel allocWithZone:zone] init];
    copyModel.dsModel = self.dsModel;
    copyModel.owendType = self.owendType;
    copyModel.eBookFormat = self.eBookFormat;
    copyModel.localURL = self.localURL;
    copyModel.locationUrl = self.locationUrl;
    copyModel.academicProbationUrl = self.academicProbationUrl;
    copyModel.downloadURL = self.downloadURL;
    
    copyModel.iconUrl = self.iconUrl;
    copyModel.currentPlace = 2;
    copyModel.id = self.id;
    copyModel.bookId = self.bookId;
    copyModel.books = self.books.mutableCopy;
    copyModel.alreadyBuyBooks = self.alreadyBuyBooks.mutableCopy;
    copyModel.groupName = self.groupName.mutableCopy;
    copyModel.name = self.name.mutableCopy;
    copyModel.groupId = self.groupId;
    copyModel.bookName = self.bookName.mutableCopy;
    copyModel.en_bookName = self.en_bookName.mutableCopy;
    
    return copyModel;
}

- (void)createGroupWithFromModel:(ECRBookrackModel *)fromModel toModel:(ECRBookrackModel *)toModel currentPlace:(NSInteger)currentPlace{
    if (currentPlace == 1) {// 全部图书
        self.books = [NSMutableArray arrayWithCapacity:10];
        [self.books addObject:fromModel];// 先加"手上"的
        [self.books addObject:toModel];
    }
    if (currentPlace == 2) {// 已购买
        [self.alreadyBuyBooks addObject:fromModel];// 先加"手上"的
        [self.alreadyBuyBooks addObject:toModel];
    }
    
}

- (void)addBooksWithFromModel:(ECRBookrackModel *)fromModel currentPlace:(NSInteger)currentPlace{
    if (currentPlace == 1) {// 全部图书
        [self.books insertObject:fromModel atIndex:0];
    }
    if (currentPlace == 2) {// 已购买
        [self.alreadyBuyBooks insertObject:fromModel atIndex:0];
    }
}

- (NSMutableArray<ECRBookrackModel *> *)alreadyBuyBooks{
    if (_alreadyBuyBooks == nil) {
        _alreadyBuyBooks = [NSMutableArray array];
    }
    return _alreadyBuyBooks;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"books":@"ECRBookrackModel"};
}

@end








