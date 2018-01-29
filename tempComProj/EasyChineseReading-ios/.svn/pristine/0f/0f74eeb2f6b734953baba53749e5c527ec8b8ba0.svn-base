//
//  UserCollectionHeaderView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserCollectionHeaderViewDelegate;

@interface UserCollectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) id<UserCollectionHeaderViewDelegate> delegate;

@end

@protocol UserCollectionHeaderViewDelegate <NSObject>
/** 更换头像 */
- (void)tapAvatar;
/** 登录或修改个人信息 */
- (void)tapLoginOrUserInfo;
/** 积分 */
- (void)tapIntegral;
/** 虚拟币 */
- (void)tapVirtualCurrency;
/** 晒一晒 */
- (void)shareMyReadingInfomation;

@end
