//
//  WXLogin.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/30.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "WXLogin.h"
#import "WXApi.h"

@implementation WXLogin
CM_SINGLETON_IMPLEMENTION(WXLogin)

- (void)getCode
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"weChatGetCode";
    [WXApi sendReq:req];
}

- (void)getDataWithUrl:(NSString *)url complete:(completeBlock)complete
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    // 网络请求
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error)
            complete(nil, error);
        else
            complete(responseObject, nil);
    }];
    [dataTask resume];
}

- (void)getAccessTokenWithCode:(NSString *)code complete:(completeBlock)complete
{
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, code];
    [self getDataWithUrl:accessUrlStr complete:^(id object, NSError *error) {
        if (error) {
            complete(nil, error);
        }
        else {
            NSDictionary *respDic = [NSDictionary dictionaryWithDictionary:object];
            
            NSString *accessToken  = [respDic objectForKey:WX_ACCESS_TOKEN];
            NSString *refreshToken = [respDic objectForKey:WX_REFRESH_TOKEN];
            NSString *openID       = [respDic objectForKey:WX_OPEN_ID];
            NSString *unionid      = [respDic objectForKey:WX_UNION_ID];
            
            // 本地持久化，以便access_token的使用、刷新或者持续
            if (accessToken.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:accessToken  forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:openID       forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:unionid      forKey:WX_UNION_ID];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            complete(respDic, nil);
        }
    }];
}

- (void)getUserInfoComplete:(completeBlock)complete
{
    NSString *userInfoUrl = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN],  [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]];

    [self getDataWithUrl:userInfoUrl complete:^(id object, NSError *error) {
        if (error) {
            complete(nil, error);
        }
        else {
            NSDictionary *respDic = [NSDictionary dictionaryWithDictionary:object];
            complete(respDic, nil);
        }
    }];
}

- (void)checkAccessTokenComplete:(completeBlock)complete
{
    NSString *accessUrl = [NSString stringWithFormat:@"%@/auth?access_token=%@&openid=%@", WX_BASE_URL,  [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN],  [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]];
    [self getDataWithUrl:accessUrl complete:^(id object, NSError *error) {
        if (error)
            complete(nil, error);
        else
            complete(object, nil);
    }];
}

- (void)refreshAccessTokenComplete:(completeBlock)complete
{
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
    NSString *accessUrl = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WX_App_ID, refreshToken];
    if (refreshToken == nil || [refreshToken empty]) {
        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{}];
        complete(nil, error);
        return;
    }
    [self getDataWithUrl:accessUrl complete:^(id object, NSError *error) {
        if (error) {
            complete(nil, error);
        }
        else {
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:object];
            NSError *errors;
            if (refreshDict[@"errcode"] == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_ACCESS_TOKEN]  forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_OPEN_ID]       forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else {
                errors = [NSError errorWithDomain:refreshDict[@"errmsg"] code:[refreshDict[@"errcode"] integerValue] userInfo:nil];
            }
            complete(object, errors);
        }
    }];
}

@end
