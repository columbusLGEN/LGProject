//
//  ECRInputBookTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRBRLoadLocalBookModel;
@interface ECRInputBookTableViewCell : UITableViewCell

@property (strong,nonatomic) ECRBRLoadLocalBookModel *model;//

+(NSString *)cellID;

@end
