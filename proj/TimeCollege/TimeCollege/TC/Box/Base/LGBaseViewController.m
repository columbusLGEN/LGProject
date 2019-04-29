//
//  LIGBaseViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@interface LGBaseViewController ()

@end

@implementation LGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavLeftBackItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setNavLeftBackItem{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 0, 0)];
    lbl.text = self.navTitle;
    lbl.textColor = self.navTitleColor;
    lbl.font = [UIFont systemFontOfSize:16];
    [lbl sizeToFit];
    self.navigationItem.titleView = lbl;
    
    /// 在iOS7 UIViewController引入了一个新的属性edgesForExtendedLayout，
    /// 如果容器是 UINavigationController 布局默认原点是顶部开始的，所以会被遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);// 设置内边距，以调整按钮位置
    [backButton setImage:[UIImage imageNamed:self.navLeftImgName] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItems = @[back];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;// 解决自定义导航栏按钮导致系统的左滑pop 失效
    
    /// 去掉导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)lg_dismissViewController{
    switch (_pushWay) {
        case LGBaseViewControllerPushWayPush:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case LGBaseViewControllerPushWayModal:
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

- (UIColor *)navTitleColor{
    if (!_navTitleColor) {
        _navTitleColor = UIColor.blackColor;
    }
    return _navTitleColor;
}
- (NSString *)navLeftImgName{
    if (!_navLeftImgName) {
        /// 返回箭头图片名
        _navLeftImgName = kLGNavArrowLeftWhite;
    }
    return _navLeftImgName;
}
@end
