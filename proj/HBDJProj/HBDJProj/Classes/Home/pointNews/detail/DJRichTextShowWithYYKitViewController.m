//
//  DJRichTextShowWithYYKitViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJRichTextShowWithYYKitViewController.h"
#import <YYText/YYText.h>
#import "LGHTMLParser.h"
#import "DCRichTextTopInfoView.h"
#import "DJDataBaseModel.h"

@interface DJRichTextShowWithYYKitViewController ()

@property (strong,nonatomic) UIScrollView *scrollView;
@property (weak,nonatomic) YYLabel *label;

@property (weak,nonatomic) DCRichTextTopInfoView *topInfoView;

@end

@implementation DJRichTextShowWithYYKitViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
    // 如果需要获得最高的性能，你可以在后台线程用 `YYTextLayout` 进行预排版：
    YYLabel *label = [YYLabel.alloc initWithFrame:
                      CGRectMake(10,
                                 richTextTopInfoViewHeight + 10,
                                 self.scrollView.width - 20,
                                 self.scrollView.height - 20 - richTextTopInfoViewHeight)];
    
    [self.scrollView addSubview:label];
    label.displaysAsynchronously = YES; //开启异步绘制
    label.ignoreCommonProperties = YES; //忽略除了 textLayout 之外的其他属性
    _label = label;
    
    [self.scrollView addSubview:self.topInfoView];
    
}

- (void)setContentModel:(DJDataBaseModel *)contentModel{
    _contentModel = contentModel;
    
    self.topInfoView.model = contentModel;
    
    [LGHTMLParser HTMLSaxWithHTMLString:contentModel.content success:^(NSAttributedString *attrString) {
        
        // 创建属性字符串
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
//        text.yy_font = [UIFont systemFontOfSize:16];
//        text.yy_color = [UIColor grayColor];
//        [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
        
        // 创建文本容器
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(kScreenWidth - 20, MAXFLOAT);
        container.maximumNumberOfRows = 0;
        
        // 生成排版结果
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _label.size = layout.textBoundingSize;
            _label.textLayout = layout;
            [_scrollView setContentSize:_label.size];
        });
    }];
    
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView.alloc initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _scrollView;
}
- (DCRichTextTopInfoView *)topInfoView{
    if (!_topInfoView) {
        _topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
        _topInfoView.frame = CGRectMake(0, 0, kScreenWidth, richTextTopInfoViewHeight);

    }
    return _topInfoView;
}

@end
