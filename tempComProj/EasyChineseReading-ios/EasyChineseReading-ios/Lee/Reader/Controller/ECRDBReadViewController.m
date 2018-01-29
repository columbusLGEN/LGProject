//
//  ECRDBReadViewController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRDBReadViewController.h"
#import "ECRLocalFileManager.h"
#import "UIView+MBProgressHUD.h"

#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器1
@interface ECRDBReadViewController ()

#else
// MARK: 真机1
#import "DBPlayer.h"
@interface ECRDBReadViewController ()<DBPlayerDelegate>
@property (strong,nonatomic) DBPlayer *dbPlayer;

#endif
// MARK:1结束

@property (strong,nonatomic) UIButton *button;
@property (strong,nonatomic) NSMutableArray *testURLs;// 数组中的顺序不一定是 test1,2,3
@property (copy,nonatomic) NSString *test1;
@property (copy,nonatomic) NSString *test2;
@property (copy,nonatomic) NSString *test3;

@end

@implementation ECRDBReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _test1 = nil;
    _test2 = nil;
    _test3 = nil;
    self.testURLs = [NSMutableArray arrayWithCapacity:10];
    
    // 1.把bundle 下的文件 拷贝到 documents/bookZips
    NSString *dbzPath1 = [[NSBundle mainBundle] pathForResource:@"干在实处走在前列" ofType:@"dbz"];
    NSString *dbzPath2 = [[NSBundle mainBundle] pathForResource:@"熊猫美美：四季" ofType:@"dbz"];
    NSString *dbzPath3 = [[NSBundle mainBundle] pathForResource:@"西渡湖之酒" ofType:@"dbz"];
    NSString *bookZips = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"bookZips"];
//    NSLog(@"%@",NSHomeDirectory());
    ECRLocalFileManager *lfMgr = [ECRLocalFileManager sharedLocalFileManager];
    [lfMgr copyFileInBundleWithBundlePath:dbzPath1 toPath:bookZips fileName:@"book1"];
    [lfMgr copyFileInBundleWithBundlePath:dbzPath2 toPath:bookZips fileName:@"icon_arrow_left_black"];
    [lfMgr copyFileInBundleWithBundlePath:dbzPath3 toPath:bookZips fileName:@"book3"];
  
    [self createTestButtonWith:CGRectMake(140, 80, 0, 0) bName:@"解压缩" sel:@selector(openSuperMediaBook:)];
    
#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器2

#else
// MARK: 真机2
    
    //    UIButton *dbTest = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    //    [dbTest setTitle:@"超媒体" forState:UIControlStateNormal];
    //    [dbTest sizeToFit];
    //    [dbTest setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    dbTest.titleLabel.font = [UIFont systemFontOfSize:18];
    //    [self.view addSubview:dbTest];
    //    [dbTest addTarget:self action:@selector(openSuperMediaBook:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createTestButtonWith:CGRectMake(140, 140, 0, 0) bName:@"book1" sel:@selector(book1:)];
    [self createTestButtonWith:CGRectMake(140, 200, 0, 0) bName:@"icon_arrow_left_black" sel:@selector(icon_arrow_left_black:)];
    [self createTestButtonWith:CGRectMake(140, 260, 0, 0) bName:@"book3" sel:@selector(book3:)];
    
#endif
// MARK: 2结束
    
}

#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器3

#else
// MARK: 真机3
- (void)book1:(UIButton *)sender{
    if (_testURLs.count == 0) {
        [self.view presentMessageTips:@"请先点击解压缩，解压文件"];
    }else{
        [self presentViewController:self.dbPlayer animated:YES completion:^{
            [self.dbPlayer openABook:_test1 contentUrl:@""];
        }];
    }
}
- (void)icon_arrow_left_black:(UIButton *)sender{
    if (_testURLs.count == 0) {
        [self.view presentMessageTips:@"请先点击解压缩，解压文件"];
    }else{
        [self presentViewController:self.dbPlayer animated:YES completion:^{
            [self.dbPlayer openABook:_test2 contentUrl:@""];
        }];
    }
}
- (void)book3:(UIButton *)sender{
    if (_testURLs.count == 0) {
        [self.view presentMessageTips:@"请先点击解压缩，解压文件"];
    }else{
        [self presentViewController:self.dbPlayer animated:YES completion:^{
            [self.dbPlayer openABook:_test3 contentUrl:@""];
        }];
    }
}

#endif
// MARK: 3结束

- (void)createTestButtonWith:(CGRect)rect bName:(NSString *)bName sel:(SEL)selector{
    UIButton *dbTest = [[UIButton alloc] initWithFrame:rect];
    [dbTest setTitle:bName forState:UIControlStateNormal];
    [dbTest sizeToFit];
    [dbTest setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    dbTest.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:dbTest];
    [dbTest addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)openSuperMediaBook:(UIButton *)sender{
    NSString *bookZips = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"bookZips"];
    ECRLocalFileManager *lfMgr = [ECRLocalFileManager sharedLocalFileManager];
    // 2.解压缩文件致 documents/bookUnzips
    NSString *bookUnzips = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"bookUnzips"];
    [lfMgr unzipFileWithPath:bookZips fileName:@"book1" toPath:bookUnzips toFileName:@"book1" uzSuccess:^(NSString *absuPath) {
//        NSLog(@"success++ %@",absuPath);
        [self.view presentSuccessTips:@"解压成功"];
        _test1 = absuPath;
        [self.testURLs addObject:_test1];
    } uzFailure:^(NSString *info) {
        NSLog(@"failure-- %@",info);
    }];
    [lfMgr unzipFileWithPath:bookZips fileName:@"icon_arrow_left_black" toPath:bookUnzips toFileName:@"icon_arrow_left_black" uzSuccess:^(NSString *absuPath) {
//        NSLog(@"success++ %@",absuPath);
        _test2 = absuPath;
        [self.testURLs addObject:_test2];
    } uzFailure:^(NSString *info) {
        NSLog(@"failure-- %@",info);
    }];
    [lfMgr unzipFileWithPath:bookZips fileName:@"book3" toPath:bookUnzips toFileName:@"book3" uzSuccess:^(NSString *absuPath) {
//        NSLog(@"success++ %@",absuPath);
        _test3 = absuPath;
        [self.testURLs addObject:_test3];
    } uzFailure:^(NSString *info) {
        NSLog(@"failure-- %@",info);
    }];
    
}

- (void)applicationWillResignActivePlayer:(NSNotification *)noti{
    
}
- (void)applicationDidBecomeActivePlayer:(NSNotification *)noti{
    
}

#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器4

#else

// MARK: 真机4
- (void)dbPlayerDidClosed{
    [self.dbPlayer dismissViewControllerAnimated:YES completion:^{
        // 显示状态栏
        self.dbPlayer = nil;// 一定要释放前一个 player，否则会造成屏幕错位
    }];
}

#endif
// MARK: 4结束


#if TARGET_IPHONE_SIMULATOR

#else
- (DBPlayer *)dbPlayer{
    if (_dbPlayer == nil) {
         _dbPlayer = [[DBPlayer alloc]init];
        _dbPlayer.delegate = self;
        _dbPlayer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return _dbPlayer;
}
#endif
// MARK: 5结束


- (void)dealloc{
    [self.testURLs removeAllObjects];
    self.testURLs = nil;
}

@end
