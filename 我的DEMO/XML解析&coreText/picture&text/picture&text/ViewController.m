//
//  ViewController.m
//  picture&text
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "ViewController.h"
#import "PictureTextDisplayTestView.h"
#import "SaxHTMLTestObject.h"
#import "LEENewsDetailHTMLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // core text test
//    PictureTextDisplayTestView *ptView = [[PictureTextDisplayTestView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:ptView];

    [[SaxHTMLTestObject sharedInstance] lg_sax:^(NSArray *arr) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 375, 0)];
            label.numberOfLines = 0;
            NSLog(@"arr[0] -- %@",arr[0]);
            label.attributedText = arr[0];
            [label sizeToFit];
            [self.view addSubview:label];
        }];
    }];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//
//    // html 显示
//    LEENewsDetailHTMLView *view = [[LEENewsDetailHTMLView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
//    view.html = html;
    
//    NSData *htmltest = [html dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:htmltest options:importParams documentAttributes:nil error:nil];
//
////    NSLog(@"attrstring -- %@",attString);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 0)];
//    label.numberOfLines = 0;
//    label.attributedText = attString;
//    [label sizeToFit];
//    [self.view addSubview:label];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
