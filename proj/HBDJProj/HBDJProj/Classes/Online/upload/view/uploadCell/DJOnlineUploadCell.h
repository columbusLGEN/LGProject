 //
//  DJOnlineUplaodCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 带有文本输入框的cell

#import "DJOnlineUplaodBaseCell.h"

@class DJOnlineUploadCell;

@protocol DJOnlineUploadCellDelegate <NSObject>


/**
 用户输入内容换行代理
 
 @param cell 当前输入的cell实例
 @param textView 当前输入框实例
 @param lineCount 行数
 @param singleHeight 单行高度
 @param reloadCallBack tableview 刷新数据回调
 */
- (void)userInputContenLineFeed:(DJOnlineUploadCell *)cell textView:(UITextView *)textView lineCount:(int)lineCount singleHeight:(CGFloat)singleHeight reloadCallBack:(void(^)(UITextView *currentTextView,CGFloat textHeight))reloadCallBack;

@end

static NSString *inputTextCell = @"DJOnlineUplaodCell";

@interface DJOnlineUploadCell : DJOnlineUplaodBaseCell

@property (weak,nonatomic) id<DJOnlineUploadCellDelegate> delegate;

@end
