//
//  ZhuTiDB.h
//  haopin
//
//  Created by ww on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ZhuTiModel.h"

@interface ZhuTiDB : NSObject

@property(nonatomic)FMDatabase *dataBase;
+(instancetype)sharedInstance;
- (void)addDetailModel:(ZhuTiModel *)model;
-(ZhuTiModel *)fetchKTByYear:(NSString *)year andDate:(NSString *)date andDetail:(NSString *)detail;
-(void)update:(ZhuTiModel *)model;
-(void)deleteByTag:(NSString *)tag;
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date;//根据年份+周期
-(void)deleteBySession:(NSString *)session;
@end
