//
//  DataBase.h
//  BasketBall
//
//  Created by zhumingke on 15/10/22.
//  Copyright (c) 2015年 朱明科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClothPhoto.h"
@interface DataBase : NSObject

+ (instancetype)shareInstance;
- (BOOL)isExistAppForImage:(UIImage *)anImage;
- (void)insertCloth:(ClothPhoto *)cloth;
- (void)deleteClothByInd:(NSString *)ind;
- (void)deleteClothByYear:(NSString *)year;
- (void)deleteClothByYear:(NSString *)year andType:(NSString *)type;
- (NSMutableArray *)fetchAll;
- (NSMutableArray *)fetchBySession:(NSString *)session;
//按返回的年份查询，波段显示数据
- (NSMutableArray *)fetchBySession:(NSString *)session bods:(NSString *)bods;
//按品类+年份显示数据
- (NSMutableArray *)fetchBySession:(NSString *)session andType:(NSString *)type;
//筛选
//按品类
//-(NSMutableArray *)fetchBySession:(NSString *)session andBod:(NSString *)bod andType:(NSString *)type;
//按色系
//-(NSMutableArray *)fetchBySession:(NSString *)session andBod:(NSString *)bod andColor:(NSString *)color;
- (NSMutableArray *)fetchBySession:(NSString *)session andColor:(NSString *)color;
- (NSMutableArray *)fetchBySession:(NSString *)session andDesignor:(NSString *)designor;
- (NSArray *)allColorBySession:(NSString *)year;
- (ClothPhoto *)fetchByInd:(NSString *)ind;
//备注
- (void)update:(ClothPhoto *)cloth;
//事务
- (void)insertClothWithArray:(NSArray *)array isTransaction:(BOOL)isTransaction;
@end
