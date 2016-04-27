
//
//  BQDetailDB.m
//  haopin
//
//  Created by 朱明科 on 16/3/3.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "BQDetailDB.h"
#import "FMDatabase.h"
@implementation BQDetailDB
{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static BQDetailDB *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[BQDetailDB alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"BQDetail.db"];
    NSLog(@"详情板墙数据--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists detailList (orignX double,orignY double,frameWidth double,frameHeight double,detailTag varchar(1024) primary key,image blob,bgImage blod,detailYear varchar(1024),detailBod varchar(1024),vvID carchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建数据库成功");
    }else{
        NSLog(@"创建数据库失败");
    }
}
-(void)addDetailModel:(BQDetailModel *)detailModel{
    NSString *sql = @"insert into detailList(orignX,orignY,frameWidth,frameHeight,detailTag,image,bgImage,detailYear,detailBod,vvID)values(?,?,?,?,?,?,?,?,?,?)";
    NSData *data = UIImagePNGRepresentation(detailModel.image);
    NSData *data2 = UIImagePNGRepresentation(detailModel.bgImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,@(detailModel.orignX),@(detailModel.orignY),@(detailModel.frameWidth),@(detailModel.frameHeight),detailModel.detailTag,data,data2,detailModel.detailYear,detailModel.detailBod,detailModel.vvID];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(void)update:(BQDetailModel *)detailModel{
    NSString *sql =@"update detailList set orignX = ?, orignY = ?, frameWidth = ?, frameHeight = ?,  image = ?,bgImage = ?,detailYear = ?,detailBod = ?,vvID = ? where detailTag = ?";
    NSData *data = UIImagePNGRepresentation(detailModel.image);
    NSData *data2 = UIImagePNGRepresentation(detailModel.bgImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,@(detailModel.orignX),@(detailModel.orignY),@(detailModel.frameWidth),@(detailModel.frameHeight),data,data2,detailModel.detailYear,detailModel.detailBod,detailModel.vvID,detailModel.detailTag];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(void)deleteByDetailTag:(NSString *)detailTag{
    NSString *sql = @"delete from detailList where detailTag = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,detailTag];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteBySession:(NSString *)session andBond:(NSString *)bod{
    NSString *sql = @"delete from detailList where detailYear = ? and detailBod = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session,bod];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteBySession:(NSString *)session{
    NSString *sql = @"delete from detailList where detailYear = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByVVID:(NSString *)vvid{
    NSString *sql = @"delete from detailList where vvID = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,vvid];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}

-(NSMutableArray *)fetchBySession:(NSString *)session bod:(NSString *)bod{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from detailList where detailYear = ? and detailBod = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,bod];
    while (set.next) {
        BQDetailModel *detailModel = [[BQDetailModel alloc] init];
        detailModel.orignX = [set doubleForColumn:@"orignX"];
        detailModel.orignY  = [set doubleForColumn:@"orignY"];
        detailModel.frameWidth = [set doubleForColumn:@"frameWidth"];
        detailModel.frameHeight = [set doubleForColumn:@"frameHeight"];
        detailModel.detailTag = [set stringForColumn:@"detailTag"];
        detailModel.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        detailModel.bgImage = [UIImage imageWithData:[set dataForColumn:@"bgImage"]];
        detailModel.detailYear = [set stringForColumn:@"detailYear"];
        detailModel.detailBod = [set stringForColumn:@"detailBod"];
        detailModel.vvID = [set stringForColumn:@"vvID"];
        [mutArray addObject:detailModel];
    }
    [set close];
    return mutArray;
}
-(NSMutableArray *)fetchByVVID:(NSString *)vvid{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from detailList where vvID = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,vvid];
    while (set.next) {
        BQDetailModel *detailModel = [[BQDetailModel alloc] init];
        detailModel.orignX = [set doubleForColumn:@"orignX"];
        detailModel.orignY  = [set doubleForColumn:@"orignY"];
        detailModel.frameWidth = [set doubleForColumn:@"frameWidth"];
        detailModel.frameHeight = [set doubleForColumn:@"frameHeight"];
        detailModel.detailTag = [set stringForColumn:@"detailTag"];
        detailModel.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        detailModel.bgImage = [UIImage imageWithData:[set dataForColumn:@"bgImage"]];
        detailModel.detailYear = [set stringForColumn:@"detailYear"];
        detailModel.detailBod = [set stringForColumn:@"detailBod"];
        detailModel.vvID = [set stringForColumn:@"vvID"];
        [mutArray addObject:detailModel];
    }
    [set close];
    return mutArray;
}

@end
