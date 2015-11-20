//
//  DataBaseHandler.m
//  数据库
//
//  Created by 卞卞 on 14-9-19.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "DataBaseHandler.h"

#import <sqlite3.h>





@implementation DataBaseHandler


    
    
    





+(DataBaseHandler *)shareInstance
{
    
    // static 一个应用程序执行期间,只会执行一次
    static DataBaseHandler *dbHandler = nil;
    
    
    if (dbHandler == nil) {
        //如果指针指向空,就创建一个对象
        dbHandler = [[DataBaseHandler alloc] init];   //单例不能release
//        [dbHandler openDB];   //数据库打开 放在单例方法里
//        [dbHandler creatTable];
//        [dbHandler insertStudent:stu];
//        [dbHandler insertEvent:eve];
//        [dbHandler insertStudent:];
        
    
    }
    
    return dbHandler;
    
    

    
}

- (void)openDB
{
    //打开数据库函数
    
//    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"error.db"];
    
    NSLog(@"%@", dbPath);
    
    
    //参数1:数据库文件的路径
    //参数2:数据库指针的文件
    
    
    int result = sqlite3_open([dbPath UTF8String] , &dbPoint);
    
    
    
    NSLog(@"打开数据哭:%d", result);
    
    
    
    
}

- (void)closeDB

{
    
    //关闭数据库
    sqlite3_close(dbPoint);
    
}


- (void)creatTable
{
    //执行sql语句的函数
    
    
    //参数1:数据库指针
    //参数2:sql语句
    
    NSString *sql = [NSString stringWithFormat:@"create table error (errorid text, errorstr text, flag text, number text, time text)"];
    int result = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    
    NSLog(@"创建数据库============%d===============", result);
    
    
    
}

- (void)deleteTable
{
    
    NSString *sql = [NSString stringWithFormat:@"drop table error"];
    int result = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    
    NSLog(@"删除表 =============%d================", result);
    
    
}


- (void)insertErrorID:(NSString *)errorid errorStr:(NSString *)errorstr errorFlag:(NSString *)flag Number:(NSString *)number CurrentTime:(NSString *)time
{
    NSString *sql = [NSString stringWithFormat:@"insert into error values ('%@', '%@', '%@' ,'%@', '%@')", errorid, errorstr, flag, number, time];
    int result = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    NSLog(@"插入数据库 是否成功:%d=========++++++++++", result);
}


/*

// 直接插入一个Model类
- (void)insertLabel:(NSString *)label UserId:(NSString *)userId
{
    
    
    NSString *sql = [ NSString stringWithFormat:@"insert into tags values ('%@', '%@', '%@', '%@')",userId, label, label, label];
    
    int result = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    
    NSLog(@"插入数据库 是否成功:%d=========++++++++++", result);
    
    NSLog(@"%@", label);
    
    
}




// 插入各种信息

- (void)insertLabelType:(NSString *)type  Name:(NSString *)name ImageUrl:(NSString *)imgUrl UserId:(NSString *)userId
{
    NSString *sql = [ NSString stringWithFormat:@"insert into tags values ('%@', '%@', '%@', '%@')",userId, type, name, imgUrl];
    
    int result = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    
    NSLog(@"插入数据库 是否成功:%d=========++++++++++", result);
    
    NSLog(@"%@", userId);
    

}
 */


- (void)deleteErrorWithFlag:(NSString *)flagt
{
    NSString *sql = [NSString stringWithFormat:@"delete from error where flag = %@", flagt];
    int flag = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    NSLog(@"删除数据库++++%d", flag);

}

- (void)deleteErrorWithID:(NSString *)errorid
{
    NSString *sql = [NSString stringWithFormat:@"delete from error where namem = %@", errorid];
    int flag = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    NSLog(@"删除数据库++++%d", flag);
}
/*
- (void)deleteLabel:(NSString *)label
{
    
    
    NSString *sql = [NSString stringWithFormat:@"delete from event where name = %@", label];
    
    int flag = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    NSLog(@"删除数据库++++%d", flag);
    
    
    
//    NSString *str = [NSString stringWithFormat:@"delete from event where Id = %@",event.Id];
//        sqlite3_stmt *stmt = nil;//定义sql语句对象
//        int flag = sqlite3_prepare_v2(dbPoint, [str UTF8String], -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
//        if (flag == SQLITE_OK)
//        {
//           
//            sqlite3_step(stmt);
//        }
//    
//        sqlite3_finalize(stmt);//回收stmt对象
    
        NSLog(@"删除了第%@", label);
    NSLog(@"删除数据是否成功%d", flag);
    
    
}
 
 */




