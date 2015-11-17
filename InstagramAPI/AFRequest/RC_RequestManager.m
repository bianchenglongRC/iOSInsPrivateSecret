//
//  RC_RequestManager.m
//  FacebookHealth
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RC_RequestManager.h"
#import "AFNetworking.h"
#import "Reachability.h"

///打印日志，发布时关闭,
//#define TestServer 1

#define InstagramGetAccess_tokenURL  @"https://api.instagram.com/oauth/access_token?scope=likes+relationships"
#define InstagramRootURL             @"https://api.instagram.com/v1/users/media/recent?count=500"
#define ServerRootURL                @"http://f4f.rcplatformhk.net/RcGetFollowsWeb/report%@"
//#define ServerRootURL                @"http://192.168.0.86:8084/RcGetFollowsWeb/V2%@"

///服务器地址-正式环境



#ifdef TestServer
static NSString * const kServerDomain = @"http://192.168.0.88:8088/GetLikeGetFollowerWeb/%@";
#else
static NSString * const kServerDomain = @"http://likefollow.rcplatformhk.com/GetLikeGetFollowerWeb/%@";

#endif



#define RegisteUseInfoURL            @"/user/registeUseInfo.do"
#define UpdateClassifyURL            @"/user/updateClassify.do"
#define GetFollowsURL                @"/user/getFollows.do"
#define PostFollowsURL               @"/user/postFollows.do"
#define UpdateShareIgURL             @"/user/updateShareIg.do"
#define UpdateFiveStartURL           @"/user/updateFiveStart.do"
#define GetUserInfoURL               @"/user/getUserInfo.do"
#define PostOrdersURL                @"/user/postOrders.do"
#define UpdateAdvCoin                @"/user/updateAdvCoin.do"

#define GetMediaURL                  @"/v1/users/%@/media/recent?count=500"


//举报

#define ReportUserURL                @"/report.do"


////L4L登录
#define LoginURL                     @"userinfo/Login.do"

////用户充值
#define RechargeURL                  @"userinfo/Recharge.do"

////用户当前金币查询
#define QueryGoldURL                 @"userinfo/QueryGold.do"

////用户下Like订单
#define PlaceLikeOrderURL            @"like/PlaceLikeOrder.do"

////获取Like订单
#define GetLikeOrderURL              @"like/GetLikeOrder.do"

////获取Follow订单
#define GetFollowOrderURL            @"follower/GetFollowerOrder.do"

////推送无效订单
#define ProblemLikeOrderReportURL              @"like/ProblemLikeOrderReport.do"

////消耗Like订单
#define ConsumLikeOrderURL           @"like/ConsumLikeOrder.do"

////基础参数获取
#define BaseParmURL                  @"userinfo/BaseParm.do"

////连续登录奖励金币
#define SigninRewardURL              @"userinfo/SigninReward.do"

#define kPushURL @"http://iospush.rcplatformhk.net/IOSPushWeb/userinfo/regiUserInfo.do"



@interface RC_RequestManager()

@property (nonatomic,strong) AFHTTPRequestOperationManager *operation;

@end

@implementation RC_RequestManager

static RC_RequestManager *requestManager = nil;

+ (RC_RequestManager *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        requestManager = [[RC_RequestManager alloc]init];
        requestManager.operation = [AFHTTPRequestOperationManager manager];
    });
    return requestManager;
}

#pragma mark -
#pragma mark 公共请求 （Get）

