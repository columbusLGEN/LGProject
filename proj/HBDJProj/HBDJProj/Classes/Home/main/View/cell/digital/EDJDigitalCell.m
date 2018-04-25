//
//  EDJDigitalCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJDigitalCell.h"
#import "EDJDigitalModel.h"

@interface EDJDigitalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation EDJDigitalCell

- (void)setModel:(EDJDigitalModel *)model{
    _model = model;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];

}

@end
