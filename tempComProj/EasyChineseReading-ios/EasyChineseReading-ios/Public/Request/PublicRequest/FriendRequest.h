//
//  FriendRequest.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseNetRequest.h"

@interface FriendRequest : BaseNetRequest

#pragma mark ========== 好友相关网络请求 ==========

CM_SINGLETON_INTERFACE(FriendRequest)

#pragma mark - 获取好友列表

/**
 获取好友列表(若不传 userName 获取全部好友信息, 传 userName 为搜索该用户)

 @param userName   手机号或邮箱
 @param completion 回调
 */
- (void)getFriendListWithUserName:(NSString *)userName
                       completion:(CompleteBlock)completion;



/**
 获取推荐好友的列表
 
 @param page       页数
 @param length     每页数量
 @param completion 回调
 */
- (void)getRecommendFriendsWithPage:(NSInteger)page
                             length:(NSInteger)length
                         completion:(CompleteBlock)completion;

#pragma mark - 关注好友

/**
 关注好友

 @param friendId    好友id
 @param completion  回调
 */
- (void)addFriendWithFriendId:(NSInteger)friendId
                   completion:(CompleteBlock)completion;

/**
 删除好友
 
 @param friendId    好友id
 @param completion  回调
 */
- (void)delFriendWithFriendId:(NSInteger)friendId
                   completion:(CompleteBlock)completion;

#pragma mark - 获取好友动态

/**
 获取好友动态(如果拉朋友动态列表传: page,length. 如果拉单个好友详情传: friendId)

 @param page        第几页
 @param length      每页数据量
 @param friendId    好友 Id
 @param completion  回调(返回数据有两种, 第一种是分享的动态, 第二种是个人分享的数据(晒一晒), 区分区别, 有 bookId 就是分享的动态, 否则就是个人分享的数据)
 */
- (void)getDynamicsWithPage:(NSString *)page
                     length:(NSString *)length
                   friendId:(NSString *)friendId
                 completion:(CompleteBlock)completion;

#pragma mark - 分享图书到朋友圈

/**
 分享图书到朋友圈

 @param bookId     图书 id
 @param shareTitle 分享的标题
 @param completion 回调
 */
- (void)shareBookWithBookId:(NSInteger )bookId
                 shareTitle:(NSString *)shareTitle
                 completion:(CompleteBlock)completion;

#pragma mark - 查看指定好友阅读历史

/**
 查看指定好友阅读历史

 @param friendId    好友 id
 @param completion  回调
 */
- (void)getFriendReadHistoryWithFriendId:(NSString *)friendId
                              completion:(CompleteBlock)completion;

#pragma mark - 接受消息和好友分享的图书 接口

/**
 接受消息和好友分享的图书 接口（拉取startTime与endTime之间的消息）
 
 @param startTime  记录时间
 @param endTime    当前时间
 @param completion 回调
 */
- (void)getMessageAndShareBookWithStartTime:(NSString *)startTime
                                    endTime:(NSString *)endTime
                                 completion:(CompleteBlock)completion;

#pragma mark - 更改消息状态 

/**
 更改消息状态
 
 @param messageId   消息 id
 @param messageType 消息类型
 @param completion  回调
 */
- (void)updateMessageStatusWithMessageId:(NSInteger )messageId
                             messageType:(NSInteger )messageType
                              completion:(CompleteBlock)completion;

#pragma mark - 教师发送给学生站内信接口

/**
 教师发送给学生站内信接口
 
 @param studentId  学生 id 数组
 @param message    消息
 @param completion 回调
 */
- (void)getMessageWithStudentId:(NSString *)studentId
                        message:(NSString *)message
                     completion:(CompleteBlock)completion;




@end
