//
//  TCMyBookrackEditBottom.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackEditBottom.h"

@interface TCMyBookrackEditBottom ()


@end

@implementation TCMyBookrackEditBottom

+ (instancetype)brdBottom{
    return [[NSBundle mainBundle] loadNibNamed:@"TCMyBookrackEditBottom" owner:nil options:0].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
