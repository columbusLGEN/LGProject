//
//  ECRFullminusTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/29.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRRowObject;

@interface ECRFullminusTableViewCell : UITableViewCell
@property (assign,nonatomic) CGFloat cellHeight;//
@property (strong,nonatomic) NSIndexPath *inx;// 
@property (strong,nonatomic) ECRRowObject *rowModel;//


@end
