//
//  TableViewController.m
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 Libc. All rights reserved.
//

#import "TableViewController.h"
#import "Model.h"
#import "LGCameraOperateViewController.h"
#import "HVideoViewController.h"

static NSString * const homeCell = @"homeCell";

@interface TableViewController ()


@end

@implementation TableViewController{
    NSArray *array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:homeCell];
    
    array = [Model loadLocalPlistWithPlistName:@"home"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model *model = array[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell forIndexPath:indexPath];
    
    [cell.textLabel setText:model.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *model = array[indexPath.row];
    id vc = [[NSClassFromString(model.vcClassName) alloc] init];
    
    if (model.loadType == 0) {
        if ([vc isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSLog(@"%@ 不是一个控制器类",model.vcClassName);
        }
    }
    if (model.loadType == 1) {
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        
        ctrl.HSeconds = 10;//设置可录制最长时间
        ctrl.takeBlock = ^(id item) {
            if ([item isKindOfClass:[NSURL class]]) {
                NSURL *videoURL = item;
                //视频url
                NSLog(@"videoURL: %@",videoURL);
            } else {
                //图片
                NSLog(@"item: %@",item);
            }
        };
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
}


@end
