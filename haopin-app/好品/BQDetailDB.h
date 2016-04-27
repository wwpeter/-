//
//  BQDetailDB.h
//  haopin
//
//  Created by 朱明科 on 16/3/3.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQDetailModel.h"
@interface BQDetailDB : NSObject
+(instancetype)sharedInstance;
- (void)addDetailModel:(BQDetailModel *)detailModel;
-(void)deleteByDetailTag:(NSString *)detailTag;//删除某一个
- (NSMutableArray *)fetchBySession:(NSString *)session bod:(NSString *)bod;
-(void)update:(BQDetailModel *)detail;
-(void)deleteBySession:(NSString *)session andBond:(NSString *)bod;//删除年份+波段的信息
-(void)deleteBySession:(NSString *)session;
-(NSMutableArray *)fetchByVVID:(NSString *)vvid;
-(void)deleteByVVID:(NSString *)vvid;
@end
