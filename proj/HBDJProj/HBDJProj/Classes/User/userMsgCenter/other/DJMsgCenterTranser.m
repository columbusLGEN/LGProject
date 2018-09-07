//
//  DJMsgCenterTranser.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJMsgCenterTranser.h"
#import "UCMsgModel.h"
#import "DJResourceTypeNewsViewController.h"

#import "OLExamViewController.h"
#import "OLTkcsModel.h"
#import "DJTestScoreListTableViewController.h"
#import "OLTestResultViewController.h"

@implementation DJMsgCenterTranser

- (void)msgShowDetailVcWithModel:(UCMsgModel *)model nav:(UINavigationController *)nav{
    
    switch (model.noticetype) {
        case UCMsgModelResourceTypeCustom:
            
            break;
        case UCMsgModelResourceTypeNews:{
            DJResourceTypeNewsViewController *newsvc = DJResourceTypeNewsViewController.new;
            newsvc.msgModel = model;
            [nav pushViewController:newsvc animated:YES];
        }
            break;
        case UCMsgModelResourceTypeQA:
            
            break;
        case UCMsgModelResourceTypeBranch:
            
            break;
        case UCMsgModelResourceTypePYQ:
            
            break;
        case UCMsgModelResourceTypeSpeech:
            
            break;
        case UCMsgModelResourceTypeVote:
            
            break;
        case UCMsgModelResourceTypeTest:{
            
//            model.resourceid = 8;
//            model.votestestsstatus = 3;
            
            OLTkcsModel *testModel = OLTkcsModel.new;
            testModel.tkcsType = OLTkcsTypecs;
            testModel.teststatus = model.votestestsstatus;
            testModel.seqid = model.resourceid;
            testModel.msgModel = model;
            
            if (model.votestestsstatus == 0) {
                /// 进行中(默认)
                OLExamViewController *testvc = OLExamViewController.new;
                testvc.tkcsType = OLTkcsTypecs;
                
                testvc.portName = @"Tests";
                
                testvc.model = testModel;
                [nav pushViewController:testvc animated:YES];
            }
            if (model.votestestsstatus == 1) {
                /// 已经答题
                /// 进入个人成绩页面
                OLTestResultViewController *trvc = (OLTestResultViewController *)[nav lgInstantiateViewControllerWithStoryboardName:OnlineStoryboardName controllerId:@"OLTestResultViewController"];
                trvc.pushWay = LGBaseViewControllerPushWayPush;
                trvc.model = testModel;
                
                [nav pushViewController:trvc animated:YES];

            }
            if (model.votestestsstatus == 3) {
                /// 已经结束
                DJTestScoreListTableViewController *vc = DJTestScoreListTableViewController.new;
                vc.model = testModel;
                [nav pushViewController:vc animated:YES];
            }
            
        }
            break;
        case UCMsgModelResourceTypeScore:
            
            break;

    }
}

@end
