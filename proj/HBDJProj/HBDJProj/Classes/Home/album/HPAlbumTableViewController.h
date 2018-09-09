//
//  HPAlbumTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 专辑列表控制器

#import "LGBaseTableViewController.h"
@class EDJMicroLessionAlbumModel;

@interface HPAlbumTableViewController : LGBaseTableViewController
@property (strong,nonatomic) EDJMicroLessionAlbumModel *albumModel;
@property (assign,nonatomic) NSInteger push_seqid;

@end
