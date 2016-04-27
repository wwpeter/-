//
//  UILabel+util.m
//  haopin
//
//  Created by 朱明科 on 16/4/12.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "UILabel+util.h"
#import "objc/runtime.h"
static const void *UUTagKey = &UUTagKey;
@implementation UILabel (util)
-(NSString *)UUTag{
    return objc_getAssociatedObject(self, UUTagKey);
}
-(void)setUUTag:(NSString *)UUTag{
    objc_setAssociatedObject(self, UUTagKey, UUTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
