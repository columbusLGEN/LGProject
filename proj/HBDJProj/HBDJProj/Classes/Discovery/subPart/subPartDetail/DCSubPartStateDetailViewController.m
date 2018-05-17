//
//  DCSubPartStateDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateDetailViewController.h"
#import "LGThreeRightButtonView.h"
#import "DCSubPartStateDetailHeader.h"
#import "DCStateCommentsTableViewCell.h"
#import "DCStateCommentsModel.h"
#import "DCStateContentsCell.h"

#import "LGHTMLParser.h"
#import "NSAttributedString+Extension.h"

@interface DCSubPartStateDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
DTAttributedTextContentViewDelegate>
@property (strong,nonatomic) LGThreeRightButtonView *bottom;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray * array;

@property (strong,nonatomic) NSAttributedString *contentString;

@end

@implementation DCSubPartStateDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottom];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.bottom.mas_top);
        make.right.equalTo(self.view.mas_right);
    }];
    
    CGFloat bottomHeight = 50;
    if ([LGDevice isiPhoneX]) {
        bottomHeight = 70;
    }
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    /// 添加 header
//    DCSubPartStateDetailHeader *header = [[DCSubPartStateDetailHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 500)];
//    /// TODO: 高度根据内容确定 ???
//    self.tableView.tableHeaderView = header;
    
    /// 注册键盘相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    NSString *str = @"爱琴海";
    NSMutableArray *arrMu = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        DCStateCommentsModel *model = [DCStateCommentsModel new];
        model.nick = [NSString stringWithFormat:@"阿明_%d",i];
        int strCount = arc4random_uniform(50) + 1;
        NSMutableString *string = [NSMutableString string];
        for (int j = 0; j < strCount; j++) {
            [string appendString:str];
        }
        model.content = string;
        [arrMu addObject:model];
    }
    self.array = arrMu.copy;
    
//    [[[LGHTMLParser alloc] init] HTMLSax:^(NSAttributedString *attrString) {
//        _contentString = attrString;
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.tableView reloadData];
//        }];
//    }];
    [self.tableView reloadData];
    
}
#pragma mark - delegate & data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [self tableView:tableView prepareCellForIndexPath:indexPath];
    }
    DCStateCommentsModel *model = _array[indexPath.row - 1];
    DCStateCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DCStateContentsCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCell];
        if (cell == nil) {
            cell = [[DCStateContentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCell];
        }
        return [cell requiredRowHeightInTableView:tableView];
    }
    DCStateCommentsModel *model = _array[indexPath.row - 1];
    return [model cellHeight];
}

- (DCStateContentsCell *)tableView:(UITableView *)tableView prepareCellForIndexPath:(NSIndexPath *)indexPath{
    
    DCStateContentsCell *cell = [[DCStateContentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCell];
    
    [cell setHTMLString:[[[LGHTMLParser alloc] init] HTMLStringWithPlistName:@"detaiTtest"]];
    cell.textDelegate = self;
    cell.attributedTextContextView.shouldDrawImages = YES;
    
    [cell.attributedTextContextView relayoutText];
    return cell;
}
#pragma mark - DTAttributedTextContentViewDelegate


#pragma mark - notifications
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    /// TODO: 为什么键盘的起始frame 异常？
    
    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
    //    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
    CGFloat offsetY = frameBegin.origin.y - frameEnd.origin.y;
    NSLog(@"willchangeframe.y -- %f",offsetY);
}
- (void)keyboardDidChangeFrame:(NSNotification *)notification{
    //    NSDictionary *userInfo = notification.userInfo;
    //    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
    //    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
    //    CGFloat offsetY = frameEnd.origin.y - frameBegin.origin.y;
    //    NSLog(@"didchangeframe.y -- %f",offsetY);
}


#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.estimatedRowHeight = 80;/// 该值不给也行
        [_tableView registerClass:[DCStateContentsCell class] forCellReuseIdentifier:contentCell];
        [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}
- (LGThreeRightButtonView *)bottom{
    if (!_bottom) {
        _bottom = [LGThreeRightButtonView new];
        _bottom.bothSidesClose = YES;
        [_bottom setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_like_normal",
                                        TRConfigSelectedImgNameKey:@"dc_like_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_6CBEFC]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                        TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_discuss_normal",
                                        TRConfigSelectedImgNameKey:@"dc_discuss_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_CEB0E7]
                                        }]];
    }
    return _bottom;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
