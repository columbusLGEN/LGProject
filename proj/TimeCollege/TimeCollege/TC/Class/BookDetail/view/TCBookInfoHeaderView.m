//
//  TCBookInfoHeaderView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/28.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookInfoHeaderView.h"

@interface TCBookInfoHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation TCBookInfoHeaderView

- (void)setModel:(id)model{
    self.bookname.text = @"黄梅戏";
    self.public.text = @"时代出版社";
}

+ (instancetype)biHeader{
    return [NSBundle.mainBundle loadNibNamed:@"TCBookInfoHeaderView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.line.backgroundColor = UIColor.YBColor_F3F3F3;
    
}

@end
