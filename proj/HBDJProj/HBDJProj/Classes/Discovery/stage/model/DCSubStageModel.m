//
//  DCSubStageModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageModel.h"
#import "NSString+Extension.h"

static CGFloat baseHeight = 152;

@implementation DCSubStageModel

- (CGFloat)cellHeight{
    CGFloat cellHeight;
    switch (self.modelType) {
        case StageModelTypeDefault:
        case StageModelTypeMoreImg:
            cellHeight = baseHeight + self.nineImgViewHeight;
            break;
        case StageModelTypeAImg:{
            if (self.aImgType == StageModelTypeAImgTypeVer) {
                cellHeight = baseHeight + aImgVerHeight;
            }else{
                cellHeight = baseHeight + aImgHoriHeight;
            }
        }
            break;
        case StageModelTypeAudio:
            cellHeight = baseHeight + 20;
            break;
        case StageModelTypeVideo:
            cellHeight = baseHeight + aImgHoriHeight;
            break;
    }
    CGFloat commentsHeight = 0;
    if (self.comments.count) {
        commentsHeight = 28 + self.commentsTbvHeight;
    }
    return cellHeight + commentsHeight;
}
- (CGFloat)commentsTbvHeight{
    if (!_commentsTbvHeight) {
        _commentsTbvHeight = self.comments.count * commentsCellHeight;
    }
    return _commentsTbvHeight;
}

- (CGFloat)nineImgViewHeight{
    CGFloat nineHeight = 0;
    if (self.imgs.count == 0) {
    }else if (self.imgs.count < 4) {
        nineHeight = 84;
    }else if (self.imgs.count < 7){
        nineHeight = 84 * 2 + 7;
    }else{
        nineHeight = 84 * 3 + 7 * 2;
    }
    return nineHeight;
}

- (NSArray *)imgs{
    if (!_imgs) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < arc4random_uniform(10); i++) {
            UIImage *img = [UIImage imageNamed:@"party_history"];
            [arr addObject:img];
        }
        _imgs = arr.copy;
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

- (NSString *)content{
    if (!_content) {
        _content = @"升值集团今日到三里屯视察民情升值集团今日到三里屯视察民情升值集团今日到三里屯视察民情";
    }
    return _content;
}

- (UIImage *)testIcon{
    return [UIImage imageNamed:@"icon_applePay"];
}

- (StageModelTypeAImgType)aImgType{
    if (self.aTestImg.size.height > self.aTestImg.size.width) {
        return StageModelTypeAImgTypeVer;
    }else{
        return StageModelTypeAImgTypeHori;
    }
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"comments":@"DCSubStageCommentsModel"};
}
@end
