//
//  HPPointNewsHeader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPointNewsHeader.h"
#import "EDJHomeImageLoopModel.h"

@interface HPPointNewsHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation HPPointNewsHeader

- (void)setModel:(EDJHomeImageLoopModel *)model{
    _model = model;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.classimg] placeholderImage:DJPlaceholderImage];
    _title.text = model.classname;

}

+ (instancetype)pointNewsHeader{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPPointNewsHeader" owner:nil options:nil] lastObject];
}
@end
