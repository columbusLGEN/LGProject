//
//  EDJMicroPartyLessonSubCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessonSubCell.h"
#import "DJDataBaseModel.h"

static NSString *playcount_key_path = @"playcount";

@interface EDJMicroPartyLessonSubCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *img;


@end

@implementation EDJMicroPartyLessonSubCell
- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    _title.text = model.title;
    _time.text = model.createdDate;
    _peopleCount.text = [NSString stringWithFormat:@"%ld",model.playcount];
    
    [_img sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    
    [model addObserver:self forKeyPath:playcount_key_path options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    
    if ([keyPath isEqualToString:playcount_key_path] && object == _model){
        _peopleCount.text = [NSString stringWithFormat:@"%ld",_model.playcount];
        NSLog(@"_model.playcount: %ld",_model.playcount);
    }
}

- (void)dealloc{
    [_model removeObserver:self forKeyPath:@"playcount"];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
