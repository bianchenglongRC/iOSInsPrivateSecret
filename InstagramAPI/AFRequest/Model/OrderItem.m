//
//  OrderItem.m
//  iOSLike4Like
//
//  Created by Blues on 5/8/15.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

- (NSDictionary*)dictionaryAlias
{
    return @{@"orderid":@[@"id"]};
}


@end


@implementation OrderList

+(Class)elementClass
{
    return [OrderItem class];
}

@end