-(void)requestServiceWithGet:(NSString *)url_Str success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    _operation.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _operation.responseSerializer = responseSerializer;
    
    [_operation GET:url_Str parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //解析数据
                if (success) {
                    success(responseObject);
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
    
}






#pragma mark -
#pragma mark 公共请求 （Post）

- (void)requestServiceWithPost:(NSString *)url_Str parameters:(id)parameters jsonRequestSerializer:(AFJSONRequestSerializer *)requestSerializer success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if (requestSerializer) {
        _operation.requestSerializer = requestSerializer;
    }
    else
    {
        _operation.requestSerializer = [AFHTTPRequestSerializer serializer];
    }

    
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
   
//    responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    _operation.responseSerializer = responseSerializer;
    
    
    [_operation POST:url_Str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析数据
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)POSTRequest:(NSString *)urlString parameters:(id)parameters upateFileData:(NSData *)fileData success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {

    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    //    responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    _operation.responseSerializer = responseSerializer;
    
    
    
    [_operation POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *currentDate = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", currentDate];
        [formData appendPartWithFileData:fileData name:@"picfile" fileName:fileName mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}


#pragma mark -
#pragma mark 注册设备

- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    [self requestServiceWithPost:kPushURL parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 获取Instagramtoken

-(void)getInstagramToken:(NSDictionary *)dictionary success:(void (^)(id))success andFailed:(void (^)(NSError *))failure
{
    if (![self checkNetWorking])
        return;
    
    [self requestServiceWithPost:InstagramGetAccess_tokenURL parameters:dictionary jsonRequestSerializer:nil success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}



/**
 *  注册更新用户信息
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)registeUseInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
//    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,LoginURL];

    
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
}


/**
 *  获取基本参数
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)requestForBaseParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,BaseParmURL];
    
    
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}




/**
 *  更新用户金币信息（金币查询）
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)queryGoldInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,QueryGoldURL];
    
    
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

/**
 *  充值
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)requestForRecharge:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,RechargeURL];
    
    
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}



//-(void)rechargeWithProductid:(NSString *)productid balance:(NSNumber *)balance currency:(NSString *)currency gold_num:(NSNumber *)gold_num isfree:(NSNumber *)isfree remark:(NSString *)remark transactionIdentifier:(NSString *)transactionIdentifier Success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure{
//
//    if (![self checkNetWorking])
//        return;
//    
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    [requestSerializer setTimeoutInterval:30];
//    
//    UserInfo *userinfo = [RC_LocalDataManager readUnarchiveMyUserInfo];
//    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:ACCESSTOKEN_KEY];
//    
//    if (!userinfo) {
//        return;
//    }
//    
//    NSString *url = [NSString stringWithFormat:kServerDomain,RechargeURL];
//    //    NSString *url = @"aaa";
//    NSDictionary *dictionary;
//    if (remark && ![remark isEqualToString:@""]) {
//        dictionary = @{@"plat":@Plat,@"appid":SeverAppID,@"userid":userinfo.strId,@"usertoken":token,@"productid":productid,@"balance":balance,@"currency":currency,@"gold_num":gold_num,@"isfee":isfree,@"remark":remark,@"rechargeid":transactionIdentifier};
//    }
//    else
//    {
//        dictionary = @{@"plat":@Plat,@"appid":SeverAppID,@"userid":userinfo.strId,@"usertoken":token,@"productid":productid,@"balance":balance,@"currency":currency,@"gold_num":gold_num,@"isfee":isfree,@"rechargeid":transactionIdentifier};
//    }
//    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//
//
//
//}



/**
 *  从服务器获取图片（获取Like订单）
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */


-(void)requestPictureFormSeverWithParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,GetLikeOrderURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  从服务器获取User（获取Follow订单）
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */


-(void)requestUserFormSeverWithParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    
    NSString *url = [NSString stringWithFormat:kServerDomain,GetFollowOrderURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  向服务器获推送无效订单
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */


-(void)requestPostNoUseOrderSeverWithParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,ProblemLikeOrderReportURL];

    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}


/**
 *  上传点赞图片到服务器(消耗Like订单)
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */


-(void)requestPostOrderToSever:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,ConsumLikeOrderURL];
    
    
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

/**
 *  上传需要点赞的图片给服务器(下Like订单)
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)requestToGetLikeForThisPictureWithMediaItem:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,PlaceLikeOrderURL];
    
    
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}


/**
 *  获得签到信息（签到接口）
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)SigninReward:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    //    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    NSString *url = [NSString stringWithFormat:kServerDomain,SigninRewardURL];
    
    
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}




/**
 *  更新用户兴趣分类
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateClassify:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateClassifyURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取follow用户列表
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)getFollows:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,GetFollowsURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  上报follow用户列表
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)postFollows:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,PostFollowsURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  更新用户分享IG
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateShareIg:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateShareIgURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  更新用户评论五星状态
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateFiveStart:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateFiveStartURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  点击广告增加金币
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateAdvCoin:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateAdvCoin];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取用户基本信息状态
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)getUserInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,GetUserInfoURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)postOrders:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,PostOrdersURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/////

-(void)reportUser:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,ReportUserURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



#pragma mark -
#pragma mark 检测网络状态

- (BOOL)checkNetWorking
{
    BOOL connected = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO;
    
    return connected;
}

- (void)cancleAllRequests
{
    [_operation.operationQueue cancelAllOperations];
}





@end
