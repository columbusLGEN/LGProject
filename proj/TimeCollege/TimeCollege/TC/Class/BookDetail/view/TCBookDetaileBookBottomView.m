//
//  TCBookDetaileBookBottomView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookDetaileBookBottomView.h"

@interface TCBookDetaileBookBottomView ()


@end

@implementation TCBookDetaileBookBottomView

+ (instancetype)bookDetailBottomv{
    return [NSBundle.mainBundle loadNibNamed:@"TCBookDetaileBookBottomView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
