//
//  EDJSearchTagHeader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJSearchTagHeader.h"
#import "EDJSearchTagHeaderModel.h"

@interface EDJSearchTagHeader ()
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UILabel *metionLabel;


@end

@implementation EDJSearchTagHeader

- (IBAction)rmClick:(id)sender {
    
}

- (void)setModel:(EDJSearchTagHeaderModel *)model{
    _model = model;
    _itemLabel.text = model.itemName;
    if (model.isHot) {
        _removeBtn.hidden = YES;
        _metionLabel.hidden = NO;
    }else{
        _metionLabel.hidden = YES;
    }
}

@end
