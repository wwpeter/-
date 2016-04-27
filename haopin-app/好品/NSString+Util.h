//
//  NSString+Util.h
//  1_NSPredicateDemo
//
//  Created by ww on 15/9/22.
//  Copyright (c) 2015年 王威 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

// 正则运用之判断一个字符串中是否只含有英文字母数字下划线[a-zA-Z0-9_]
- (BOOL)isValidVar;

// 判断是否是合法的 email
- (BOOL)isValidEmail;
// 判断是不是手机号
- (BOOL)isValidPhoneNumber;

// 签名
+ (NSString *)signString:(NSArray*)array;
- (NSString *) md5;
@end




