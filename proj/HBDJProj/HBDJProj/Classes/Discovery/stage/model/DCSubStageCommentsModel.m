//
//  DCSubStageCommentsModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageCommentsModel.h"

@implementation DCSubStageCommentsModel

- (NSMutableAttributedString *)fullCommentString{
    if (!_fullCommentString) {
        NSString *blueString = [self.username stringByAppendingString:@": "];
        
        NSString *desContent = [blueString stringByAppendingString:self.comment];
        
        NSDictionary *attrDict = @{NSForegroundColorAttributeName:[UIColor EDJColor_6CBEFC]};
        
        NSMutableAttributedString *desAttContent = [[NSMutableAttributedString alloc] initWithString:desContent];
        
        [desAttContent setAttributes:attrDict range:NSMakeRange([desContent rangeOfString:blueString].location, [desContent rangeOfString:blueString].length)];
        
        _fullCommentString = desAttContent;
    }
    return _fullCommentString;
}

@end
