//
//  OLExamSingleViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleViewController.h"
#import "OLExamSingleLineModel.h"
#import "OLExamSingleTableViewCell.h"
#import "OLExamSingleModel.h"

@interface OLExamSingleViewController ()
@property (weak,nonatomic) OLExamSingleFooterView *footer;

@end

@implementation OLExamSingleViewController

- (void)setModel:(OLExamSingleModel *)model{
    _model = model;
    self.dataArray = model.frontSubjectsDetail;
    if (!model.backLook) {        
        if (model.index == model.questioTotalCount - 1) {
            /// 最后一题
            _footer.isLast = YES;
        }
    }
    _footer.currenIndex = self.model.index;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 50.0f;
    [self.tableView registerNib:[UINib nibWithNibName:examSingleOptionCell bundle:nil] forCellReuseIdentifier:examSingleOptionCell];
    [self.tableView registerNib:[UINib nibWithNibName:examSingleStemCell bundle:nil] forCellReuseIdentifier:examSingleStemCell];
    
    OLExamSingleFooterView *footer = [OLExamSingleFooterView examSingleFooter];
    footer.frame = CGRectMake(0, 0, kScreenWidth, 180);
    self.tableView.tableFooterView = footer;
    _footer = footer;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.model.backLook) {
        return self.dataArray.count - 1;
    }
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OLExamSingleLineModel *model = self.dataArray[indexPath.row];
    OLExamSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OLExamSingleTableViewCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OLExamSingleLineModel *questionModel = self.dataArray[0];
    __block BOOL isCorrect = NO;/// 是否回答正确
    if (questionModel.choiceMutiple) {
        /// TODO:多选题的正确性判断 -- 在 OLExamSingleModel 中判断
        OLExamSingleLineModel *optionModel = self.dataArray[indexPath.row];
        if (optionModel.selected) {
            optionModel.selected = NO;
        }else{
            optionModel.selected = YES;
//            /// textcode
//            if (optionModel.repreAnswer == optionModel.belongTo.answer) {
//                isCorrect = YES;
//            }
        }
    }else{
        [self.dataArray enumerateObjectsUsingBlock:^(OLExamSingleLineModel   * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == indexPath.row) {
                model.selected = YES;
                if (model.repreAnswer == model.belongTo.answer) {
                    isCorrect = YES;
                }
            }else{
                model.selected = NO;
            }
        }];
    }
    if (_model.subjecttype == 1) {
        _model.selectOption = questionModel;
    }else{
        [_model.selectOptions addObject:questionModel];
    }

    [tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
