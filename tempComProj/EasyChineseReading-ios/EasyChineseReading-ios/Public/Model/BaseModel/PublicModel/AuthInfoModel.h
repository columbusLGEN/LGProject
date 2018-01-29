//
//  AuthInfoModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/30.
//  nonatomicright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface AuthInfoModel : BaseModel

/*********************************授权必传参数*********************************/

//服务接口名称，常量com.alipay.account.auth。
@property (copy, nonatomic) NSString *apiname;

//调用方app标识 ，mc代表外部商户。
@property (copy, nonatomic) NSString *appName;

//调用业务类型，openservice代表开放基础服务
@property (copy, nonatomic) NSString *bizType;

//产品码，目前只有WAP_FAST_LOGIN
@property (copy, nonatomic) NSString *productID;

//签约平台内的appid
@property (copy, nonatomic) NSString *appID;

//商户签约id
@property (copy, nonatomic) NSString *pid;

//授权类型,AUTHACCOUNT:授权;LOGIN:登录
@property (copy, nonatomic) NSString *authType;

//商户请求id需要为unique,回调使用
@property (copy, nonatomic) NSString *targetID;

/*********************************授权可选参数*********************************/

//oauth里的授权范围，PD配置,默认为kuaijie
@property (copy, nonatomic) NSString *scope;

//固定值，alipay.open.auth.sdk.code.get
@property (copy, nonatomic) NSString *method;

@end
