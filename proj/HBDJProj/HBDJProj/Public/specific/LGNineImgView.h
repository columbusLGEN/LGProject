//
//  LGNineImgView.h
//  nineImgDemo
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NineImgTapBlock)(NSInteger index, NSArray *dataSource);

@interface LGNineImgView : UIView

@property (strong,nonatomic) NSArray *dataSource;

@property (copy,nonatomic) NineImgTapBlock tapBlock;

@end
