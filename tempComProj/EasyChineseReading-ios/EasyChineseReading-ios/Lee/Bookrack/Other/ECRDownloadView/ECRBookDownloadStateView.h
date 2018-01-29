//
//  ECRBookDownloadStateView.h
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/10/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRDownloadStateModel,ECRBookDownloadStateView;

@protocol ECRBookDownloadStateViewDelegate <NSObject>

- (void)bdsView:(ECRBookDownloadStateView *)view beginDownloadWithModel:(ECRDownloadStateModel *)model;

@end

@interface ECRBookDownloadStateView : UIView

@property (strong,nonatomic) ECRDownloadStateModel *model;// <##>
@property (weak,nonatomic) id<ECRBookDownloadStateViewDelegate> delegate;// <##>
@property (assign,nonatomic) CGFloat progress;// <##>

@end
