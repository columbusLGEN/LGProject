//
//  DCSubStageModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageModel.h"

@interface DCSubStageModel ()


@end

@implementation DCSubStageModel

- (CGFloat)single_pic_width{
    if (!_single_pic_width) {
        NSArray *wid_hei = [self.widthheigth componentsSeparatedByString:@","];
        if (wid_hei.count > 0) {
            _single_pic_width = [wid_hei[0] floatValue];
        }
    }
    return _single_pic_width;
}
- (CGFloat)single_pic_height{
    if (!_single_pic_height) {
        NSArray *wid_hei = [self.widthheigth componentsSeparatedByString:@","];
        if (wid_hei.count > 1) {
            _single_pic_height = [wid_hei[1] floatValue];
        }
    }
    return _single_pic_height;
}

- (BOOL)isVideo{
    if (self.filetype == 2) {
        return YES;
    }else{
        return NO;
    }
}

- (StageModelType)modelType{
//    1图片
//    2视频
//    3音频
//    4文本
    if (self.filetype == 2) {
        return StageModelTypeVideo;
    }else if (self.filetype == 3) {
        return StageModelTypeAudio;
    }else if (self.filetype == 4) {
        return StageModelTypeDefault;
    }else {
        /// filetype == 1
        if (self.imgs.count == 1) {
            /// 单图
            return StageModelTypeAImg;
        }else{
            /// 多图
            return StageModelTypeMoreImg;
        }
    }
}

- (CGFloat)commentsTbvHeight{
    if (!_commentsTbvHeight) {
        _commentsTbvHeight = self.frontComments.count * commentsCellHeight;
    }
    return _commentsTbvHeight;
}


- (NSArray *)imgs{
    if (!_imgs) {

        _imgs = [self.fileurl componentsSeparatedByString:@","];
    }
    return _imgs;
}

- (CGFloat)heightForContent{
    if (!_heightForContent) {
        _heightForContent = [self.content sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height;
    }
//    NSLog(@"_heightForContent -- %f",_heightForContent);
    return _heightForContent;
}

- (UIImage *)testIcon{
    return [UIImage imageNamed:@"icon_applePay"];
}

- (StageModelTypeAImgType)aImgType{
    if (self.single_pic_height > self.single_pic_width) {
        return StageModelTypeAImgTypeVer;
    }else{
        return StageModelTypeAImgTypeHori;
    }
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"comments":@"DCSubStageCommentsModel",
             @"frontComments":@"DCSubStageCommentsModel"
             };
}
@end
