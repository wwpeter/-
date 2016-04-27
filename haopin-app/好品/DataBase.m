//
//  DataBase.m
//  BasketBall
//
//  Created by zhumingke on 15/10/22.
//  Copyright (c) 2015年 朱明科. All rights reserved.
//

#import "DataBase.h"
#import "FMDatabase.h"

@implementation DataBase{
    FMDatabase *_dataBase;
}
+(instancetype)shareInstance{
    static DataBase *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[DataBase alloc]init];
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
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"clothPhoto.db"];
    NSLog(@"货品数据--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists photoList (ind varchar(1024),year varchar(1024),type varchar(1024),bod varchar(1024),color varchar(1024),image blob ,backImage blob,pinkuan varchar(1024),price varhar(1024),designor varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建数据库成功");
    }else{
        NSLog(@"创建数据库失败");
    }
}
-(void)deleteClothByInd:(NSString *)ind{
    NSString *sql = @"delete from photoList where ind = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,ind];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteClothByYear:(NSString *)year{
    NSString *sql = @"delete from photoList where year = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,year];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)deleteClothByYear:(NSString *)year andType:(NSString *)type{
    NSString *sql = @"delete from photoList where year = ? and type = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,year,type];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(void)insertCloth:(ClothPhoto *)cloth{
    NSString *sql = @"insert into photoList(ind,year,type,bod,color,image,backImage,pinkuan,price,designor)values(?,?,?,?,?,?,?,?,?,?)";
    NSData *fdata = UIImagePNGRepresentation(cloth.image);
    NSData *pdata = UIImagePNGRepresentation(cloth.backImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,cloth.ind,cloth.year, cloth.type, cloth.bod,cloth.color, fdata,pdata,cloth.pinkuan,cloth.price,cloth.designor];
    if (!isSuccess) {
       // NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
       // NSLog(@"添加数据成功");
    }
}
-(void)insertClothWithArray:(NSArray *)array isTransaction:(BOOL)isTransaction{
    if (isTransaction) {
        @try {
            [_dataBase beginTransaction];
            for (NSInteger i = 0; i < array.count; i ++) {
                NSDictionary *dict = array[i];
                ClothPhoto *photo = [[ClothPhoto alloc]init];
                photo.ind = dict[@"ind"];
                photo.year = dict[@"year"];
                photo.type = dict[@"type"];
                photo.bod = dict[@"bod"];
                photo.color = dict[@"color"];
                photo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dict[@"image"]]];
                photo.backImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dict[@"backImage"]]];
                photo.pinkuan = dict[@"pinkuan"];
                photo.price = dict[@"price"];
                photo.designor = dict[@"designor"];
                NSString *sql = @"insert into photoList(ind,year,type,bod,color,image,backImage,pinkuan,price,designor)values(?,?,?,?,?,?,?,?,?,?)";
                NSData *fdata = UIImagePNGRepresentation(photo.image);
                NSData *pdata = UIImagePNGRepresentation(photo.backImage);
                [_dataBase executeUpdate:sql,photo.ind,photo.year, photo.type, photo.bod,photo.color, fdata,pdata,photo.pinkuan,photo.price,photo.designor];
//               
            }
            
        }
        @catch (NSException *exception) {
            [_dataBase rollback];
        }
        @finally {
            [_dataBase commit];
        }
    }
}
-(void)update:(ClothPhoto *)cloth{
    NSString *sql =@"update photoList set ind = ?, year = ?, type = ?, bod = ?, color = ?, image = ?, backImage = ?, pinkuan = ?, price = ?, designor = ? where ind = ?";
    NSData *fdata = UIImagePNGRepresentation(cloth.image);
    NSData *pdata = UIImagePNGRepresentation(cloth.backImage);
    BOOL isSuccess = [_dataBase executeUpdate:sql,cloth.ind,cloth.year,cloth.type,cloth.bod,cloth.color,fdata,pdata,cloth.pinkuan,cloth.price,cloth.designor,cloth.ind];
    if (!isSuccess) {
        NSLog(@"修改数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"修改数据成功");
    }
}
-(BOOL)isExistAppForImage:(UIImage *)anImage{
    NSString *sql = @"select * from photoList where image = ?";
    NSData *data = UIImagePNGRepresentation(anImage);
    FMResultSet *set = [_dataBase executeQuery:sql,data];
    if ([set next]) {
        return YES;
    }else{
        return NO;
    }
}
-(NSMutableArray *)fetchAll{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from photoList";
    FMResultSet *set = [_dataBase executeQuery:sql];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
        [mutArray addObject:cloth];
    }
    [set close];
    return mutArray;
}
-(ClothPhoto *)fetchByInd:(NSString *)ind{
    ClothPhoto *cloth = [[ClothPhoto alloc]init];
     NSString *sql = @"select * from photoList where ind = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,ind];
    while (set.next) {
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
    }
    [set close];
    return cloth;
}
-(NSMutableArray *)fetchBySession:(NSString *)session{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from photoList where year = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
        [mutArray addObject:cloth];
    }
    [set close];
    return mutArray;
}
//按返回的年份查询，波段显示数据
-(NSMutableArray *)fetchBySession:(NSString *)session bods:(NSString *)bods{
    NSMutableArray *mltArray = [NSMutableArray array];
    NSString *sql = @"select * from photoList where year = ? and bod = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,bods];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
        [mltArray addObject:cloth];
    }
    [set close];
    return mltArray;
}
//按返回的年份  品类显示数据
-(NSMutableArray *)fetchBySession:(NSString *)session andType:(NSString *)type{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"select * from photoList where year = ? and type = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,type];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
        [array addObject:cloth];
    }
    [set close];
    return array;
}
//按品类
/**
-(NSMutableArray *)fetchBySession:(NSString *)session andBod:(NSString *)bod andType:(NSString *)type{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"select * from photoList where year = ? and type = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,type];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
        [array addObject:cloth];
    }
    [set close];
    return array;
}
 */
//返回某个季度的所有色系
-(NSArray *)allColorBySession:(NSString *)year{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from photoList";
    FMResultSet *set = [_dataBase executeQuery:sql];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.color = [set stringForColumn:@"color"];
        NSString *color = [NSString stringWithString:cloth.color];
        [mutArray addObject:color];
    }
    [set close];
    NSArray *arr = [NSArray arrayWithArray:mutArray];
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    for (NSString *str in arr) {
        [diction setObject:str forKey:str];
    }
    arr = [diction allValues];//返回所有的色系
    return arr;
}
//按色系
-(NSMutableArray *)fetchBySession:(NSString *)session andColor:(NSString *)color{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"select * from photoList where year = ? and color = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,color];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
        [array addObject:cloth];
    }
    [set close];
    return array;
}
-(NSMutableArray *)fetchBySession:(NSString *)session andDesignor:(NSString *)designor{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"select * from photoList where year = ? and designor = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,designor];
    while (set.next) {
        ClothPhoto *cloth = [[ClothPhoto alloc]init];
        cloth.ind = [set stringForColumn:@"ind"];
        cloth.year = [set stringForColumn:@"year"];
        cloth.type = [set stringForColumn:@"type"];
        cloth.bod = [set stringForColumn:@"bod"];
        cloth.color = [set stringForColumn:@"color"];
        cloth.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        cloth.backImage = [UIImage imageWithData:[set dataForColumn:@"backImage"]];
        cloth.pinkuan = [set stringForColumn:@"pinkuan"];
        cloth.price = [set stringForColumn:@"price"];
        cloth.designor = [set stringForColumn:@"designor"];
        [array addObject:cloth];
    }
    [set close];
    return array;
}
@end
