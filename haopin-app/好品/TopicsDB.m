//
//  TopicsDB.m
//  haopin
//
//  Created by 朱明科 on 16/3/18.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "TopicsDB.h"
#import "FMDatabase.h"
@implementation TopicsDB{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static TopicsDB *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TopicsDB alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"topic.db"];
    NSLog(@"主题--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists topicList (orignX double,orignY double,frameWidth double,frameHeight double,Tag varchar(1024) primary key,image blob,currentYear varchar(1024),currentDate varchar(1024),detail varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建主题数据库成功");
    }else{
        NSLog(@"创建主题货数据库失败");
    }
}
- (void)addDetailModel:(TopicsModel *)model{
    NSString *sql = @"insert into topicList(orignX,orignY,frameWidth,frameHeight,Tag,image,currentYear,currentDate,detail)values(?,?,?,?,?,?,?,?,?)";
    NSData *data = UIImagePNGRepresentation(model.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,@(model.orignX),@(model.orignY),@(model.frameWidth),@(model.frameHeight),model.Tag,data,model.currentYear,model.currentDate,model.detail];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}

-(NSMutableArray *)fetchKTByYear:(NSString *)year andDate:(NSString *)date{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from topicList where currentYear = ? and currentDate = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,year,date];
    while (set.next) {
        TopicsModel *detailModel = [[TopicsModel alloc] init];
        detailModel.orignX = [set doubleForColumn:@"orignX"];
        detailModel.orignY  = [set doubleForColumn:@"orignY"];
        detailModel.frameWidth = [set doubleForColumn:@"frameWidth"];
        detailModel.frameHeight = [set doubleForColumn:@"frameHeight"];
        detailModel.Tag = [set stringForColumn:@"Tag"];
        detailModel.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        detailModel.currentYear = [set stringForColumn:@"currentYear"];
        detailModel.currentDate = [set stringForColumn:@"currentDate"];
        detailModel.detail = [set stringForColumn:@"detail"];
        [mutArray addObject:detailModel];
    }
    [set close];
    return mutArray;
}
-(void)update:(TopicsModel *)model{
    NSString *sql =@"update topicList set orignX = ?, orignY = ?, frameWidth = ?, frameHeight = ?,  image = ?,currentYear = ?,currentDate = ? ,detail = ? where Tag = ?";
    NSData *data = UIImagePNGRepresentation(model.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,@(model.orignX),@(model.orignY),@(model.frameWidth),@(model.frameHeight),data,model.currentYear,model.currentDate,model.detail,model.Tag];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date{
    NSString *sql = @"delete from topicList where currentYear = ? and currentDate = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session,date];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteByTag:(NSString *)tag{
    NSString *sql = @"delete from topicList where Tag = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,tag];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteBySession:(NSString *)session{
    NSString *sql = @"delete from topicList where currentYear = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
@end
