//
//  OLSkipObject.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLSkipObject.h"
#import "OLHomeModel.h"

@implementation OLSkipObject
+ (UIViewController *)viewControllerWithOLHomeModelType:(OLHomeModel *)model{
    NSString *controllerClass = controllerClassWithModelType(model.modelType);
    /// TODO: 需要对 controllerClass 代表的类型做判断，需要判断 对不是控制器类型及其派生类 的情况 进行处理
    UIViewController *vc = [NSClassFromString(controllerClass) new];
    vc.title = model.title;
    
    return vc;
}

NSString *controllerClassWithModelType(OnlineModelType modelType){
    switch (modelType) {
        case OnlineModelTypeThreeMeetings:{
            return @"OLMindReportViewController";
        }
            break;
        case OnlineModelTypeThemePartyDay:{
            return @"OLMindReportViewController";
        }
            break;
        case OnlineModelTypeMindReport:{
            return @"OLMindReportViewController";
        }
            break;
        case OnlineModelTypeKnowleageTest:{
            return @"OLMindReportViewController";
        }
            break;
        case OnlineModelTypeSpeakCheap:{
            return @"OLMindReportViewController";
        }
            break;
        case OnlineModelTypePayPartyFee:{
            return @"OLPayPartyChargeViewController";
        }
            break;
        case OnlineModelTypeVote:{
            return @"OLVoteListController";
        }
            break;
//        default:{
//            return @"OLAddMoreToolViewController";
//        }
//            break;

    }
}
@end
