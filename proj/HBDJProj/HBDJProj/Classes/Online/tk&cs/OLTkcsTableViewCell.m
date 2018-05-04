//
//  OLTkcsTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTkcsTableViewCell.h"
#import "OLTkcsModel.h"

@interface OLTkcsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *count;


@end

@implementation OLTkcsTableViewCell

- (void)setModel:(OLTkcsModel *)model{
    _model = model;
    _title.text = model.title;
    _count.text = [NSString stringWithFormat:@"%ld题",model.testCount];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



@end
