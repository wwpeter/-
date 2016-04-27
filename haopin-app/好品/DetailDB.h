//
//  DetailDB.h
//  好品
//
//  Created by 朱明科 on 16/1/4.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailModel.h"

@interface DetailDB : NSObject
+(instancetype)sharedInstance;
- (void)addDetailModel:(DetailModel *)detailModel;
-(void)deleteByDetailTag:(NSString *)detailTag;//删除某一个
- (NSMutableArray *)fetchBySession:(NSString *)session bod:(NSString *)bod;
-(void)update:(DetailModel *)detail;
-(void)deleteBySession:(NSString *)session andBond:(NSString *)bod;//删除年份+波段的信息
-(void)deleteBySession:(NSString *)session;
@end
