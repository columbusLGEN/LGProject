//
//  UCImpowerTeacherTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCImpowerTeacherTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (assign, nonatomic) BOOL isSelected;

@end
