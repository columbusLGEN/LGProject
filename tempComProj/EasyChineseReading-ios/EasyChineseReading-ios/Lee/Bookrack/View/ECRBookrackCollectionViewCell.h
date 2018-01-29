//
//  ECRBookrackCollectionViewCell.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRBookrackModel,ECRBookrackCollectionViewCell,ECRBookDownloadStateView;

@protocol ECRBookrackCollectionViewCellDelegate <NSObject>

- (void)brCellBookEditDidClick:(ECRBookrackCollectionViewCell *)cell inx:(NSIndexPath *)inx model:(ECRBookrackModel *)model;

@end

@interface ECRBookrackCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) NSIndexPath *inx;
@property (strong,nonatomic) ECRBookrackModel *model;
@property (weak,nonatomic) id<ECRBookrackCollectionViewCellDelegate> delegate;
@property (strong,nonatomic) IBOutlet ECRBookDownloadStateView *bdsView;//book download state view

@end
