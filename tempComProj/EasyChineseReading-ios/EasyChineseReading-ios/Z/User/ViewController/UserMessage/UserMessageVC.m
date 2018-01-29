//
//  UMessageVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserMessageVC.h"

#import "UMessageSystemTableViewCell.h"
#import "UMessageTableViewCell.h"

#import "ECRThematicModel.h"

#import "UserTicketCenterVC.h"
#import "ECRSubjectController.h"

@interface UserMessageVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) EmptyView *emptyView;

@property (strong, nonatomic) NSMutableArray *arrMessages;

@property (strong, nonatomic) NSString *cacheMessageKey; // 消息缓存
@property (strong, nonatomic) NSString *cacheEndTimeKey; // 最后一条消息时间的缓存

@property (assign, nonatomic) NSInteger unReadNum; // 未读消息的数量

@end

@implementation UserMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCALIZATION(@"消息");
    
    _cacheMessageKey = [NSString stringWithFormat:@"%@_%ld", CacheKey_Messages, [UserRequest sharedInstance].user.userId];
    _cacheEndTimeKey = [NSString stringWithFormat:@"%@_%ld", CacheKey_MessageTime, [UserRequest sharedInstance].user.userId];
    
    self.arrMessages = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:_cacheMessageKey];
    [self getUnReadMessageNumber];
    
    [self configTableView];
    [self configEmptyView];
    [self showWaitTips];
    [self getNewMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 配置界面

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:LOCALIZATION(@"没有消息记录") subDesc:nil];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = _arrMessages.count > 0;
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UMessageSystemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UMessageSystemTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UMessageTableViewCell class])];
    [self.view addSubview:_tableView];
}

#pragma mark - 获取新消息
- (void)getNewMessage
{
    // 当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    // 最后一条消息的时间
    NSString *lastTime = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:_cacheEndTimeKey];
    WeakSelf(self)
    [[FriendRequest sharedInstance] getMessageAndShareBookWithStartTime:lastTime endTime:dateString completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [MessageModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                _unReadNum += array.count;
                // 最新的消息
                MessageModel *lastMessage = [array firstObject];
                // 将最新一条消息的创建时间缓存为截止时间
                [[CacheDataSource sharedInstance] setCache:lastMessage.emailCreatedTime withCacheKey:_cacheEndTimeKey];
                // 移除旧的消息列表数据
                [self.arrMessages removeAllObjects];
                // 添加新的列表数据
                [self.arrMessages addObjectsFromArray:array];
                // 加载消息缓存
                NSArray *arrCache = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:_cacheMessageKey];
                [self.arrMessages addObjectsFromArray:arrCache];
                self.emptyView.hidden = self.arrMessages.count > 0;
                // 消息根据时间排序
                [self sortMessagesWithTime];
                // 更新本地消息缓存
                [[CacheDataSource sharedInstance] setCache:self.arrMessages withCacheKey:_cacheMessageKey];
                [self.tableView reloadData];
            }
        }
    }];
}

/** 根据消息时间为消息排序 */
- (void)sortMessagesWithTime
{
    NSArray *newArray = [_arrMessages sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MessageModel *message1 = obj1;
        MessageModel *message2 = obj2;
        NSComparisonResult result = [message2.emailCreatedTime compare:message1.emailCreatedTime];
        return result;
    }];
    _arrMessages = [NSMutableArray arrayWithArray:newArray];
}

/** 获取未读消息数量 */
- (void)getUnReadMessageNumber
{
    _unReadNum = 0;
    // 不确定message的数量, 但是防止数量较大, 所以循环结束后销毁对象. 如果数量非常大, 那么在for循环里, 添加自动释放池
    @autoreleasepool {
        for (MessageModel *message in _arrMessages) {
            if (message.type == ENUM_MessageReadTypeUnRead) {
                _unReadNum += 1;
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *message = _arrMessages[indexPath.row];
    if (message.messageType == ENUM_MessageTypeActivity) {
        UMessageSystemTableViewCell *systemCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UMessageSystemTableViewCell class])];
        systemCell.data = message;
        return systemCell;
    }
    else {
        UMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UMessageTableViewCell class])];
        messageCell.data = message;
        return messageCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageModel *message = _arrMessages[indexPath.row];
    // 如果选中的消息是未读消息
    if (message.type == ENUM_MessageReadTypeUnRead) {
        // 标记已读
        message.type = ENUM_MessageReadTypeReaded;
        if (message.messageType == ENUM_MessageTypeActivity && [message.iconUrl notEmpty]) {
            UMessageSystemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell updateReadType:YES];
        }
        else {
            UMessageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell updateReadType:YES];
        }
        _unReadNum -= 1;
        [[CacheDataSource sharedInstance] setCache:_arrMessages withCacheKey:_cacheMessageKey];
        
        if (_unReadNum == 0) {
            [self fk_postNotification:kNotificationNoUnReadMessage];
        }
//        [self tagReadedWithId:message.messagesId type:message.messageType];
    }
    
    // 新增卡券
    if (message.messageType == ENUM_MessageTypeCoupon)
        [self toCouponCenter];
    // 系统活动
    else if (message.messageType == ENUM_MessageTypeActivity)
        [self toActivityWithMessageModel:message];
}

/**
 到图书活动界面

 @param message 消息模型
 */
- (void)toActivityWithMessageModel:(MessageModel *)message
{
    ECRThematicModel *model = [ECRThematicModel new];
    model.seqid           = message.themeid.integerValue;
    model.templetimg      = message.templetimg;
    model.thematicName    = message.title;
    model.en_thematicName = message.en_title;
    ECRSubjectController *sbvc = [[ECRSubjectController alloc] init];
    sbvc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    sbvc.model = model;
    [self.navigationController pushViewController:sbvc animated:YES];
}

/** 到卡券中心 */
- (void)toCouponCenter
{
    UserTicketCenterVC *ticketCenter = [UserTicketCenterVC new];
    [self.navigationController pushViewController:ticketCenter animated:YES];
}

/**
 标记已读

 @param messageId 消息id
 @param type 消息类型
 */
- (void)tagReadedWithId:(NSInteger)messageId type:(NSInteger)type
{
    [[FriendRequest sharedInstance] updateMessageStatusWithMessageId:messageId messageType:type completion:^(id object, ErrorModel *error) {
        
    }];
}

#pragma mark - 属性

- (NSMutableArray *)arrMessages
{
    if (_arrMessages == nil)
        _arrMessages = [NSMutableArray array];
    return _arrMessages;
}

@end
