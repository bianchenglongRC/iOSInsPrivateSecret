//
//  NSMutableData+generatePostBody.h
//  iOSLike4Like
//
//  Created by Blues on 15/9/11.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableData (generatePostBody)

+ (NSMutableData *)generatePostBodyWithRequestBody:(NSDictionary *)requestBody Boundary:(NSString *)boundary;

@end
