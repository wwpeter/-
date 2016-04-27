//
//  ScrollDB.m
//  haopin
//
//  Created by ww on 16/3/29.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ScrollDB.h"

@implementation ScrollDB{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static ScrollDB *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ScrollDB alloc]init];
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
    NSString *sql = @"create table if not exists scrollList (image blob,year varchar(1024),date varchar(1024),tag varchar(1024) primary key,type varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建截图数据库成功");
    }else{
        NSLog(@"创建截图数据库失败");
    }
}
-(void)addDetailModel:(ScrollModel *)model{
    NSString *sql = @"insert into scrollList(image,year,date,tag,type)values(?,?,?,?,?)";
    NSData *data = UIImagePNGRepresentation(model.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,data,model.year,model.date,model.tag,model.type];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(ScrollModel *)fetchByYear:(NSString *)year andDate:(NSString *)date andType:(NSString *)type{
    // NSMutableArray *mutArray = [NSMutableArray array];
    ScrollModel *model = [[ScrollModel alloc]init];
    NSString *sql = @"select * from scrollList where year = ? and date = ? and type = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,year,date,type];
    while (set.next) {
        //ZhuTiModel *model = [[ZhuTiModel alloc] init];
        model.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        model.year = [set stringForColumn:@"year"];
        model.date = [set stringForColumn:@"date"];
        model.tag = [set stringForColumn:@"tag"];
        model.type = [set stringForColumn:@"type"];
        //[mutArray addObject:model];
    }
    [set close];
    return model;
}
-(void)update:(ScrollModel *)model{
    NSString *sql =@"update scrollList set image = ?,year = ?,date = ?,type = ?, where detail = ?";
    NSData *data = UIImagePNGRepresentation(model.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,data,model.year,model.date,model.type];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date{
    NSString *sql = @"delete from scrollList where year = ? and date = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session,date];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByTag:(NSString *)tag{
    NSString *sql = @"delete from scrollList where tag = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,tag];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteBySession:(NSString *)session{
    NSString *sql = @"delete from scrollList where year = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}

@end
