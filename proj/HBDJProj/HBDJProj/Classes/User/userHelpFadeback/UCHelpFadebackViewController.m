//
//  UCHelpFadebackViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCHelpFadebackViewController.h"
#import "UCHelpFadebackTableViewCell.h"
#import "UCHelpFadebackModel.h"

static NSString * const cellID = @"UCHelpFadebackTableViewCell";

@interface UCHelpFadebackViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *myFadeback;
@property (weak, nonatomic) IBOutlet UIButton *writeFadeback;
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCHelpFadebackViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self uiConfig];
}

- (IBAction)writeFadeback:(id)sender {
    
}
- (IBAction)myFadeback:(id)sender {
    
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


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)uiConfig{
    
    [_myFadeback setBackgroundColor:[UIColor EDJMainColor]];
    [_writeFadeback setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    [_writeFadeback cutBorderWithBorderWidth:1 borderColor:[UIColor EDJGrayscale_F3] cornerRadius:0];
    
    UIEdgeInsets btnImgInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [_writeFadeback setImageEdgeInsets:btnImgInsets];
    [_myFadeback setImageEdgeInsets:btnImgInsets];
    
    [_tableView registerClass:[UCHelpFadebackTableViewCell class] forCellReuseIdentifier:cellID];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        UCHelpFadebackModel *model = [UCHelpFadebackModel new];
        [arr addObject:model];
    }
    _array = arr.copy;
}

@end
