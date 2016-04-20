//
//  CMethods.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
//#include <stdio.h>

//用户当前的语言环境
#define CURR_LANG   ([[NSLocale preferredLanguages] objectAtIndex:0])

@interface CMethods : NSObject
{
    
}

//十六进制颜色值
UIColor* colorWithHexString(NSString *stringToConvert);
//当前应用的版本
NSString *appVersion();
//统一使用它做 应用本地化 操作
NSString *LocalizedString(NSString *translation_key, id none);
//获取设备型号
NSString *doDevicePlatform();
//获取设备号
NSString* mydeviceUniqueIdentifier();


NSString *stringFromDate(NSDate *date);

void showLabelHUD(NSString *content);

UIImage *getViewImage(UIView *view);

MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView);
void hideMBProgressHUD();

NSString *getCategoryName(int index);

CGFloat getLength(CGFloat length);

CGRect getFrameWithRect(CGFloat x,CGFloat y,CGFloat width,CGFloat height);

@end
