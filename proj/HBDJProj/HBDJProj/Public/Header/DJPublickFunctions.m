//
//  DJPublickFunctions.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//


/**
 返回微党课cell高度计算需要用到的比值

 @return 高度比值
 */
CGFloat rateForMicroLessonCellHeight(void){
    if (kScreenHeight < plusScreenHeight) {
        return 1;
    }
    return kScreenHeight / plusScreenHeight;
}


/**
 返回 16 / 9 的值
 */
CGFloat rate16_9(){
    return 16.0 / 9.0;
}
