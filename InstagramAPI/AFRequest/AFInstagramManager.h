//
//  AFInstagramManager.h
//  iOSLike4Like
//
//  Created by Blues on 15/9/10.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFInstagramManager : NSObject

+ (instancetype)shareManager;
- (void)requestDataWithFrontURL:(NSString *)frontURL method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSMutableData *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)loginRequestWithHeader:(NSDictionary *)header body:(NSMutableData *)body timeoutInterVal:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)likeRequestWithUrl:(NSString *)likeUrl header:(NSDictionary *)header body:(NSMutableData *)body timeoutInterVal:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)followRequestWithUrl:(NSString *)followUrl header:(NSDictionary *)header body:(NSMutableData *)body timeoutInterVal:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
