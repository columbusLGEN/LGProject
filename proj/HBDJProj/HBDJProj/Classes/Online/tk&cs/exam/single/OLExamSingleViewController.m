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
#import "OLTkcsModel.h"

/** 用户所选 选项id 的key */
//static NSString * const options_key = @"options";
/** 题目的 主键id 的key */
static NSString * const id_key = @"id";

@interface OLExamSingleViewController ()
@property (weak,nonatomic) OLExamSingleFooterView *footer;

@end

@implementation OLExamSingleViewController

- (void)setModel:(OLExamSingleModel *)model{
    _model = model;
//    model.userRecord = NSMutableDictionary.new;
    
    model.answer_display;/// 必须调用
    /// 回看
    _footer.backLook = _backLook;
    
    if (self.model.testPaper.tkcsType == 0) {
        /// 题库不限制用户必须选中
        _footer.selectSomeOption = YES;
        _footer.tk = YES;
    }
    
    self.dataArray = model.frontSubjectsDetail;
    
    /// * 必须先给isFirst赋值
    _footer.isFirst = model.first;
    _footer.isLast = model.last;
    
    _footer.currenIndex = self.model.index;
    [self.tableView reloadData];
    
    model.userRecord[id_key] = @(model.seqid);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:examSingleOptionCell bundle:nil] forCellReuseIdentifier:examSingleOptionCell];
    [self.tableView registerNib:[UINib nibWithNibName:examSingleStemCell bundle:nil] forCellReuseIdentifier:examSingleStemCell];
    
    OLExamSingleFooterView *footer = [OLExamSingleFooterView examSingleFooter];
    
    footer.frame = CGRectMake(0, 0, kScreenWidth, 180);
    self.tableView.tableFooterView = footer;
    _footer = footer;
    

    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OLExamSingleLineModel *model = self.dataArray[indexPath.row];
    OLExamSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OLExamSingleTableViewCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    cell.backLook = _backLook;
    cell.model = model;
    
    if (model.selected) {
        _footer.selectSomeOption = YES;
    }
    return cell;
}

/// MARK: 用户选中某个选项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 获取题干模型
    OLExamSingleLineModel *questionModel = self.dataArray[0];
    if (questionModel.choiceMutiple) {
        /// MARK: 多选
        OLExamSingleLineModel *optionModel = self.dataArray[indexPath.row];
        if (optionModel.selected) {
            optionModel.selected = NO;
            [_model.selectOptions removeObject:optionModel];
            
        }else{
            optionModel.selected = YES;
            [_model.selectOptions addObject:optionModel];

        }
        
        /// 拼接需要提交的用户选项
        _model.answer = @"";
        
        for (NSInteger i = 0 ; i < _model.selectOptions.count; i++) {
            OLExamSingleLineModel *singleLineModel = _model.selectOptions[i];
            _model.answer = [_model.answer stringByAppendingString:[NSString stringWithFormat:@",%ld",singleLineModel.seqid]];
        }
        if ([_model.answer hasPrefix:@","]) {
            _model.answer = [_model.answer substringFromIndex:1];
        }
        
        _model.userRecord[options_key] = _model.answer;

    }else{
        /// MARK: 单选
        [self.dataArray enumerateObjectsUsingBlock:^(OLExamSingleLineModel   * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == indexPath.row) {
                model.selected = YES;
                _model.selectOption = model;
                _model.answer = [NSString stringWithFormat:@"%ld",model.seqid];
                _model.userRecord[options_key] = [NSString stringWithFormat:@"%ld",model.seqid];
            }else{
                model.selected = NO;
            }
        }];
        
    }
    
//    NSLog(@"本题是否回答正确: %d",self.model.isright);
    
    [tableView reloadData];
    _footer.selectSomeOption = YES;
//    NSLog(@"_userRecord: %@",_model.userRecord);
}


@end
