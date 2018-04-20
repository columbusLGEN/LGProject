//
//  UCMyFeedbackViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMyFeedbackViewController.h"
#import "UCHelpFadebackTableViewCell.h"
#import "UCHelpFadebackModel.h"

static NSString * const cellID = @"UCHelpFadebackTableViewCell";

@interface UCMyFeedbackViewController ()

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCMyFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerClass:[UCHelpFadebackTableViewCell class] forCellReuseIdentifier:cellID];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        UCHelpFadebackModel *model = [UCHelpFadebackModel new];
        model.showTimeLabel = YES;
        [arr addObject:model];
    }
    _array = arr.copy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCHelpFadebackModel *model = _array[indexPath.row];
    UCHelpFadebackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
