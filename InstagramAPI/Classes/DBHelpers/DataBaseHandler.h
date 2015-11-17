//
//  DataBaseHandler.h
//  数据库
//
//  Created by 卞卞 on 14-9-19.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorItem.h"

//所有数据库的操作都在这个类中处理

//把这个类写成单例 (在一个应用里面,只会产生一个对象)

#import <sqlite3.h>

@interface DataBaseHandler : NSObject

//单例方法

{
    //创建一个数据库指针,只想本地的数据库文件
    sqlite3 *dbPoint;
}



+(DataBaseHandler *)shareInstance;


//在进行数据库的增删改查之前 需要打开数据库(dbPoint跟本地的数据库文件连接起来)

- (void)openDB;
- (void)closeDB;
//创建表
- (void)creatTable;

//删除表
- (void)deleteTable;

//添加数据
- (void)insertErrorID:(NSString *)errorid errorStr:(NSString *)errorstr errorFlag:(NSString *)flag;

//- (void)insertLocationLabel:(LocationModel *)label UserId:(NSString *)userId;

//- (void)insertLabelType:(NSString *)type Name:(NSString *)name ImageUrl:(NSString *)imgUrl UserId:(NSString *)userId;



- (void)deleteErrorWithID:(NSString *)errorid;


//查询
- (NSArray *)selectAllErrorWithFlag:(NSString *)flag;

//按照useId type 查找

- (NSArray *)selectLabelWithUserId:(NSString *)userId Name:(NSString *)name Type:(NSString *)type;

- (NSArray *)selectLabelWithUserId:(NSString *)userId Type:(NSString *)type;






@end
