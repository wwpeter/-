//
//  DBManager.h
//  好品
//
//  Created by 朱明科 on 15/12/14.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Combin.h"
@interface DBManager : NSObject

+(instancetype)sharedInstance;
- (void)addCombin:(Combin *)combin;
-(void)deleteByDetailTimer:(NSString *)detail;
-(void)deleteByYear:(NSString *)year;
- (NSMutableArray *)fetchByYear:(NSString *)yearStr;
-(void)update:(Combin *)ktModel;
-(Combin *)fetchByDetail:(NSString *)combinDetail;
@end
