//
//  LGBaseTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@implementation LGBaseTableViewCell

+ (NSString *)cellReuseIdWithModel:(id)model{
    return nil;
}
+ (CGFloat)cellHeightWithModel:(id)model{
    return 0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self baseConfigs];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self baseConfigs];
}

- (void)baseConfigs{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
