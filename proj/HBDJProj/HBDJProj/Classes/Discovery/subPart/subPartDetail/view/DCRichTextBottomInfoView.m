//
//  DCRichTextBottomInfoView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCRichTextBottomInfoView.h"
#import "DCSubPartStateModel.h"

@interface DCRichTextBottomInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCount;
@property (weak, nonatomic) IBOutlet UILabel *plText;

@end

@implementation DCRichTextBottomInfoView

- (void)setModel:(DCSubPartStateModel *)model{
    _model = model;
    
    if (model.frontComments.count == 0 || model.frontComments == nil) {
        _commentsCount.text = @"";
        _plText.text = @"暂无评论";
    }else{
        _plText.text = @"评论";
        _commentsCount.text = [NSString stringWithFormat:@"(%ld)",model.frontComments.count];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _sourceLabel.hidden = YES;
}

+ (instancetype)richTextBottomInfo{
    return [[[NSBundle mainBundle] loadNibNamed:@"DCRichTextBottomInfoView" owner:nil options:nil] lastObject];
}

@end
