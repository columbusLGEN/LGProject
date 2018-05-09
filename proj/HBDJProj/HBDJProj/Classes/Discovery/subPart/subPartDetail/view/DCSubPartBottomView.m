//
//  DCSubPartBottomView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartBottomView.h"
#import "LGCustomButton.h"

@interface DCSubPartBottomView ()
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet LGCustomButton *like;
@property (weak, nonatomic) IBOutlet LGCustomButton *collect;


@end

@implementation DCSubPartBottomView

- (void)likeClick{
    if (_like.selected) {
        _like.selected = NO;
    }else{
        _like.selected = YES;
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];

//    [_like setupWithImgName:@""
//                       text:@"点赞"
//            textColorNormal:[UIColor whiteColor]
//          textColorSelected:[UIColor whiteColor]];
    
    [_like addTarget:self
                        action:@selector(likeClick)
              forControlEvents:UIControlEventTouchUpInside];
}

@end
