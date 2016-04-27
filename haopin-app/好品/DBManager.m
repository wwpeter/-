//
//  DBManager.m
//  好品
//
//  Created by 朱明科 on 15/12/14.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static DBManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[DBManager alloc]init];
    });
    return shareInstance;
}
-(instancetype)init{
    if (self = [super init]) {
        [self createDataBase];
    }
    return self;
}
-(void)createDataBase{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"combinPhoto.db"];
    NSLog(@"组合数据--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists combinList (combinName varchar(1024),combinTime varchar(1024),combinDetail varchar(1024) primary key,combinImage blob,combinYear varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建数据库成功");
    }else{
        NSLog(@"创建数据库失败");
    }
}
//增加组合
-(void)addCombin:(Combin *)combin{
    NSString *sql = @"insert into combinList(combinName,combinTime,combinDetail,combinImage,combinYear)values(?,?,?,?,?)";
    NSData *data = UIImageJPEGRepresentation(combin.combinImage, 1.0);
    BOOL isSuccess = [_dataBase executeUpdate:sql,combin.combinName,combin.combinTime,combin.combinDetail,data,combin.combinYear];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(void)update:(Combin *)ktModel{
    NSString *sql =@"update combinList set combinName = ?, combinTime = ?, combinImage = ?,combinYear = ? where combinDetail = ?";
    NSData *data = UIImagePNGRepresentation(ktModel.combinImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,ktModel.combinName,ktModel.combinTime,data,ktModel.combinYear,ktModel.combinDetail];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
//删除
-(void)deleteByDetailTimer:(NSString *)detail{
    NSString *sql = @"delete from combinList where combinDetail = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,detail];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByYear:(NSString *)year{
    NSString *sql = @"delete from combinList where combinYear = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,year];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
//查询所有
- (NSMutableArray *)fetchByYear:(NSString *)yearStr{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from combinList where combinYear = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,yearStr];
    while (set.next) {
        Combin *combin = [[Combin alloc] init];
        combin.combinName = [set stringForColumn:@"combinName"];
        combin.combinTime  = [set stringForColumn:@"combinTime"];
        combin.combinDetail = [set stringForColumn:@"combinDetail"];
        combin.combinImage = [UIImage imageWithData:[set dataForColumn:@"combinImage"]];
        combin.combinYear = [set stringForColumn:@"combinYear"];
        [mutArray addObject:combin];
    }
    [set close];
    return mutArray;
}
-(Combin *)fetchByDetail:(NSString *)combinDetail{
    Combin *combin = [[Combin alloc] init];
    NSString *sql = @"select * from combinList where combinDetail = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,combinDetail];
    while (set.next) {
        combin.combinName = [set stringForColumn:@"combinName"];
        combin.combinTime  = [set stringForColumn:@"combinTime"];
        combin.combinDetail = [set stringForColumn:@"combinDetail"];
        combin.combinImage = [UIImage imageWithData:[set dataForColumn:@"combinImage"]];
        combin.combinYear = [set stringForColumn:@"combinYear"];
    }
    [set close];
    return combin;
}
@end
