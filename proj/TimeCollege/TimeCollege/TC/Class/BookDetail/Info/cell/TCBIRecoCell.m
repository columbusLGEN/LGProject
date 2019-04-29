//
//  TCBIRecoCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBIRecoCell.h"
#import "TCBookInfoRecoCollectionViewController.h"

@interface TCBIRecoCell ()

@end

@implementation TCBIRecoCell

- (void)setModel:(id)model{
    [super setModel:model];
    self.itemName.text = @"热门推荐";
    
}

- (void)setRecovc:(TCBookInfoRecoCollectionViewController *)recovc{
    [self.contentView addSubview:recovc.view];
    [recovc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemName.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.mas_equalTo(recovc.itemHeight);
    }];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

@end
