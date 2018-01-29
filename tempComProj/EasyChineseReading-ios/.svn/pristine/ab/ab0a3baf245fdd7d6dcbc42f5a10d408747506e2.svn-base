//
//  ECRSearchBar.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRSearchBar.h"

@interface ECRSearchBar ()


@end

@implementation ECRSearchBar

- (void)setLg_placeHolder:(NSString *)lg_placeHolder{
    _lg_placeHolder = lg_placeHolder;
    self.placeholder = lg_placeHolder;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [[UIImage alloc] init];// 去掉灰色色块
//        self.barTintColor = [UIColor whiteColor];// 设置颜色主题(为发现变化)
        
        // MARK: 设置圆角和边框颜色
        // (使用kvc获取UISearchBar的私有变量)
        UITextField *searchField = [self valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];// 背景色
            searchField.layer.cornerRadius = 8.0f;// 圆角半径
            searchField.layer.borderColor = [UIColor grayColor].CGColor;// 边框亚瑟
            searchField.layer.borderWidth = 1;// 边框宽度
            searchField.layer.masksToBounds = YES;
            
            // 设置光标颜色
//            [searchField setTintColor:[UIColor redColor]];
        }
        
        // 设置取消按钮的文字和文字颜色
//        [self lg_setCancelButtonTitle:@""];
        
        // 设置输入框的 文字颜色 和 字体
//        self lg_setTextColor:<#(UIColor *)#>
//        [self lg_setTextFont:[UIFont systemFontOfSize:14]];

        
        // 设置搜索图标
//        self setImage:<#(nullable UIImage *)#> forSearchBarIcon:<#(UISearchBarIcon)#> state:<#(UIControlState)#>
    }
    return self;
}

//- (void)lg_setCancelButtonTitle:(NSString *)title {
//    NSString *os_version = [[UIDevice currentDevice] systemVersion];
//    if (1) {// 如果是iOS 9
//        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
//    }else {
//        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
//    }
//}

//- (void)lg_setTextColor:(UIColor *)textColor {
//    if (9) {// 如果是iOS 9
//        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = textColor;
//    }else {
//        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:textColor];
//    }
//}


@end






