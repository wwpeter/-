//
//  DataManager.m
//  好品
//
//  Created by 朱明科 on 15/12/28.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "DataManager.h"
#import "FMDatabase.h"
@implementation DataManager{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static DataManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[DataManager alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"bondPhoto.db"];
    NSLog(@"板墙数据--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists bondList (bondName varchar(1024),bondTime varchar(1024),bondDetail varchar(1024) primary key,bondBod varchar(1024),bondImage blob,bondYear varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建数据库成功");
    }else{
        NSLog(@"创建数据库失败");
    }
}
//增加板墙
-(void)addBond:(Bond *)bond{
    NSString *sql = @"insert into bondList(bondName,bondTime,bondDetail,bondBod,bondImage,bondYear)values(?,?,?,?,?,?)";
    NSData *data = UIImageJPEGRepresentation(bond.bondImage, 1.0);
    BOOL isSuccess = [_dataBase executeUpdate:sql,bond.bondName,bond.bondTime,bond.bondDetail,bond.bondBod,data,bond.bondYear];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(void)update:(Bond *)ktModel{
    NSString *sql =@"update bondList set bondName = ?, bondTime = ?, bondBod = ?,bondImage = ? ,bondYear = ? where bondDetail = ?";
    NSData *data = UIImagePNGRepresentation(ktModel.bondImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,ktModel.bondName,ktModel.bondTime,ktModel.bondBod,data,ktModel.bondYear,ktModel.bondDetail];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}

//删除
-(void)deleteByDetailTimer:(NSString *)detail{
    NSString *sql = @"delete from bondList where bondDetail = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,detail];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByYear:(NSString *)year{
    NSString *sql = @"delete from bondList where bondYear = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,year];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
//查询所有
- (NSMutableArray *)fetchByYear:(NSString *)year{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from bondList where bondYear = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,year];
    while (set.next) {
        Bond *bond = [[Bond alloc] init];
        bond.bondName = [set stringForColumn:@"bondName"];
        bond.bondTime  = [set stringForColumn:@"bondTime"];
        bond.bondDetail = [set stringForColumn:@"bondDetail"];
        bond.bondBod = [set stringForColumn:@"bondBod"];
        bond.bondImage = [UIImage imageWithData:[set dataForColumn:@"bondImage"]];
        bond.bondYear = [set stringForColumn:@"bondYear"];
        [mutArray addObject:bond];
    }
    [set close];
    return mutArray;
}
-(Bond *)fetchByDetail:(NSString *)detail{
    Bond *bond = [[Bond alloc] init];
    NSString *sql = @"select * from bondList where bondDetail = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,detail];
    while (set.next) {
        bond.bondName = [set stringForColumn:@"bondName"];
        bond.bondTime  = [set stringForColumn:@"bondTime"];
        bond.bondDetail = [set stringForColumn:@"bondDetail"];
        bond.bondBod = [set stringForColumn:@"bondBod"];
        bond.bondImage = [UIImage imageWithData:[set dataForColumn:@"bondImage"]];
        bond.bondYear = [set stringForColumn:@"bondYear"];
    }
    [set close];
    return bond;
}
@end
