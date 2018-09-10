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

#import "DJResourceTypeQAViewController.h"
#import "DJResourceTypeBranchViewController.h"
#import "OLVoteDetailController.h"
#import "OLVoteListModel.h"
#import "HPPartyBuildDetailViewController.h"
#import "DJDataBaseModel.h"

@implementation DJMsgCenterTranser

- (void)msgShowDetailVcWithModel:(UCMsgModel *)model nav:(UINavigationController *)nav{
    
    switch (model.noticetype) {
        case UCMsgModelResourceTypeCustom:{
            
            DJDataBaseModel *contentModel = DJDataBaseModel.new;
            contentModel.content = model.content;
            contentModel.title = model.title;
            contentModel.createdtime = model.timestamp;
            
            HPPartyBuildDetailViewController *richvc = HPPartyBuildDetailViewController.new;
            richvc.isMsgTrans = YES;
            richvc.contentModel = contentModel;
            
            [nav pushViewController:richvc animated:YES];
        }
            break;
        case UCMsgModelResourceTypeNews:{
//            model.resourceid = 263;
            /// 要闻
            DJResourceTypeNewsViewController *newsvc = DJResourceTypeNewsViewController.new;
            newsvc.msgModel = model;
            [nav pushViewController:newsvc animated:YES];
        }
            break;
        case UCMsgModelResourceTypeQA:{
            //            model.resourceid = 8;
            DJResourceTypeQAViewController *qavc = DJResourceTypeQAViewController.new;
            qavc.msgModel = model;
            [nav pushViewController:qavc animated:YES];
        }
            break;
        case UCMsgModelResourceTypeBranch:{
            /// 支部动态
//            model.resourceid = 26;
            
            DJResourceTypeBranchViewController *branchvc = DJResourceTypeBranchViewController.new;
            branchvc.msgModel = model;
            [nav pushViewController:branchvc animated:YES];
            
        }
            break;
        case UCMsgModelResourceTypePYQ:
            
            break;
        case UCMsgModelResourceTypeSpeech:
            
            break;
        case UCMsgModelResourceTypeVote:{
//            model.resourceid = 31;
            
            OLVoteListModel *voteModel = OLVoteListModel.new;
            voteModel.msgModel = model;
            voteModel.seqid = model.resourceid;
            
//            voteModel.votestatus = 0;// model.votestestsstatus;
//            voteModel.starttime = @"2018-09-01";//model.starttime;
//            voteModel.title = @"8月14投票01";//model.title;
//            voteModel.endtime = @"2018-09-01";//model.endtime;
            
            voteModel.votestatus = model.votestestsstatus;
            voteModel.starttime = model.starttime;
            voteModel.title = model.title;
            voteModel.endtime = model.endtime;
            
            voteModel.ismultiselect = model.ismultiselect;
            
            OLVoteDetailController *votevc = OLVoteDetailController.new;
            votevc.model = voteModel;
            [nav pushViewController:votevc animated:YES];
            
        }
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
