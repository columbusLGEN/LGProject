//
//  TCInputDiscussView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCInputDiscussView.h"
#import "ZStarView.h"

@implementation TCInputDiscussView

- (void)setModel:(id)model{
    _model = model;
    
    [self.starView setScore:4 withAnimation:NO];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.disContent.backgroundColor = UIColor.YBColor_F2F8FF;
    
}

+ (instancetype)inputDiscussv{
    return [NSBundle.mainBundle loadNibNamed:@"TCInputDiscussView" owner:nil options:nil].firstObject;
}
@end
