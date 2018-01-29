//
//  ECRFullminusModel.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/10.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRFullminusModel.h"

static NSString *img_ticket_selected = @"img_ticket_selected";
static NSString *img_ticket_available = @"img_ticket_available";
static NSString *img_ticket_unable = @"img_ticket_unable";

@implementation ECRFullminusModel

- (NSString *)memo{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_memo;
    }else{
        return _memo;
    }
}

- (NSString *)fullminusTypeName{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_fullminusTypeName;
    }else{
        return _fullminusTypeName;
    }
}

- (NSString *)bgImgName{
    if (self.isAva) {
        if (self.isSelected) {
            return img_ticket_selected;
        }else{
            return img_ticket_available;
        }
    }else{
        return img_ticket_unable;
    }
}

@end
