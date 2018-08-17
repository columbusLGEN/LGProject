//
//  DJMediaDetailTransAssist.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJMediaDetailTransAssist.h"

#import "DJDataBaseModel.h"
#import "EDJDigitalModel.h"
#import "EDJMicroBuildModel.h"
#import "EDJMicroLessionAlbumModel.h"

#import "HPPartyBuildDetailViewController.h"
#import "HPPointNewsTableViewController.h"
#import "HPAlbumTableViewController.h"
#import "HPBookInfoViewController.h"

//#import "HPAudioVideoViewController.h"
#import "DJLessonDetailViewController.h"

#import "LGDidSelectedNotification.h"

@implementation DJMediaDetailTransAssist

/// MARK: 进入图文 或者 音视频 详情
- (void)mediaDetailWithModel:(DJDataBaseModel *)model baseVc:(UIViewController *)baseVc{
    switch (model.modaltype) {
        case ModelMediaTypeAudio:
        case ModelMediaTypeVideo:{
//            [HPAudioVideoViewController avcPushWithLesson:model baseVc:baseVc];
            
            [DJLessonDetailViewController lessonvcPushWithLesson:model baseVc:baseVc];
            
        }
            break;
        case ModelMediaTypeRichText:{
            [HPPartyBuildDetailViewController buildVcPushWith:model baseVc:baseVc];
            
        }
            break;
        case ModelMediaTypeCustom:
            break;
    }
    
}

/// MARK: 首页轮播图点击
- (void)imgLoopClick:(NSInteger)index model:(EDJHomeImageLoopModel *)model baseVc:(UIViewController *)baseVc{
    switch (index) {
        case 0:{
            /// MARK: 进入习近平要闻列表
            HPPointNewsTableViewController *vc = [HPPointNewsTableViewController new];
            vc.model = model;
            [baseVc.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        case 2:
            /// MARK: 进入 党建要闻 或者 微党课详情
            [self mediaDetailWithModel:(DJDataBaseModel *)model baseVc:baseVc];
            break;
    }
}

/// MARK: 首页列表点击
- (void)homeListClick:(NSDictionary *)userInfo baseVc:(UIViewController *)baseVc{
    id model = userInfo[LGDidSelectedModelKey];
    NSInteger skipType = [userInfo[LGDidSelectedSkipTypeKey] integerValue];
    [self skipWithType:skipType model:model baseVc:baseVc];
}

- (void)skipWithType:(NSInteger)skipType model:(id)model baseVc:(UIViewController *)baseVc{
    switch (skipType) {
        case LGDidSelectedSkipTypeMicrolessonSingle:{
            DJDataBaseModel *lesson = (DJDataBaseModel *)model;
            
            /// MARK: 进入微党课详情页面
            [self mediaDetailWithModel:lesson baseVc:baseVc];
        }
            break;
        case LGDidSelectedSkipTypeMicrolessonAlbum:{
            
            /// 先获取专辑
            EDJMicroLessionAlbumModel *albumModel = (EDJMicroLessionAlbumModel *)model;
            
            /// MARK: 进入专辑列表
            HPAlbumTableViewController *album = [HPAlbumTableViewController new];
            album.albumModel = albumModel;
            [baseVc.navigationController pushViewController:album animated:YES];
        }
            break;
        case LGDidSelectedSkipTypeBuildNews:{
            /// MARK: 进入党建要闻详情
            EDJMicroBuildModel *contentModel = (EDJMicroBuildModel *)model;
            [self mediaDetailWithModel:contentModel baseVc:baseVc];
        }
            break;
        case LGDidSelectedSkipTypeDigitalBook:{
            /// MARK: 进入数字阅读详情
            EDJDigitalModel *digital = (EDJDigitalModel *)model;
            HPBookInfoViewController *vc = [HPBookInfoViewController new];
            vc.model = digital;
            [baseVc.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

@end
