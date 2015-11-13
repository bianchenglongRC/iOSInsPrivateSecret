//
//  AFInstagramManager.m
//  iOSLike4Like
//
//  Created by Blues on 15/9/10.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "AFInstagramManager.h"
#import "AFNetworking.h"

@implementation AFInstagramManager
{
    
    
}
static id _manager;
static id _instance;


+ (AFInstagramManager *)shareManager;

{
    static AFInstagramManager *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
        
    });
    return __singletion;
    
}





// 请求网络数据

- (void)requestDataWithFrontURL:(NSString *)frontURL method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSMutableData *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    // 开启状态栏菊花
    
    [self open];
    
    
    
    
    
    
    // GET方法单独特殊处理 =================================================================================
    
    
    
    if ([method isEqualToString:@"GET"])
        
    {
        
    /*
        // 1.初始化
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
       
        
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        
        
        
        // 3.设置超时时间
        
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        
        
        
        
        // 4.设置消息头
        
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
                
            }

        }
        
        
        //设置cookies
        
        NSData *cookiesdata = [userDefault objectForKey:@"sessionCookies"];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
        }

        */
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        
        
        
        // 6.请求
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:frontURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
        
        
        // 4.设置消息头
        
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
                
            }
            
        }
        
        
        //设置cookies
        
        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
        }

        
        
        
        AFHTTPRequestOperation *getOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        getOperation.securityPolicy = securityPolicy;
        getOperation.responseSerializer =[AFJSONResponseSerializer serializer];
        getOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [getOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
            [self close];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // 超时
            
            failure(operation, error);
            
            
            
            // 关闭状态栏菊花
            
            [self close];

        }];
        
        [getOperation start];
        
        /*
        [manager GET:frontURL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            
            // 成功
            
            success(operation, responseObject);
            
            
            
            // 关闭状态栏菊花
            
            [self close];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
            // 超时
            
            failure(operation, error);
            
            
            
            // 关闭状态栏菊花
            
            [self close];
            
        }];*/
        
    }
    
    
    
    
    
    
    
    
    
    // POST, PUT方法通用处理 =================================================================================
    
    
    
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])
        
    {
        
        // 0. 拼接完整的URL地址
        
        NSMutableArray *laterArr = [NSMutableArray array];
        
        
        
        for (NSString *key in [parameter allKeys]) {
            
            
            
            NSString *keyValue = [key stringByAppendingFormat:@"=%@",[parameter objectForKey:key]];
            
            [laterArr addObject:keyValue];
            
        }
        
        
        
//        NSString *laterURL = [laterArr componentsJoinedByString:@"&"];
        
//        NSString *finalURL = [frontURL stringByAppendingFormat:@"?%@", laterURL];
        
        
        
        
        
        // 1.初始化
        
       NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:frontURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
        
        
        
        
        
        // 2.设置请求类型
        
        request.HTTPMethod = method;

        
        // 3.设置超时时间
        
        request.timeoutInterval = timeoutInterval;
        
        // 4.设置消息头
        
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
                
            }
            
        }
        
        
        
        
        
        // 5.设置消息体
        
        if (body) {
            request.HTTPBody = body;
        }
        
        
        
        
        
        // 6.请求
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        operation.securityPolicy = securityPolicy;
        operation.responseSerializer =[AFJSONResponseSerializer serializer];
        operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//        request.HTTPShouldHandleCookies = YES;
        
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            
            // 成功
            
            success(operation, responseObject);
            
            
            
            // 关闭状态栏菊花
            
            [self close];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
            // 超时
            
            failure(operation, error);
            
            
            
            // 关闭状态栏菊花
            
            [self close];
            
        }];
        
        
        
        [operation start];
        
    }
    
}



- (void)loginRequestWithHeader:(NSDictionary *)header body:(NSMutableData *)body timeoutInterVal:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    // 1.初始化
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://i.instagram.com/api/v1/accounts/login/"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
    // 2.设置请求类型
    
    request.HTTPMethod = @"POST";
    // 3.设置超时时间
    
    request.timeoutInterval = timeoutInterval;
    
    // 4.设置消息头
    
    if (header) {
        
        
        
        for (NSString *key in [header allKeys]) {
            
            [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            
        }
        
    }
    
    
    
    
    
    // 5.设置消息体
    
    if (body) {
        
        
        
        request.HTTPBody = body;
        
    }
    
    
    
    
    
    // 6.请求
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer =[AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        request.HTTPShouldHandleCookies = YES;
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        // 成功
        
        success(operation, responseObject);
        
        
        
        // 关闭状态栏菊花
        
        [self close];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        // 超时
        
        failure(operation, error);
        
        
        
        // 关闭状态栏菊花
        
        [self close];
        
    }];
    
    
    
    [operation start];

}

- (void)likeRequestWithUrl:(NSString *)likeUrl header:(NSDictionary *)header body:(NSMutableData *)body timeoutInterVal:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    // 1.初始化
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:likeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
    // 2.设置请求类型
    
    request.HTTPMethod = @"POST";
    // 3.设置超时时间
    
    request.timeoutInterval = timeoutInterval;
    
    // 4.设置消息头
    
    if (header) {
        
        
        
        for (NSString *key in [header allKeys]) {
            
            [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            
        }
        
    }
    
    
    
    
    
    // 5.设置消息体
    
    if (body) {
        
        
        
        request.HTTPBody = body;
        
    }
    
    
    
    
    
    // 6.请求
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer =[AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        request.HTTPShouldHandleCookies = YES;
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        // 成功
        
        success(operation, responseObject);
        
        
        
        // 关闭状态栏菊花
        
        [self close];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        // 超时
        
        failure(operation, error);
        
        
        
        // 关闭状态栏菊花
        
        [self close];
        
    }];
    
    
    
    [operation start];

}


- (void)followRequestWithUrl:(NSString *)followUrl header:(NSDictionary *)header body:(NSMutableData *)body timeoutInterVal:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 1.初始化
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:followUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
    // 2.设置请求类型
    
    request.HTTPMethod = @"POST";
    // 3.设置超时时间
    
    request.timeoutInterval = timeoutInterval;
    
    // 4.设置消息头
    
    if (header) {
        
        
        
        for (NSString *key in [header allKeys]) {
            
            [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            
        }
        
    }
    
    
    
    
    
    // 5.设置消息体
    
    if (body) {
        
        
        
        request.HTTPBody = body;
        
    }
    
    
    
    
    
    // 6.请求
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer =[AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        request.HTTPShouldHandleCookies = YES;
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        // 成功
        
        success(operation, responseObject);
        
        
        
        // 关闭状态栏菊花
        
        [self close];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        // 超时
        
        failure(operation, error);
        
        
        
        // 关闭状态栏菊花
        
        [self close];
        
    }];
    
    
    
    [operation start];
}



#pragma mark - private methods

// 开启状态栏菊花

- (void)open

{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}



// 关闭状态栏菊花

- (void)close

{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}
@end