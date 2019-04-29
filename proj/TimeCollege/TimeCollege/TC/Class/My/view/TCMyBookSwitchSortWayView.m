//
//  TCMyBookSwitchSortWayView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookSwitchSortWayView.h"

@interface TCMyBookSwitchSortWayView ()
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *containerLevelOne;

@end

@implementation TCMyBookSwitchSortWayView

- (void)setSortWay:(TCMyBookSortWay)sortWay{
    if (sortWay == TCMyBookSortWayAdd) {
        self.addRecently.selected = YES;
        self.readRecently.selected = NO;
    }else{
        self.addRecently.selected = NO;
        self.readRecently.selected = YES;
    }
}

+ (instancetype)switchSortwayView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TCMyBookSwitchSortWayView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    /// 设置阴影
    [self.containerLevelOne setShadowWithShadowColor:UIColor.blackColor shadowOffset:CGSizeMake(5, 5) shadowOpacity:1.0 shadowRadius:5];
    
    [self.addRecently setTitle:@"最近加入" forState:UIControlStateNormal];
    [self.readRecently setTitle:@"最近阅读" forState:UIControlStateNormal];
    
    [self.addRecently setTitleColor:UIColor.YBColor_6A6A6A forState:UIControlStateNormal];
    [self.readRecently setTitleColor:UIColor.YBColor_6A6A6A forState:UIControlStateNormal];
    
    [self.addRecently setTitleColor:UIColor.TCColor_mainColor forState:UIControlStateSelected];
    [self.readRecently setTitleColor:UIColor.TCColor_mainColor forState:UIControlStateSelected];
    
}

@end
