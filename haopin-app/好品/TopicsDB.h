//
//  TopicsDB.h
//  haopin
//
//  Created by 朱明科 on 16/3/18.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicsModel.h"
@interface TopicsDB : NSObject
+(instancetype)sharedInstance;
- (void)addDetailModel:(TopicsModel *)model;
-(NSMutableArray *)fetchKTByYear:(NSString *)year andDate:(NSString *)date;
-(void)update:(TopicsModel *)model;
-(void)deleteByTag:(NSString *)tag;
-(void)deleteBySession:(NSString *)session;
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date;
@end
