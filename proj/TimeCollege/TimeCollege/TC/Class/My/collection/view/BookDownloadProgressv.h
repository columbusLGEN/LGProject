//
//  BookDownloadProgressv.h
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/10/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCMyBookrackModel,BookDownloadProgressv;

@protocol BookDownloadProgressvDelegate <NSObject>

- (void)bdsView:(BookDownloadProgressv *)view beginDownloadWithModel:(TCMyBookrackModel *)model;

@end

@interface BookDownloadProgressv : UIView

@property (strong,nonatomic) TCMyBookrackModel *model;
@property (weak,nonatomic) id<BookDownloadProgressvDelegate> delegate;
@property (assign,nonatomic) CGFloat progress;

@end
