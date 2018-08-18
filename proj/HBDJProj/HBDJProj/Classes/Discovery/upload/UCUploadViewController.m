//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadViewController.h"
#import "DJUploadDataManager.h"
#import "DJDisUploadTextView.h"
#import "DJUploadMindReportBaseCell.h"
#import "DJUploadPYQImageCell.h"
#import "DJUploadMindReportLineModel.h"

@interface UCUploadViewController ()
@property (strong,nonatomic) NSArray *array;
/** 选择图片view */
@property (strong,nonatomic) HXPhotoView *selectedImageView;
/** 选择图片管理者 */
@property (strong,nonatomic) HXPhotoManager *nineImageManager;
@property (strong,nonatomic) DJUploadDataManager *uploadDataManager;

@property (weak,nonatomic) DJDisUploadTextView *textCon;
@property (assign,nonatomic) CGFloat textHeight;

@end

@implementation UCUploadViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"_textCon: %@",NSStringFromCGRect(_textCon.frame));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    
    /// 导航部分
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont fontWithName:textBold size:17];/// 加粗
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.navigationItem.rightBarButtonItem = send;
    
    DJDisUploadTextView *textCon = DJDisUploadTextView.new;
    _textCon = textCon;
    [self.view addSubview:_textCon];
    
    _textHeight = 20 + 10 + 10;
    [_textCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(_textHeight);
    }];
    
    /// 图片 & 视频
    if (_uploadAction == DJUPloadPyqActionImg) {
        _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    if (_uploadAction == DJUPloadPyqActionVideo) {
        _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypeVideo];
    }
    _selectedImageView = [HXPhotoView.alloc initWithManager:_nineImageManager];
    _selectedImageView.delegate = _uploadDataManager;
    
    /// TODO: 音频 从上个页面拿到音频文件（链接）
    if (_uploadAction == DJUPloadPyqActionAudio) {
        /// 音频
        
    }else{
        /// 视频、图片、文字
        /// 文字不展示图片选择框
        
    }
    
    
}


#pragma mark - target
- (void)cancelClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendClick{
    NSLog(@"发送 -- ");
    
}

@end
