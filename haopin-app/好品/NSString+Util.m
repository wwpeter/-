//
//  NSString+Util.m
//  1_NSPredicateDemo
//
//  Created by ww on 15/9/22.
//  Copyright (c) 2015年 王威 All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)

+ (NSString *)signString:(NSArray*)array
{
    NSArray *newarr = [array sortedArrayUsingFunction:nickNameSort context:NULL];
   
    NSString *str = [newarr componentsJoinedByString:@""];
   // NSString *sign = [NSString stringWithFormat:@"%@%@%@",@"52163728",str,@"c4ca4238a0b923820dcc509a6f75849b"];
    str = [str lowercaseString];
    
    return str;
}
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
/************** A,B,C,D排序 ************************/
NSInteger nickNameSort(id user1, id user2, void *context)
{
    NSString *u1,*u2;
    //类型转换
    u1 = (NSString*)user1;
    u2 = (NSString*)user2;
    return  [u1 localizedCompare:u2];
}

- (BOOL)isValidVar {
    NSString *regex = @"[a-zA-Z_]+[a-zA-Z0-9_]*"; // +是一次或多次，*是0次或多次, []是字符集合
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // evaluateWithObject: 用正则评估字符串是否符合它
    return [predicate evaluateWithObject:self]; // self就是一个字符串，这句代码用predicate评估（判断）字符串本身符不符合要求
    
    // return [self evaluateWithRegex:@"[a-zA-Z_]+[a-zA-Z0-9_]*"];
}

- (BOOL)isValidEmail {
    /**
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
     */
    return [self evaluateWithRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}"];
}

- (BOOL)isValidPhoneNumber {//^[1][3-8]+\\d{9}
    return [self evaluateWithRegex:@"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"];//
}

- (BOOL)evaluateWithRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
