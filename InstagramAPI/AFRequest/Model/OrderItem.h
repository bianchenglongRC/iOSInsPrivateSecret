//
//  OrderItem.h
//  iOSLike4Like
//
//  Created by Blues on 5/8/15.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "ModelBase.h"
#import "ModelList.h"

@interface OrderItem : ModelBase

@property (nonatomic, strong)NSNumber *orderid;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *userid;
@property (nonatomic, assign)NSInteger isfee;
@property (nonatomic, strong)NSString *picurl;
@property (nonatomic, strong)NSString *actnum;
@property (nonatomic, strong)NSString *created_time;
@property (nonatomic, strong)NSString *date_time;
@property (nonatomic, strong)NSString *picid;
@property (nonatomic, strong)NSString *likenum;



@end


@interface OrderList : ModelList


@end
