//
//  DataManager.h
//  好品
//
//  Created by 朱明科 on 15/12/28.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bond.h"

@interface DataManager : NSObject
+(instancetype)sharedInstance;
- (void)addBond:(Bond *)bond;
-(void)deleteByDetailTimer:(NSString *)detail;
-(void)deleteByYear:(NSString *)year;
- (NSMutableArray *)fetchByYear:(NSString *)year;
-(void)update:(Bond *)ktModel;
-(Bond *)fetchByDetail:(NSString *)detail;
@end
