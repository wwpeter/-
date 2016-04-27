//
//  ColerDB.m
//  haopin
//
//  Created by ww on 16/3/31.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ColerDB.h"

@implementation ColerDB{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static ColerDB *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ColerDB alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"addColor.db"];
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists colorList (colorImage blob,tag varchar(1024),detail varchar(1024),colorID varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建截图数据库成功");
    }else{
        NSLog(@"创建截图数据库失败");
    }
}
- (void)addDetailModel:(ColorModel *)model {
    NSString *sql = @"insert into colorList(colorImage,tag,detail,colorID)values(?,?,?,?)";
    NSData *data = UIImagePNGRepresentation(model.colorImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,data,model.tag,model.detail,model.colorID];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(NSMutableArray *)fetchByTag:(NSString *)tag andDetail:(NSString *)detail {
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"select * from colorList where tag = ? and detail = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,tag,detail];
    while (set.next) {
        ColorModel *model = [[ColorModel alloc]init];
        model.colorImage = [UIImage imageWithData:[set dataForColumn:@"colorImage"]];
        model.tag = [set stringForColumn:@"tag"];
        model.detail = [set stringForColumn:@"detail"];
        model.colorID = [set stringForColumn:@"colorID"];
        [array addObject:model];
    }
    [set close];
    return array;
}
-(void)update:(ColorModel *)model {
    NSString *sql =@"update colorList set colorImage = ?,tag = ?,detail= ? where detail = ?  and tag = ? ";
    NSData *data = UIImagePNGRepresentation(model.colorImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,data,model.tag,model.detail];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(void)deleteByTag:(NSString *)tag {
    NSString *sql = @"delete from colorList where tag = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,tag];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByTag:(NSString *)tag andId:(NSString *)colorID{
    NSString *sql = @"delete from colorList where tag = ? and colorID = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,tag,colorID];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
@end
