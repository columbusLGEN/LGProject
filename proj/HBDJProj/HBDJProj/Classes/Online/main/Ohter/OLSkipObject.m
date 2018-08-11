//
//  OLSkipObject.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLSkipObject.h"
#import "OLHomeModel.h"

#import "DJThoutghtRepotListViewController.h"

@implementation OLSkipObject
+ (UIViewController *)viewControllerWithOLHomeModelType:(OLHomeModel *)model{
    if (model.modelType == OnlineModelTypeKnowleageTest) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Online" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"OLKnowleageTestController"];
        vc.title = model.toolname;
        return vc;
    }else{
        NSString *controllerClass = controllerClassWithModelType(model.modelType);
        
        UIViewController *vc = [NSClassFromString(controllerClass) new];
        vc.title = model.toolname;
        
        if ([vc isKindOfClass:[DJThoutghtRepotListViewController class]]) {
            DJThoutghtRepotListViewController *vc_ = (DJThoutghtRepotListViewController *)vc;
            vc_.listType = model.modelType;
        }
        
        return vc;
    }

}

NSString *controllerClassWithModelType(OnlineModelType modelType){
    switch (modelType) {
        case OnlineModelTypeThreeMeetings:{
            return @"OLThreeMeetingsViewController";
        }
            break;
        case OnlineModelTypeThemePartyDay:{
            return @"OLMindReportViewController";
        }
            break;
        case OnlineModelTypeMindReport:{
            return @"DJThoutghtRepotListViewController";
        }
            break;
        case OnlineModelTypeKnowleageTest:{
            return @"OLMindReportViewController";
        }
            break;
        case OnlineModelTypeSpeakCheap:{
            return @"DJThoutghtRepotListViewController";
        }
            break;
        case OnlineModelTypePayPartyFee:{
//            return @"OLPayPartyChargeViewController";
            return @"DJNotOpenViewController";
        }
            break;
        case OnlineModelTypeVote:{
            return @"OLVoteListController";
        }
            break;

    }
}
@end
