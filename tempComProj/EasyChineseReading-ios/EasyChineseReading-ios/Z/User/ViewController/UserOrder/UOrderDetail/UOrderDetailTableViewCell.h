//
//  UOrderDetailTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/10.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UOrderDetailTableViewCell;

@protocol UOrderDetailTableViewCellDelegate<NSObject>

- (void)updateScoreWithScore:(NSInteger)score book:(BookModel *)book;
- (void)toBookDetailWithBook:(BookModel *)book;

@end

@interface UOrderDetailTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UOrderDetailTableViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL canScore; // 可以评价

@end
