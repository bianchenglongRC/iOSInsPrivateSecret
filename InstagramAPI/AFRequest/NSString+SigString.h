//
//  NSString+SigString.h
//  test
//
//  Created by Blues on 21/8/15.
//  Copyright (c) 2015年 Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>


@interface NSString (SigString)

+ (NSString *)signWithKey:(NSString *)key usingData:(NSString *)data;
+ (NSString *)sbJsonRecoverDic:(NSDictionary *)dic;
+ (NSString *)getUniqueStrByUUID;

@end
