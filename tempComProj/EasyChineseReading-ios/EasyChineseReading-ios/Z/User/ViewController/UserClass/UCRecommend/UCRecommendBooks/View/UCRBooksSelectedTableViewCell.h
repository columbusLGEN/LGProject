//
//  ECRBooksSelectedTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCRBooksSelectedTableViewCell;

@protocol UCRBooksSelectedTableViewCellDelegate <NSObject>

- (void)removeSelectedBook:(id)book;

@end

@interface UCRBooksSelectedTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UCRBooksSelectedTableViewCellDelegate> delegate;

@end
