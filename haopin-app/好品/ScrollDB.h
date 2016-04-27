//
//  ScrollDB.h
//  haopin
//
//  Created by ww on 16/3/29.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ScrollModel.h"

@interface ScrollDB : NSObject

@property(nonatomic)FMDatabase *dataBase;
+(instancetype)sharedInstance;
- (void)addDetailModel:(ScrollModel *)model;
-(ScrollModel *)fetchByYear:(NSString *)year andDate:(NSString *)date andType:(NSString *)type;
-(void)update:(ScrollModel *)model;
-(void)deleteByTag:(NSString *)tag;
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date;//根据年份+周期
-(void)deleteBySession:(NSString *)session;
@end
