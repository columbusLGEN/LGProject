//
//  EDJUserCenterViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJUserCenterViewController.h"
#import "EDJUserCenterHomePageModel.h"
#import "EDJUserCenterHomePageCell.h"
#import "LGSpecificButton.h"

static NSString * const uchpCellReuseId = @"EDJUserCenterHomePageCell";

@interface EDJUserCenterViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) NSArray<EDJUserCenterHomePageModel *> *array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBgImageView;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIView *containerHeadIcon;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNick;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UIView *separatLine;
@property (weak, nonatomic) IBOutlet LGSpecificButton *headerQuestion;
@property (weak, nonatomic) IBOutlet LGSpecificButton *headerCollect;
@property (weak, nonatomic) IBOutlet LGSpecificButton *headerUpload;
@property (weak, nonatomic) IBOutlet LGSpecificButton *headerMsg;


@end

@implementation EDJUserCenterViewController

- (void)viewDidLayoutSubviews{/// 先执行viewdidload再执行该方法
    [_containerHeadIcon cutToCycle];
    [_headIcon cutToCycle];
    CGFloat shadowOffset = 2;
    [_containerHeadIcon setShadowWithShadowColor:[UIColor EDJGrayscale_F4]
                                    shadowOffset:CGSizeMake(shadowOffset, shadowOffset)
                                   shadowOpacity:1 shadowRadius:shadowOffset];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self uiConfig];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"要跳转了");
}

- (void)uiConfig{
    self.view.backgroundColor = [UIColor EDJGrayscale_F3];
    _separatLine.backgroundColor = [UIColor EDJGrayscale_F4];

    [self setHeaderButtons];
    
    [_tableView setContentInset:UIEdgeInsetsMake(29, 0, 29, 0)];
    [_tableView registerNib:[UINib nibWithNibName:uchpCellReuseId bundle:nil] forCellReuseIdentifier:uchpCellReuseId];
    
    _array = [EDJUserCenterHomePageModel loadLocalPlist];
    [_tableView reloadData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJUserCenterHomePageModel *model = _array[indexPath.row];
    EDJUserCenterHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:uchpCellReuseId];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)setHeaderButtons{
    NSString *hbtColorStr = @"333333";
    
    [_headerQuestion setupWithImgName:@"uc_icon_question"
                            labelText:@"提问"
                       labelTextColor:hbtColorStr];
    [_headerQuestion addTarget:self
                        action:@selector(headerButtonCick:)
              forControlEvents:UIControlEventTouchUpInside];
    _headerQuestion.button.tag = 0;
    
    [_headerCollect setupWithImgName:@"uc_icon_collect"
                           labelText:@"收藏"
                      labelTextColor:hbtColorStr];
    [_headerCollect addTarget:self
                       action:@selector(headerButtonCick:)
             forControlEvents:UIControlEventTouchUpInside];
    _headerCollect.button.tag = 1;
    
    [_headerUpload setupWithImgName:@"uc_icon_upload"
                          labelText:@"上传"
                     labelTextColor:hbtColorStr];
    [_headerUpload addTarget:self
                      action:@selector(headerButtonCick:)
            forControlEvents:UIControlEventTouchUpInside];
    _headerUpload.button.tag = 2;
    
    [_headerMsg setupWithImgName:@"uc_icon_msg"
                       labelText:@"消息"
                  labelTextColor:hbtColorStr];
    [_headerMsg addTarget:self
                   action:@selector(headerButtonCick:)
         forControlEvents:UIControlEventTouchUpInside];
    _headerMsg.button.tag = 3;
    
}
- (void)headerButtonCick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            NSLog(@"提问");
        }
            break;
        case 1:{
            NSLog(@"收藏");
        }
            break;
        case 2:{
            NSLog(@"上传");
        }
            break;
        case 3:{
            NSLog(@"消息");
        }
            break;
    }
}

@end
