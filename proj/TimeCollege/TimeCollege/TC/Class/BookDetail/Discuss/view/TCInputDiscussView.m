//
//  TCInputDiscussView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCInputDiscussView.h"

@implementation TCInputDiscussView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.disContent.backgroundColor = UIColor.YBColor_F2F8FF;
    
}

+ (instancetype)inputDiscussv{
    return [NSBundle.mainBundle loadNibNamed:@"TCInputDiscussView" owner:nil options:nil].firstObject;
}
@end
