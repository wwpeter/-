//
//  ZhuTiDB.m
//  haopin
//
//  Created by ww on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ZhuTiDB.h"

@implementation ZhuTiDB{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static ZhuTiDB *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ZhuTiDB alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"jietu.db"];
    NSLog(@"截图sql--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists jietuList (image blob,year varchar(1024),date varchar(1024),detail varchar(1024),tag varchar(1024) primary key)";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建截图数据库成功");
    }else{
        NSLog(@"创建截图数据库失败");
    }
}
-(void)addDetailModel:(ZhuTiModel *)model{
    NSString *sql = @"insert into jietuList(image,year,date,detail,tag)values(?,?,?,?,?)";
    NSData *data = UIImagePNGRepresentation(model.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,data,model.year,model.date,model.detail,model.tag];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(ZhuTiModel *)fetchKTByYear:(NSString *)year andDate:(NSString *)date andDetail:(NSString *)detail{
   // NSMutableArray *mutArray = [NSMutableArray array];
    ZhuTiModel *model = [[ZhuTiModel alloc]init];
    NSString *sql = @"select * from jietuList where year = ? and date = ? and detail = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,year,date,detail];
    while (set.next) {
        //ZhuTiModel *model = [[ZhuTiModel alloc] init];
        model.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        model.year = [set stringForColumn:@"year"];
        model.date = [set stringForColumn:@"date"];
        model.detail = [set stringForColumn:@"detail"];
        model.tag = [set stringForColumn:@"tag"];
        //[mutArray addObject:model];
    }
    [set close];
    return model;
}
-(void)update:(ZhuTiModel *)model{
    NSString *sql =@"update jietuList set image = ?,year = ?,date = ? where detail = ?";
    NSData *data = UIImagePNGRepresentation(model.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,data,model.year,model.date,model.detail];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date{
    NSString *sql = @"delete from jietuList where year = ? and date = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session,date];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByTag:(NSString *)tag{
    NSString *sql = @"delete from jietuList where tag = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,tag];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteBySession:(NSString *)session{
    NSString *sql = @"delete from jietuList where year = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
@end
