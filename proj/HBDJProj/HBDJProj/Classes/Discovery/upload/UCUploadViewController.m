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
#import "LGAudioPlayerManager.h"

static NSString * const fileurl_key = @"fileurl";

@interface UCUploadViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) NSArray *array;

@property (weak,nonatomic) UIScrollView *scrollView;

/** 选择图片view */
@property (weak,nonatomic) HXPhotoView *selectedImageView;
/** 选择图片管理者 */
@property (strong,nonatomic) HXPhotoManager *nineImageManager;
@property (strong,nonatomic) DJUploadDataManager *uploadDataManager;

/** 音频播放控件 */
@property (weak,nonatomic) LGAudioPlayerView *apv;

@property (weak,nonatomic) UIView *colorLump;
@property (weak,nonatomic) UITextView *textView;
@property (assign,nonatomic) CGFloat textHeight;

@end

@implementation UCUploadViewController{
    CGFloat _textViewWidth;
    LGAudioPlayerManager *apm;
    /** 防止用户重复上传 */
    BOOL uploading;
    MBProgressHUD *uploadTipView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    uploading = NO;
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
    if (_uploadAction == DJUPloadPyqActionImg || _uploadAction == DJUPloadPyqActionVideo) {
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
    }
    
    /// 音频
    if (_uploadAction == DJUPloadPyqActionAudio) {
        apm = LGAudioPlayerManager.new;
        apm.audioTotalTime = _audioTotalTime;
        LGAudioPlayerView *apv = [apm audioPlayerView];
        _apv = apv;
        [_apv cutBorderWithBorderWidth:1 borderColor:UIColor.EDJGrayscale_F3 cornerRadius:0];
        [self.scrollView addSubview:_apv];
        [_apv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textView.mas_bottom).offset(marginTen);
            make.left.equalTo(self.scrollView.mas_left).offset(marginFifteen);
            make.width.mas_equalTo(kScreenWidth - 20);
            make.height.mas_equalTo(55);
            make.bottom.equalTo(self.scrollView.mas_bottom);
        }];
    }
    
    
}

- (void)textViewValueDidChanged:(NSNotification *)noti{
    UITextView *tv = noti.object;
    CGFloat txtHeight = [tv.text sizeOfTextWithMaxSize:CGSizeMake(tv.size.width - 5, MAXFLOAT) font:tv.font].height;
    
//    NSLog(@"txtHeight: %f",txtHeight);
    
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
    
    if (uploading) {
        return;
    }
    
    [self.view endEditing:YES];
    
    NSString *content = _textView.text?_textView.text:@"";
    
    NSMutableDictionary *param = NSMutableDictionary.new;
    param[@"content"] = content;
    
    uploadTipView = [MBProgressHUD.alloc initWithView:self.view];
    uploadTipView.mode = MBProgressHUDModeText;
    uploadTipView.label.text = @"上传中...";
    
    uploading = YES;
    
    //  filetype   1图片; 2视频; 3音频; 4文本
    /// 上传音频
    if (_uploadAction == DJUPloadPyqActionAudio) {
        
        NSString *recordPath = [PLAudioPath mp3Path];
        NSURL *audioURL = [NSURL fileURLWithPath:recordPath];

        NSString *mimeType = @"audio/mp3";
        
        param[@"audiolength"] = [NSString stringWithFormat:@"%ld",_audioTotalTime];
        
        [self.view addSubview:uploadTipView];
        [uploadTipView showAnimated:YES];
        
        [DJOnlineNetorkManager.sharedInstance uploadFileWithLocalFileUrl:audioURL mimeType:mimeType uploadProgress:^(NSProgress *uploadProgress) {
        } success:^(id dict) {
            param[fileurl_key] = dict[path_key];
            [self frontUgc_addWithParam:param];
            
        } failure:^(id uploadFailure) {
            [self endUpload];
            [self presentFailureTips:@"上传音频文件失败，请稍后重试"];
        }];
        
    }else if (_uploadAction == DJUPloadPyqActionText) {
        /// 上传纯文本
        if ([content isEqualToString:@""] || content == nil) {
            [uploadTipView hideAnimated:NO];
            [self presentMessageTips:@"请输入要发表的内容"];
            uploading = NO;
            return;
        }
        
        [self.view addSubview:uploadTipView];
        [uploadTipView showAnimated:YES];
        
        [self frontUgc_addWithParam:param];
        
    }else if (_uploadAction == DJUPloadPyqActionVideo){
        
        [self.view addSubview:uploadTipView];
        [uploadTipView showAnimated:YES];
        
        /// 获取视频封面
        [_uploadDataManager ugc_uploadFileWithMimeType:@"video/mp4" success:^(NSArray *imageUrls, NSDictionary *formData) {
            [self presentMessageTips:@"请选择想要发布的视频"];
            [self endUpload];
            
        } singleFileComplete:^(id dict) {
            param[fileurl_key] = dict[path_key];
            param[cover_key] = dict[cover_key];
            param[widthheigth] = dict[widthheigth];
            [self frontUgc_addWithParam:param];
        }];
        
    }else{
        /// 上传图片
        [self.view addSubview:uploadTipView];
        [uploadTipView showAnimated:YES];
        
        [_uploadDataManager uploadContentImageWithSuccess:^(NSArray *imageUrls, NSDictionary *formData) {
            if (imageUrls == nil || imageUrls.count == 0) {
                [uploadTipView hideAnimated:YES];
                [self presentFailureTips:@"您未选择任何图片"];
                uploading = NO;
                return;
            }
            
            NSString *fileurl = [imageUrls componentsJoinedByString:@","];
            param[fileurl_key] = fileurl;
            param[widthheigth] = formData[widthheigth];
            
            [self frontUgc_addWithParam:param];
        }];
        
    }
    
}

- (void)frontUgc_addWithParam:(NSMutableDictionary *)param {
    [DJOnlineNetorkManager.sharedInstance frontUgc_addWithFormData:param.mutableCopy ugctype:1 filetype:_uploadAction success:^(id responseObj) {
        [self presentSuccessTips:uploadNeedsCheckString];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endUpload];
            [self lg_dismissViewController];
        });
    } failure:^(id failureObj) {
        [self endUpload];
        [self presentSuccessTips:@"上传失败，请稍后重试"];
    }];
}

- (void)endUpload{
    [uploadTipView hideAnimated:YES];
    uploading = NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

