//
//  UCQuestionTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class UCQuestionModel;

@protocol UCQuestionTableViewCellDelegate <NSObject>
- (void)qaCellshowAllClickWith:(NSIndexPath *)indexPath;

- (void)qaCellLikeWithModel:(UCQuestionModel *)model sender:(UIButton *)sender;
- (void)qaCellCollectWithModel:(UCQuestionModel *)model sender:(UIButton *)sender;
- (void)qaCellShareWithModel:(UCQuestionModel *)model sender:(UIButton *)sender;

@end

@interface UCQuestionTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) UCQuestionModel *model;
@property (weak,nonatomic) id<UCQuestionTableViewCellDelegate> delegate;

@end
