//
//  KTDBManager.h
//  好品
//
//  Created by 朱明科 on 15/12/29.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTModel.h"

@interface KTDBManager : NSObject
+(instancetype)sharedInstance;
- (void)addKTModel:(KTModel *)ktModel;
-(void)deleteByKtDetail:(NSString *)ktDetail;//按年份+波段删除唯一指定KT板
- (NSMutableArray *)fetchAll;
-(NSMutableArray *)fetchBySession:(NSString *)session bod:(NSString *)bod;
-(void)update:(KTModel *)ktModel;
-(void)deleteBySession:(NSString *)session;//按具体年份删除
@end
