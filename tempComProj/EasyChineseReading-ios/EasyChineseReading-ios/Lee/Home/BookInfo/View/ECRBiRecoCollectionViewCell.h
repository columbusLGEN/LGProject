//
//  ECRBiRecoCollectionViewCell.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRRecoBook,ECRBiRecoCollectionViewCell;

@protocol ECRBiRecoCollectionViewCellDelegate <NSObject>

- (void)birecoBookClick:(ECRBiRecoCollectionViewCell *)cell model:(ECRRecoBook *)recoBook;

@end

@interface ECRBiRecoCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) ECRRecoBook *model;

@property (weak,nonatomic) id<ECRBiRecoCollectionViewCellDelegate> delegate;//

@end
