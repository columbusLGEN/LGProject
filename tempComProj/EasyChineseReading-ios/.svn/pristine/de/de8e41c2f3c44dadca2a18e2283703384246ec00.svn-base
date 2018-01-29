//
//  ECRFloderView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRBookFloderLayout,ECRFloderView;

@protocol ECRFloderViewDelegate <NSObject>

- (void)floderViewClose:(ECRFloderView *)floderView;
- (void)floderViewEndEdit:(ECRFloderView *)floderView;
- (void)floderViewAllSelect:(ECRFloderView *)floderView;

@end

@interface ECRFloderView : UIView

@property (copy,nonatomic) NSString *fileName;

@property (assign,nonatomic) BOOL isEdit_br;// 
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic)  UITextField *floderName;// 文件名
@property (strong,nonatomic) NSMutableArray *bookModels;
@property (weak,nonatomic) id<ECRFloderViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame flowLayout:(ECRBookFloderLayout *)flowLayout;

@end
