//
//  Database.m
//  BletcShop
//
//  Created by Bletc on 16/9/5.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "Database.h"

@implementation Database


static FMDatabase *db;
+(FMDatabase*)sharedatabase;
{
    if (db==nil)
    {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *filename = [path stringByAppendingPathComponent:@"database.sqlite"];

//        NSString *path=[path stringByAppendingPathComponent:@"database.sqlite"];
        NSLog(@"%@",filename);
        db=[[FMDatabase alloc]initWithPath:filename];
    }
    return db;
}

+(void)savePerdon:(Person*)person;
{
    if (![db open]) {
        [db close];
    }
    
    FMResultSet *result=[db executeQueryWithFormat:@"select * from t_person where idstring=%@",person.idstring];

    if ([result next]) {
        //首先查询看这个表里面是否有
  
        BOOL rs = [db executeUpdate:@"delete from t_person where idstring = ?",person.idstring];
        if (!rs) {
            NSLog(@"erro");
        }else{
            
            NSLog(@"success===%@",person.idstring);
            [db executeUpdateWithFormat:@"insert into t_person (name,imgstr,idstring) values(%@,%@,%@)",person.name,person.imgStr,person.idstring];

        }
        

    }else{
        [db executeUpdateWithFormat:@"insert into t_person (name,imgstr,idstring) values(%@,%@,%@)",person.name,person.imgStr,person.idstring];

    }
    [result close];
    
    NSLog(@"+++++++++ %@",person.name);
}

+(NSArray *)searchPersonFromID:(NSString*)IDstring;
{
    if (![db open]) {
        [db close];
    }
    
    FMResultSet *result  = [db executeQueryWithFormat:@"SELECT * FROM t_person WHERE idstring =  %@",IDstring];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([result next]) {
        Person *obj = [[Person alloc]init];
        obj.name = [result stringForColumn:@"name"];
        obj.imgStr = [result stringForColumn:@"imgstr"];
        obj.idstring = [result stringForColumn:@"idstring"];
//        obj.ID = [result intForColumn:@"id"];

        [array addObject:obj];
        
    }
    return array;

    
}


@end
