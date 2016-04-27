//
//  NewKTDetail.m
//  haopin
//
//  Created by 朱明科 on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "NewKTDetail.h"
#import "FMDatabase.h"
@implementation NewKTDetail{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static NewKTDetail *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[NewKTDetail alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"NewKTDetail.db"];
    NSLog(@"新KT数据详情--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists newKTDetailList (orignX double,orignY double,frameWidth double,frameHeight double,Tag varchar(1024) primary key,image blob,currentYear varchar(1024),currentDate varchar(1024),currentGan varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建KT杆货数据库成功");
    }else{
        NSLog(@"创建KT杆货数据库失败");
    }
}
-(void)update:(NewKTDetailModel *)detailModel{
    NSString *sql =@"update newKTDetailList set orignX = ?, orignY = ?, frameWidth = ?, frameHeight = ?,  image = ?,currentYear = ?,currentDate = ? ,currentGan = ? where Tag = ?";
    NSData *data = UIImagePNGRepresentation(detailModel.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,@(detailModel.orignX),@(detailModel.orignY),@(detailModel.frameWidth),@(detailModel.frameHeight),data,detailModel.currentYear,detailModel.currentDate,detailModel.currentGan,detailModel.Tag];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(void)addDetailModel:(NewKTDetailModel *)detailModel{
    NSString *sql = @"insert into newKTDetailList(orignX,orignY,frameWidth,frameHeight,Tag,image,currentYear,currentDate,currentGan)values(?,?,?,?,?,?,?,?,?)";
    NSData *data = UIImagePNGRepresentation(detailModel.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,@(detailModel.orignX),@(detailModel.orignY),@(detailModel.frameWidth),@(detailModel.frameHeight),detailModel.Tag,data,detailModel.currentYear,detailModel.currentDate,detailModel.currentGan];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(NSMutableArray *)fetchKTByYear:(NSString *)year andDate:(NSString *)date andGan:(NSString *)gan{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from newKTDetailList where currentYear = ? and currentDate = ? and currentGan = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,year,date,gan];
    while (set.next) {
        NewKTDetailModel *detailModel = [[NewKTDetailModel alloc] init];
        detailModel.orignX = [set doubleForColumn:@"orignX"];
        detailModel.orignY  = [set doubleForColumn:@"orignY"];
        detailModel.frameWidth = [set doubleForColumn:@"frameWidth"];
        detailModel.frameHeight = [set doubleForColumn:@"frameHeight"];
        detailModel.Tag = [set stringForColumn:@"Tag"];
        detailModel.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        detailModel.currentYear = [set stringForColumn:@"currentYear"];
        detailModel.currentDate = [set stringForColumn:@"currentDate"];
        detailModel.currentGan = [set stringForColumn:@"currentGan"];
        [mutArray addObject:detailModel];
    }
    [set close];
    return mutArray;
}
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date{
    NSString *sql = @"delete from newKTDetailList where currentYear = ? and currentDate = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session,date];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByTag:(NSString *)tag{
    NSString *sql = @"delete from newKTDetailList where Tag = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,tag];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteBySession:(NSString *)session{
    NSString *sql = @"delete from newKTDetailList where currentYear = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
@end
