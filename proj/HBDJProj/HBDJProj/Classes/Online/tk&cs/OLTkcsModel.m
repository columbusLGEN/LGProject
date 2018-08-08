//
//  OLTkcsModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTkcsModel.h"

@implementation OLTkcsModel

- (NSString *)timeused_string{
    if (!_timeused_string) {
        NSTimeInterval timeConsumed = self.timeused_timeInterval;
        //    NSLog(@"耗时: %f",timeConsumed);
        
        /// 将时间转化为 时:分:秒
        NSString *timeStr;
        if (timeConsumed > 3599 && timeConsumed <= 86400) {
            /// 超过一个小时
            NSInteger hour = timeConsumed / 3600;
            NSInteger hourOfSecond = hour * 3600;
            
            NSInteger min = (timeConsumed - hourOfSecond) / 60;
            NSInteger minOfSecond = min * 60;
            
            NSInteger sec = timeConsumed - hourOfSecond - minOfSecond;
            
            NSString *hourStr;
            if (hour < 10) {
                hourStr = [NSString stringWithFormat:@"0%ld",hour];
            }else{
                hourStr = [NSString stringWithFormat:@"%ld",hour];
            }
            
            NSString *minStr;
            if (min < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",min];
            }else{
                minStr = [NSString stringWithFormat:@"%ld",min];
            }
            
            NSString *secStr;
            if (sec < 10) {
                secStr = [NSString stringWithFormat:@"0%ld",sec];
            }else{
                secStr = [NSString stringWithFormat:@"%ld",sec];
            }
            
            timeStr = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minStr,secStr];
            
        }else if (timeConsumed > 59){
            /// 超过一分钟
            NSInteger min = timeConsumed / 60;
            NSInteger minOfSecond = min * 60;
            
            NSInteger sec = timeConsumed - minOfSecond;
            
            NSString *minStr;
            if (min < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",min];
            }else{
                minStr = [NSString stringWithFormat:@"%ld",min];
            }
            
            NSString *secStr;
            if (sec < 10) {
                secStr = [NSString stringWithFormat:@"0%ld",sec];
            }else{
                secStr = [NSString stringWithFormat:@"%ld",sec];
            }
            
            timeStr = [NSString stringWithFormat:@"%@:%@",minStr,secStr];
        }else{
            
            NSInteger sec = timeConsumed;
            
            NSString *secStr;
            if (timeConsumed < 10) {
                secStr = [NSString stringWithFormat:@"0%ld",sec];
            }else{
                secStr = [NSString stringWithFormat:@"%ld",sec];
            }
            
            timeStr = [NSString stringWithFormat:@"00:%@",secStr];
        }
        _timeused_string = timeStr;
    }
    return _timeused_string;
}

- (NSInteger)rightRate{
    CGFloat rate = (CGFloat)_rightCount / _subcount;
    _rightRate = ceil(rate * 100);
    return _rightRate;
}

- (NSInteger)wrongCount{
    return _subcount - _rightCount;
}

- (NSInteger)testid{
    return self.seqid;
}

- (NSString *)statusDesc{
//    if (!_statusDesc) {
        switch (_teststatus) {
            case OLTkcsModelStateTesting:
                _statusDesc = @"进行中";
                break;
            case OLTkcsModelStateDone:
                _statusDesc = @"已答题";
                break;
            case OLTkcsModelStateNotBegin:
                _statusDesc = @"未开始";
                break;
            case OLTkcsModelStateEnd:
                _statusDesc = @"已结束";
                break;
        }
//    }
    return _statusDesc;
}

- (UIColor *)statusDescColor{
//    if (!_statusDescColor) {
        switch (_teststatus) {
            case OLTkcsModelStateTesting:
                _statusDescColor = UIColor.EDJMainColor;
                break;
            case OLTkcsModelStateDone:
                _statusDescColor = UIColor.EDJGrayscale_11;
                break;
            case OLTkcsModelStateNotBegin:
                _statusDescColor = UIColor.blackColor;
                break;
            case OLTkcsModelStateEnd:
                _statusDescColor = UIColor.EDJGrayscale_F3;
                break;
        }
//    }
    return _statusDescColor;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"answers":@"OLExamSingleModel"};
}

@end