/*
- (NSArray *)selectLabelWithUserId:(NSString *)userId Type:(NSString *)type
{
    //1.创建一个数据库指针的替身
    //替身作为一个临时的数据库指针 保存所有对数据库的操作 最终确认无误后写入本地数据库
    
    sqlite3_stmt *stmt = nil;
    
    
    //2.检查sql语句,准备执行
    //作用:把替身和数据库指针连接起来
    //参数1:数据库指针
    //参数2:sql语句
    //参数3:限制sql语句的长度
    //参数4:替身的指针
    
    
    NSString *zSql = [NSString stringWithFormat:@"select * from tags where userId = '%@' and type = '%@'", userId, type];
    int result = sqlite3_prepare_v2(dbPoint, [zSql UTF8String], -1, &stmt, NULL);
    
    NSLog(@"查询数据库是否成功%d",result);
    
    //对sql语句的检查结果进行判断
    
    //但符合sql语句查询条件的结果有多行,就执行循环体的代码
    if (result == SQLITE_OK) {
        
        NSMutableArray *arr = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            //参数1: 替身
            //参数2: 取得是第几列的值
            
//            const unsigned char* sidStr = sqlite3_column_text(stmt, 0);
//            NSString *sid = [NSString stringWithUTF8String:(const char*)sidStr];
            
            
            const unsigned char* stypeStr = sqlite3_column_text(stmt, 1);
            NSString *stype = [NSString stringWithUTF8String:(const char*)stypeStr];
            
//            const unsigned char* sbrandStr = sqlite3_column_text(stmt, 2);
//            NSString *sbrand = [NSString stringWithUTF8String:(const char*)sbrandStr];
            
            const unsigned char* snameStr = sqlite3_column_text(stmt, 2);
            NSString *sname = [NSString stringWithUTF8String:(const char*)snameStr];
            
            const unsigned char* simgUrlStr = sqlite3_column_text(stmt,3);
            NSString *simgUrl = [NSString stringWithUTF8String:(const char*)simgUrlStr];
            
            
            
            
            //            Information *information= [[Information alloc] init];
            
//            RemarkLabelModel *label = [[RemarkLabelModel alloc] init];
//            label.type = stype;
//            label.brand = sbrand;
//            label.name = sname;
//            label.imgUrl = simgUrl;
            
            //            information.stitle = stitle;
            //            information.sdate = sdate;
            //            information.infId = url;
            //            NSLog(@"%@ = +++ ", information.infId);
            //
            //
            //            NSLog(@"查询出的name========%@====+++++++==", information.stitle);
            //            eve.category_name = sqlite3_column_int(stmt, 1);
            //            eve.begin_time = sqlite3_column_double(stmt, 2);
            //把创建好的学生对象添加到数组中
            [arr addObject:label];
            [label release];
            NSLog(@"%@", label);
            
        }
        
        //释放替身的内存占用,将替身的所有操作应用到底层数据库的文件
        sqlite3_finalize(stmt);
        
        return arr;
    }
    
    
    sqlite3_finalize(stmt);
    
    return nil;
    

}

- (NSArray *)selectLabelWithUserId:(NSString *)userId Name:(NSString *)name Type:(NSString *)type
{
    //1.创建一个数据库指针的替身
    //替身作为一个临时的数据库指针 保存所有对数据库的操作 最终确认无误后写入本地数据库
    
    sqlite3_stmt *stmt = nil;
    
    
    //2.检查sql语句,准备执行
    //作用:把替身和数据库指针连接起来
    //参数1:数据库指针
    //参数2:sql语句
    //参数3:限制sql语句的长度
    //参数4:替身的指针
    
    
    NSString *zSql = [NSString stringWithFormat:@"select * from tags where userId = '%@' and name = '%@' and type = '%@'", userId, name, type];
    int result = sqlite3_prepare_v2(dbPoint, [zSql UTF8String], -1, &stmt, NULL);
    
    NSLog(@"查询数据库是否成功%d",result);
    
    //对sql语句的检查结果进行判断
    
    //但符合sql语句查询条件的结果有多行,就执行循环体的代码
    if (result == SQLITE_OK) {
        
        NSMutableArray *arr = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            //参数1: 替身
            //参数2: 取得是第几列的值
            
            const unsigned char* sidStr = sqlite3_column_text(stmt, 0);
            NSString *sid = [NSString stringWithUTF8String:(const char*)sidStr];

            
            const unsigned char* stypeStr = sqlite3_column_text(stmt, 1);
            NSString *stype = [NSString stringWithUTF8String:(const char*)stypeStr];
            
//            const unsigned char* sbrandStr = sqlite3_column_text(stmt, 2);
//            NSString *sbrand = [NSString stringWithUTF8String:(const char*)sbrandStr];
            
            const unsigned char* snameStr = sqlite3_column_text(stmt, 2);
            NSString *sname = [NSString stringWithUTF8String:(const char*)snameStr];
            
            const unsigned char* simgUrlStr = sqlite3_column_text(stmt, 3);
            NSString *simgUrl = [NSString stringWithUTF8String:(const char*)simgUrlStr];

            
            
            
//            Information *information= [[Information alloc] init];
            
            RemarkLabelModel *label = [[RemarkLabelModel alloc] init];
            label.type = stype;
//            label.brand = sbrand;
            label.name = sname;
            label.imgUrl = simgUrl;
            
//            information.stitle = stitle;
//            information.sdate = sdate;
//            information.infId = url;
//            NSLog(@"%@ = +++ ", information.infId);
//            
//            
//            NSLog(@"查询出的name========%@====+++++++==", information.stitle);
            //            eve.category_name = sqlite3_column_int(stmt, 1);
            //            eve.begin_time = sqlite3_column_double(stmt, 2);
            //把创建好的学生对象添加到数组中
            [arr addObject:label];
            [label release];
            NSLog(@"%@", label);
            
        }
        
        //释放替身的内存占用,将替身的所有操作应用到底层数据库的文件
        sqlite3_finalize(stmt);
        
        return arr;
    }
    
    
    sqlite3_finalize(stmt);
    
    return nil;

}

*/


