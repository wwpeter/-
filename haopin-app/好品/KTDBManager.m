//
//  KTDBManager.m
//  好品
//
//  Created by 朱明科 on 15/12/29.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "KTDBManager.h"
#import "FMDatabase.h"
@implementation KTDBManager{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static KTDBManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[KTDBManager alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"ktPhoto.db"];
    NSLog(@"KT板数据--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists ktList (ktDetail varchar(1024) primary key, ktYear varchar(1024),ktBod varchar(1024),ktImage blob)";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建数据库成功");
    }else{
        NSLog(@"创建数据库失败");
    }
}
-(void)addKTModel:(KTModel *)ktModel{
    NSString *sql = @"insert into ktList(ktDetail,ktYear,ktBod,ktImage)values(?,?,?,?)";
    NSData *data = UIImageJPEGRepresentation(ktModel.ktImage, 1.0);
    BOOL isSuccess = [_dataBase executeUpdate:sql,ktModel.ktDetail,ktModel.ktYear,ktModel.ktBod,data];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
//用主键唯一标识
-(void)update:(KTModel *)ktModel{
    NSString *sql =@"update ktList set ktYear = ?, ktBod = ?, ktImage = ? where ktDetail = ?";
    NSData *data = UIImageJPEGRepresentation(ktModel.ktImage, 1.0);
    BOOL isSuccess = [_dataBase executeUpdate:sql,ktModel.ktYear,ktModel.ktBod,data,ktModel.ktDetail];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(void)deleteByKtDetail:(NSString *)ktDetail{
    NSString *sql = @"delete from ktList where ktDetail = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,ktDetail];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteBySession:(NSString *)session{
    NSString *sql = @"delete from ktList where ktYear = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(NSMutableArray *)fetchAll{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from ktList";
    FMResultSet *set = [_dataBase executeQuery:sql];
    while (set.next) {
        KTModel *ktModel = [[KTModel alloc] init];
        ktModel.ktDetail = [set stringForColumn:@"ktDetail"];
        ktModel.ktYear  = [set stringForColumn:@"ktYear"];
        ktModel.ktBod = [set stringForColumn:@"ktBod"];
        ktModel.ktImage = [UIImage imageWithData:[set dataForColumn:@"ktImage"]];
        [mutArray addObject:ktModel];
    }
    [set close];
    return mutArray;
}
-(NSMutableArray *)fetchBySession:(NSString *)session bod:(NSString *)bod{
    NSMutableArray *mltArray = [NSMutableArray array];
    NSString *sql = @"select * from ktList where ktYear = ? and ktBod = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,bod];
    while (set.next) {
        KTModel *ktModel = [[KTModel alloc]init];
        ktModel.ktDetail = [set stringForColumn:@"ktDetail"];
        ktModel.ktYear = [set stringForColumn:@"ktYear"];
        ktModel.ktBod = [set stringForColumn:@"ktBod"];
        ktModel.ktImage = [UIImage imageWithData:[set dataForColumn:@"ktImage"]];
        [mltArray addObject:ktModel];
    }
    [set close];
    return mltArray;
}
@end
