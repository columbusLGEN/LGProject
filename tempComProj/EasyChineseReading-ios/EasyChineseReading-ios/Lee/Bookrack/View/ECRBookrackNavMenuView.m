//
//  ECRBookrackNavMenuView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookrackNavMenuView.h"

@interface ECRBookrackNavMenuView ()

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *inputBook;
@property (weak, nonatomic) IBOutlet UIButton *oder;

@end

@implementation ECRBookrackNavMenuView

- (void)textDependsLauguage{
    [self.inputBook setTitle:[LGPChangeLanguage localizedStringForKey:@"导入图书"] forState:UIControlStateNormal];
    [self.oder setTitle:[LGPChangeLanguage localizedStringForKey:@"时间排序"] forState:UIControlStateNormal];
    [self.inputBook sizeToFit];
    [self.oder sizeToFit];
}

+ (instancetype)bookrackNavMenuView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ECRBookrackNavMenuView" owner:nil options:nil] firstObject];
}
- (IBAction)closeClick:(UIButton *)sender {
    // 关闭
    if ([self.delegate respondsToSelector:@selector(closeBrnmView:)]) {
        [self.delegate closeBrnmView:self];
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 0) {
        // 上
        
    }else{
        
    }
    if ([self.delegate respondsToSelector:@selector(brnmView:tb:)]) {
        [self.delegate brnmView:self tb:sender.tag];
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self textDependsLauguage];
    self.backgroundColor = [UIColor clearColor];
}

@end
