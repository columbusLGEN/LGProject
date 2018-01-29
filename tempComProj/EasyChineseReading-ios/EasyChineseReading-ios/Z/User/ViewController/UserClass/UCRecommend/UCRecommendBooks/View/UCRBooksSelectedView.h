//
//  UCRBooksSelectedView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"

@interface UCRBooksSelectedView : ECRBaseView

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) UITableView *tableView;

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects;

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder;

@end
