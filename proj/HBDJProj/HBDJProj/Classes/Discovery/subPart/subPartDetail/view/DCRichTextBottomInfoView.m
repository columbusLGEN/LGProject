//
//  DCRichTextBottomInfoView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCRichTextBottomInfoView.h"

@interface DCRichTextBottomInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCount;

@end

@implementation DCRichTextBottomInfoView

+ (instancetype)richTextBottomInfo{
    return [[[NSBundle mainBundle] loadNibNamed:@"DCRichTextBottomInfoView" owner:nil options:nil] lastObject];
}

@end
