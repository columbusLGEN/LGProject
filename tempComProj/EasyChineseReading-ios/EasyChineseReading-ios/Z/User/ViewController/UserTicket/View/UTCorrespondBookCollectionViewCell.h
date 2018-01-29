//
//  UTCorrespondBookCollectionViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/24.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UTCorrespondBookCollectionViewCell;

@protocol UTCorrespondBookCollectionViewCellDelegate<NSObject>

- (void)addBookToShopCarWithBook:(BookModel *)book;

@end

@interface UTCorrespondBookCollectionViewCell : ECRBaseCollectionViewCell

@property (weak, nonatomic) id<UTCorrespondBookCollectionViewCellDelegate> delegate;
@property (assign, nonatomic) NSInteger index; 

@end
