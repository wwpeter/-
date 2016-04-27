//
//  KuZiDB.h
//  haopin
//
//  Created by ww on 16/3/25.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KuZiModel.h"

@interface KuZiDB : NSObject
+(instancetype)sharedInstance;
- (void)addDetailModel:(KuZiModel *)ktModel;
-(NSMutableArray *)fetchKTBySession:(NSString *)session andDate:(NSString *)date;//根据年份+上货周期返回货品
-(NSInteger)numBySession:(NSString *)session andDate:(NSString *)date;
-(NSMutableArray *)fetchKTBySession:(NSString *)session ;//根据年份+上货周期返回货品
-(void)deleteBySession:(NSString *)session;
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date;//年份加周期

@end
