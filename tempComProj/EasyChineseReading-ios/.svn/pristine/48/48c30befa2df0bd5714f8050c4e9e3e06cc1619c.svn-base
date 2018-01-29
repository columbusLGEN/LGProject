//
//  UCRStudentSelectedHeaderView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"

@class UCRStudentSelectedHeaderView;

@protocol UCRStudentSelectedHeaderViewDelegate <NSObject>

- (void)selectedAllUser;

@end

@interface UCRStudentSelectedHeaderView : ECRBaseView

@property (weak, nonatomic) id<UCRStudentSelectedHeaderViewDelegate> delegate;
@property (assign, nonatomic) BOOL selectedAll; // 全选
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;

@end
