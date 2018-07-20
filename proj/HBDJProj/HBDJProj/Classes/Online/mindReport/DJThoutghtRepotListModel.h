//
//  DJThoutghtRepotListModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 思想汇报 & 述职述廉 列表模型

#import "LGBaseModel.h"

@interface DJThoutghtRepotListModel : LGBaseModel

//"frontComments":[
//
//],
//"creatorid":1,
//"sort":0,
//"title":"陈独秀",
//"auditstate":"1",
//"mechanismid":"180607092010002",
//"userid":"80",
//"content":"",
//"createdtime":"2018-02-08 13:20:31",
//"ugctype":"3",
//"fileurl":"http://123.59.199.170/group1/M00/00/05/CgoKC1tOuLKANlY0AAZH-h7sSkE928.jpg",
//"seqid":3,
//"status":1


@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *createdtime;
@property (strong,nonatomic) NSString *uploader;

@end
