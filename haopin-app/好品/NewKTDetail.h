//
//  NewKTDetail.h
//  haopin
//
//  Created by 朱明科 on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewKTDetailModel.h"

@interface NewKTDetail : NSObject//衣架上的东西

+(instancetype)sharedInstance;
- (void)addDetailModel:(NewKTDetailModel *)detailModel;
-(NSMutableArray *)fetchKTByYear:(NSString *)year andDate:(NSString *)date andGan:(NSString *)gan;
-(void)update:(NewKTDetailModel *)detailModel;
-(void)deleteByTag:(NSString *)tag;
-(void)deleteBySession:(NSString *)session;
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date;
@end
