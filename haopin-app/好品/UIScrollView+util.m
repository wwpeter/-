//
//  UIScrollView+util.m
//  好品
//
//  Created by 朱明科 on 16/1/7.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "UIScrollView+util.h"

@implementation UIScrollView (util)
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end
