//
//  DJResourceTypeQAViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJResourceTypeQAViewController.h"
#import "LGBaseTableViewCell.h"
#import "UCQuestionModel.h"
#import "UCMsgModel.h"

static NSString * const rtqaCell = @"DJResourceTypeQACell";

@interface DJResourceTypeQACell : LGBaseTableViewCell
@property (strong,nonatomic) UCQuestionModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;


@end

@implementation DJResourceTypeQACell

- (void)setModel:(UCQuestionModel *)model{
    _model = model;
    
    /// 1.计算 question 的高度，改变 titlebale 的行数 和 高度
    CGFloat titleHeight = [model.question sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:24]].height;
    
//    NSLog(@"titleHeight: %f",titleHeight);
    
    /// 一行title的高度
    CGFloat sHeight = 28.6; /// 28.6 -- 按照29算
    NSInteger nOfLines = titleHeight / sHeight;

    _titleLabel.numberOfLines = nOfLines;
    
    _titleHeightCons.constant = 29 * nOfLines;
    
    _titleLabel.text = model.question;
    _tagLabel.text = model.tagString;
    
    /// 2.answerLabel 中 标注 @“答案：” 为 maincolor
    NSString *colorStr = @"答案：";
    NSDictionary *attrDict = @{NSForegroundColorAttributeName:UIColor.EDJMainColor};
    
    NSString *answerText = [colorStr stringByAppendingString:model.answer];
    
    NSMutableAttributedString *desStr = [NSMutableAttributedString.alloc initWithString:answerText];
    [desStr  setAttributes:attrDict range:NSMakeRange([answerText rangeOfString:colorStr].location, [answerText rangeOfString:colorStr].length)];
    
    _answerLabel.attributedText = desStr;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end

#pragma mark - ---------------------------
@interface DJResourceTypeQAViewController ()


@end

@implementation DJResourceTypeQAViewController

- (void)setMsgModel:(UCMsgModel *)msgModel{
    _msgModel = msgModel;
//    UCQuestionModel
    [DJUserNetworkManager.sharedInstance frontQuestionanswer_selectDetailWithSeqid:msgModel.resourceid success:^(id responseObj) {
        UCQuestionModel *model = [UCQuestionModel mj_objectWithKeyValues:responseObj];
        self.dataArray = [NSArray arrayWithObject:model];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    } failure:^(id failureObj) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:rtqaCell bundle:nil] forCellReuseIdentifier:rtqaCell];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCQuestionModel *model = self.dataArray[indexPath.row];
    DJResourceTypeQACell *cell = [tableView dequeueReusableCellWithIdentifier:rtqaCell];
    cell.model = model;
    return cell;
}



@end
