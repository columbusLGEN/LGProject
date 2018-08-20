//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadViewController.h"
#import "DJUploadDataManager.h"
#import "DJUploadMindReportBaseCell.h"
#import "DJUploadMindReportLineModel.h"
#import "UITextView+Extension.h"
#import "DJOnlineNetorkManager.h"

@interface UCUploadViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) NSArray *array;

@property (weak,nonatomic) UIScrollView *scrollView;

/** 选择图片view */
@property (weak,nonatomic) HXPhotoView *selectedImageView;
/** 选择图片管理者 */
@property (strong,nonatomic) HXPhotoManager *nineImageManager;
@property (strong,nonatomic) DJUploadDataManager *uploadDataManager;

@property (weak,nonatomic) UIView *colorLump;
@property (weak,nonatomic) UITextView *textView;
@property (assign,nonatomic) CGFloat textHeight;

@end

@implementation UCUploadViewController{
    CGFloat _textViewWidth;
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
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.navigationItem.rightBarButtonItem = send;
    
    UIScrollView *scrollView = UIScrollView.new;
    _scrollView = scrollView;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *colorLump = UIView.new;
    _colorLump = colorLump;
    _colorLump.backgroundColor = UIColor.EDJMainColor;
    [self.scrollView addSubview:_colorLump];
    [_colorLump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(marginFifteen);
        make.left.equalTo(self.scrollView.mas_left).offset(marginTwelve);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(3);
    }];
    
    UITextView *textView = UITextView.new;
    _textView = textView;
    [self.scrollView addSubview:_textView];
    
    _textViewWidth = kScreenWidth - 35;
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_colorLump.mas_top).offset(-marginEight);
        make.left.equalTo(_colorLump.mas_right).offset(marginTen);
        make.right.equalTo(self.scrollView.mas_right).offset(-marginTen);
        make.width.mas_equalTo(_textViewWidth);
        make.height.mas_equalTo(40);
    }];
    
    NSInteger font = 15;
    [_textView lg_setplaceHolderTextWithText:@"你的描述内容是" textColor:UIColor.EDJGrayscale_A4 font:font];
    _textView.font = [UIFont systemFontOfSize:font];
    _textView.textColor = UIColor.EDJGrayscale_11;
    _textView.scrollEnabled = NO;
    [_textView sizeToFit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    /// 图片 & 视频
    if (_uploadAction == DJUPloadPyqActionImg) {
        _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    if (_uploadAction == DJUPloadPyqActionVideo) {
        _nineImageManager = [HXPhotoManager.alloc initWithType:HXPhotoManagerSelectedTypeVideo];
    }
    HXPhotoView *siv = [HXPhotoView.alloc initWithManager:_nineImageManager];
    _selectedImageView = siv;
    _uploadDataManager = DJUploadDataManager.new;
    _selectedImageView.delegate = _uploadDataManager;
    [self.scrollView addSubview:_selectedImageView];
    [_selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(marginTen);
        make.left.equalTo(self.scrollView.mas_left).offset(marginFifteen);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(280);
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
    
    /// TODO: 音频 从上个页面拿到音频文件（链接）
    if (_uploadAction == DJUPloadPyqActionAudio) {
        /// 音频
        
    }else{
        /// 文字不展示图片选择框 & 重写 文本框的约束条件
        
    }
    
    
}

- (void)textViewValueDidChanged:(NSNotification *)noti{
    UITextView *tv = noti.object;
    CGFloat txtHeight = [tv.text sizeOfTextWithMaxSize:CGSizeMake(tv.size.width - 5, MAXFLOAT) font:tv.font].height;
    
    NSLog(@"txtHeight: %f",txtHeight);
    
    if (txtHeight > 30) {
        [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(txtHeight + 20);
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - target
- (void)cancelClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
/// MARK: 上传数据
- (void)sendClick{
    
    /// TODO: 上传 视频
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = NSMutableDictionary.new;
    param[@"content"] = _textView.text?_textView.text:@"";
    
    [_uploadDataManager ugc_uploadFileWithMimeType:@"" success:^(NSArray *imageUrls, NSDictionary *formData) {
        
        if (imageUrls == nil || imageUrls.count == 0) {
            [self presentFailureTips:@"您未选择任何图片"];
            return;
        }
        
        NSString *fileurl = [imageUrls componentsJoinedByString:@","];
        param[@"fileurl"] = fileurl;
        
        [DJOnlineNetorkManager.sharedInstance frontUgc_addWithFormData:param.mutableCopy ugctype:1 filetype:_uploadAction success:^(id responseObj) {
            [self presentSuccessTips:@"上传成功，审核中"];
            [self lg_dismissViewController];
        } failure:^(id failureObj) {
            [self presentSuccessTips:@"上传失败，请稍后重试"];
        }];
        
    } singleFileComplete:^(id dict) {
        /// 单图、音频分支
        /// TODO: 上传音频
        
        param[@"fileurl"] = dict[@"path"];
        param[@"widthheigth"] = dict[@"widthheigth"];
//        dict[@"cover"];
//        NSLog(@"dict: %@",dict);
        
        [DJOnlineNetorkManager.sharedInstance frontUgc_addWithFormData:param.mutableCopy ugctype:1 filetype:_uploadAction success:^(id responseObj) {
            [self presentSuccessTips:@"上传成功，审核中"];
            [self lg_dismissViewController];
        } failure:^(id failureObj) {
            [self presentSuccessTips:@"上传失败，请稍后重试"];
        }];
        
    }];
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

