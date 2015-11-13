//
//  RC_RequestManager.h
//  FacebookHealth
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RC_RequestManager : NSObject

+ (RC_RequestManager *)shareInstance;

//- (void)getInstagramMedia:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;



- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)getInstagramToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

///服务器登录
-(void)registeUseInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

///获取基本参数
-(void)requestForBaseParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

///金币查询
-(void)queryGoldInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

///充值
-(void)requestForRecharge:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failue;


///充值2

-(void)rechargeWithProductid:(NSString *)productid balance:(NSNumber *)balance currency:(NSString *)currency gold_num:(NSNumber *)gold_num isfree:(NSNumber *)isfree remark:(NSString *)remark transactionIdentifier:(NSString *)transactionIdentifier Success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;


///下Like订单
-(void)requestToGetLikeForThisPictureWithMediaItem:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;


///获取like订单
-(void)requestPictureFormSeverWithParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

///获取follow订单
-(void)requestUserFormSeverWithParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

///消耗Like
-(void)requestPostOrderToSever:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

///连续登录 签到
-(void)SigninReward:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)requestPostNoUseOrderSeverWithParm:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)reportUser:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;


-(void)updateClassify:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)postFollows:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)getFollows:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)updateShareIg:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)updateFiveStart:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)updateAdvCoin:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)getUserInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)postOrders:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;



- (void)cancleAllRequests;

@end
