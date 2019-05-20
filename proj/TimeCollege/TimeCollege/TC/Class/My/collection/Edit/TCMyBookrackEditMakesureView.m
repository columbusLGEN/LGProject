//
//  TCMyBookrackEditMakesureView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackEditMakesureView.h"

@interface TCMyBookrackEditMakesureView ()
@property (weak, nonatomic) IBOutlet UIView *boConview;
@property (weak, nonatomic) IBOutlet UILabel *notice;

@end

@implementation TCMyBookrackEditMakesureView

- (void)setBookCount:(NSInteger)bookCount{
    _bookCount = bookCount;
    
    _notice.text = [NSString stringWithFormat:@"已选中%ld本书是否要移出书橱？",bookCount];
}

+ (instancetype)mbemsView{
    return [NSBundle.mainBundle loadNibNamed:@"TCMyBookrackEditMakesureView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.boConview.backgroundColor = UIColor.whiteColor;
    
    self.notice.textColor = UIColor.YBColor_6A6A6A;
    self.notice.font = [UIFont systemFontOfSize:15];
    
    CGFloat cornerRadius = 15;
    
    [self.cancel cutBorderWithBorderWidth:1 borderColor:UIColor.TCColor_mainColor cornerRadius:cornerRadius];
    self.cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.done cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:cornerRadius];
    [self.done setBackgroundColor:UIColor.TCColor_mainColor];
    [self.done setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.done.titleLabel.font = [UIFont systemFontOfSize:14];
}

@end
