//
//  ErrorItem.h
//  InstagramAPI
//
//  Created by Blues on 15/11/16.
//  Copyright © 2015年 Blues. All rights reserved.
//

#import "ModelBase.h"

@interface ErrorItem : ModelBase

@property (nonatomic, strong)NSString *errorid;
@property (nonatomic, strong)NSString *errorstr;
@property (nonatomic, strong)NSString *number;
@property (nonatomic, strong)NSString *time;

@end
