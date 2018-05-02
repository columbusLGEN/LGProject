//
//  UCMemberStageTransitionView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMemberStageTransitionView.h"
#import "UCMemberStageTransitionButton.h"

@interface UCMemberStageTransitionView ()
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UCMemberStageTransitionButton *upload_img;
@property (weak, nonatomic) IBOutlet UCMemberStageTransitionButton *upload_video;
@property (weak, nonatomic) IBOutlet UCMemberStageTransitionButton *upload_audio;
@property (weak, nonatomic) IBOutlet UCMemberStageTransitionButton *upload_txt;


@end

@implementation UCMemberStageTransitionView

- (IBAction)close:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mstViewClose:)]) {
        [self.delegate mstViewClose:self];
    }
}
- (void)upload:(UIButton *)sender{
    NSLog(@"sender.tag -- %ld",sender.tag);
    if ([self.delegate respondsToSelector:@selector(mstView:action:)]) {
        [self.delegate mstView:self action:sender.tag];
    }
}

+ (instancetype)memberStateTransitionView{
    return [[[NSBundle mainBundle] loadNibNamed:@"UCMemberStageTransitionView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [_close setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    NSString *txtColor = @"000000";
    [_upload_img setupWithImgName:@"uc_icon_upload_tran_img" labelText:@"图片" labelTextColor:txtColor];
    [_upload_video setupWithImgName:@"uc_icon_upload_tran_video" labelText:@"视频" labelTextColor:txtColor];
    [_upload_audio setupWithImgName:@"uc_icon_upload_tran_music" labelText:@"音频" labelTextColor:txtColor];
    [_upload_txt setupWithImgName:@"uc_icon_upload_tran_txt" labelText:@"文字" labelTextColor:txtColor];
    _upload_img.button.tag = 0;
    _upload_video.button.tag = 1;
    _upload_audio.button.tag = 2;
    _upload_txt.button.tag = 3;
    
    [_upload_img addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
    [_upload_video addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
    [_upload_audio addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
    [_upload_txt addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
}

@end
