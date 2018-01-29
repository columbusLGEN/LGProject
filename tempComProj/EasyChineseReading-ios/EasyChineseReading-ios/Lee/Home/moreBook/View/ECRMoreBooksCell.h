//
//  ECRMoreBooksCell.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookModel;

@interface ECRMoreBooksCell : UITableViewCell

@property (strong,nonatomic) NSIndexPath *indexPath;//
@property (strong,nonatomic) BookModel *model;

@end
