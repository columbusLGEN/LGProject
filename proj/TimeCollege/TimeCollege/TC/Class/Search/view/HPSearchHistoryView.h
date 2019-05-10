//
//  HPSearchHistoryView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSearchHistoryView : UIView
/// 暴露出来为了 直接在控制器上添加 target
@property (weak,nonatomic) UIButton *deleteRecord;
@property (weak,nonatomic) UIScrollView *scrollv;

@property (strong,nonatomic) NSArray *records;

@end
