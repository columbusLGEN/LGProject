//
//  LGWMPlayerManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGWMPlayerManager.h"
#import <WMPlayer/WMPlayer.h>
#import "UIAlertController+LGExtension.h"

@implementation LGWMPlayerManager

- (WMPlayer *)WMPlayerWithUrl:(NSString *)url aImgType:(NSUInteger)aImgType delegate:(id)delegate{
    
    WMPlayerModel *playerModel = [WMPlayerModel new];
    //    playerModel.title = model.title;
    playerModel.videoURL = [NSURL URLWithString:url];
    playerModel.verticalVideo = (aImgType == 0);
    WMPlayer * wmPlayer = [[WMPlayer alloc]initPlayerModel:playerModel];
    wmPlayer.backBtnStyle = BackBtnStylePop;
    wmPlayer.delegate = delegate;
    wmPlayer.tintColor = UIColor.EDJMainColor;
    wmPlayer.loopPlay = NO;
    wmPlayer.playerLayerGravity = WMPlayerLayerGravityResizeAspect;
    
    [LGNoticer.new noticeNetworkStatusWithBlock:^(BOOL notice) {
        if (notice) {
            /// 提示用户当前为流量状态
            UIAlertController *alertvc = [UIAlertController lg_popUpWindowWithTitle:@"提示" message:@"当前播放会消耗流量" preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" doneTitle:@"继续播放" cancelBlock:^(UIAlertAction * _Nonnull action) {
                
            } doneBlock:^(UIAlertAction * _Nonnull action) {
                
                [self playWithWmPlayer:wmPlayer];
            }];
            
            if ([delegate isKindOfClass:[UIViewController class]]) {
                UIViewController *vc = (UIViewController *)delegate;
                [vc presentViewController:alertvc animated:YES completion:nil];
            }
            
        }else{
            /// 继续播放
            [self playWithWmPlayer:wmPlayer];
        }
    }];
    

    
    
    return wmPlayer;
}

- (void)playWithWmPlayer:(WMPlayer *)wmPlayer{
    [UIApplication.sharedApplication.keyWindow addSubview:wmPlayer];
    
    [wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.leading.trailing.top.equalTo(UIApplication.sharedApplication.keyWindow);
        //        make.height.mas_equalTo(wmPlayer.mas_width).multipliedBy(9.0/16);
        make.edges.equalTo(UIApplication.sharedApplication.keyWindow);
    }];
    [wmPlayer play];
}

@end