- (NSArray *)selectAllErrorWithFlag:(NSString *)flag
{
    //1.创建一个数据库指针的替身
    //替身作为一个临时的数据库指针 保存所有对数据库的操作 最终确认无误后写入本地数据库
    

    
    sqlite3_stmt *stmt = nil;
    
    
    //2.检查sql语句,准备执行
    //作用:把替身和数据库指针连接起来
    //参数1:数据库指针
    //参数2:sql语句
    //参数3:限制sql语句的长度
    //参数4:替身的指针
    
    
    NSString *zSql = [NSString stringWithFormat:@"select * from error where flag = '%@'", flag];
    int result = sqlite3_prepare_v2(dbPoint, [zSql UTF8String], -1, &stmt, NULL);
    
    NSLog(@"查询数据库是否成功%d",result);
    
    //对sql语句的检查结果进行判断
    
    //但符合sql语句查询条件的结果有多行,就执行循环体的代码
    if (result == SQLITE_OK) {
        
        NSMutableArray *arr = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            //参数1: 替身
            //参数2: 取得是第几列的值


            
            const unsigned char* erroridStr = sqlite3_column_text(stmt, 0);
            NSString *errorid = [NSString stringWithUTF8String:(const char*)erroridStr];
            
            const unsigned char* errorstrStr = sqlite3_column_text(stmt, 1);
            NSString *errorstr = [NSString stringWithUTF8String:(const char*)errorstrStr];
            
            const unsigned char* numberStr = sqlite3_column_text(stmt, 3);
            NSString *number = [NSString stringWithUTF8String:(const char*)numberStr];
//            const unsigned char* snameStr = sqlite3_column_text(stmt, 2);
//            NSString *sname = [NSString stringWithUTF8String:(const char*)snameStr];
//            
            const unsigned char* timeStr = sqlite3_column_text(stmt, 4);
            NSString *time = [NSString stringWithUTF8String:(const char*)timeStr];
            
            
            
            
            //            Information *information= [[Information alloc] init];
            ErrorItem *label = [[ErrorItem alloc] init];
            
            label.errorid = errorid;
            label.errorstr = errorstr;
            label.number = number;
            label.time = time;
//            label.name = sname;
//            label.imgUrl = simgUrl;
            
            //            information.stitle = stitle;
            //            information.sdate = sdate;
            //            information.infId = url;
            //            NSLog(@"%@ = +++ ", information.infId);
            //
            //
            //            NSLog(@"查询出的name========%@====+++++++==", information.stitle);
            //            eve.category_name = sqlite3_column_int(stmt, 1);
            //            eve.begin_time = sqlite3_column_double(stmt, 2);
            //把创建好的学生对象添加到数组中
            [arr addObject:label];
//            [label release];
            NSLog(@"%@", label);
            
        }
        
        //释放替身的内存占用,将替身的所有操作应用到底层数据库的文件
        sqlite3_finalize(stmt);
        
        return arr;
    }
    
    
    sqlite3_finalize(stmt);
    
    return nil;
    
    
}






@end
