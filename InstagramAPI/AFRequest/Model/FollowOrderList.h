//
//  FollowOrderList.h
//  InstagramAPI
//
//  Created by Blues on 15/10/27.
//  Copyright © 2015年 Blues. All rights reserved.
//

#import "ModelList.h"
#import "ModelBase.h"


@interface FollowOrderItem : ModelBase

@property (nonatomic, strong)NSNumber *followID;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *userid;
@property (nonatomic, assign)NSInteger isfee;
@property (nonatomic, strong)NSString *picurl;
@property (nonatomic, strong)NSString *actnum;
@property (nonatomic, strong)NSString *created_time;
@property (nonatomic, strong)NSString *date_time;
@property (nonatomic, strong)NSString *likenum;
@property (nonatomic, strong)NSString *username;

@end

@interface FollowOrderList : ModelList

@end


