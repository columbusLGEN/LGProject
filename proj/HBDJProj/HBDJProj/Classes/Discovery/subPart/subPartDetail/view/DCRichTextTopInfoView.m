//
//  DCRichTextTopInfoView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCRichTextTopInfoView.h"

@interface DCRichTextTopInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;


@end

@implementation DCRichTextTopInfoView


- (void)awakeFromNib{
    [super awakeFromNib];
    
}

+ (instancetype)richTextTopInfoView{
    return [[[NSBundle mainBundle] loadNibNamed:@"DCRichTextTopInfoView" owner:nil options:nil] lastObject];
}

@end
