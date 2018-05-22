//
//  HPVideoPlayerCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPVideoPlayerCell.h"
#import "LGVideoInterfaceView.h"

@interface HPVideoPlayerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet LGVideoInterfaceView *bottomInterface;
@property (weak, nonatomic) IBOutlet UIButton *play;


@end

@implementation HPVideoPlayerCell

- (IBAction)play:(UIButton *)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
