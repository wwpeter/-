//
//  NewKTDB.h
//  haopin
//
//  Created by 朱明科 on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NewKTModel.h"

@interface NewKTDB : NSObject

+(instancetype)sharedInstance;
- (void)addDetailModel:(NewKTModel *)ktModel;
-(NSMutableArray *)fetchKTBySession:(NSString *)session andDate:(NSString *)date;//根据年份+上货周期返回货品
-(NSInteger)numBySession:(NSString *)session andDate:(NSString *)date;
-(NSMutableArray *)fetchKTBySession:(NSString *)session ;//根据年份+上货周期返回货品
-(void)deleteBySession:(NSString *)session;
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date;
@end
