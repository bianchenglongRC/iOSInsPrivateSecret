//
//  FollowOrderList.m
//  InstagramAPI
//
//  Created by Blues on 15/10/27.
//  Copyright © 2015年 Blues. All rights reserved.
//

#import "FollowOrderList.h"

@implementation FollowOrderList


+(Class)elementClass
{
    return [FollowOrderItem class];
}

@end


@implementation FollowOrderItem

- (NSDictionary*)dictionaryAlias
{
    return @{@"followID":@[@"id"]};
}


@end