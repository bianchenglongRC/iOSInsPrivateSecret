//
//  Utility.h
//  DatingForDating
//
//  Created by MAXToooNG on 16/3/24.
//  Copyright © 2016年 MaxToooNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (NSString *) udid;
+ (NSString *) md5:(NSString *)str;
+ (NSString *) doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;
+ (NSString *) encryptStr:(NSString *) str;
+ (NSString *) decryptStr:(NSString *) str;
+ (NSData *)hexStringToNSData:(NSString *)str;

// 和服务端调试过的配置
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;

#pragma mark Based64
+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;


@end
