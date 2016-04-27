//
//  WQFlower.m
//  XMLDemo
//
//  Created by liuweizhen on 15/9/17.
//  Copyright (c) 2015年 勇敢的心. All rights reserved.
//

#import "WQFlower.h"

@implementation WQFlower

static WQFlower *flower = nil;

+ (WQFlower *)sharedFlower {
    static dispatch_once_t token;
    dispatch_once(&token, ^{ // 这个大括号里面的代码在整个应用程序运行期间，只会被执行一次
        // 让这个对象和屏幕一样大，这样就可以做到不让用户交互
        flower = [[WQFlower alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        flower.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.frame = CGRectMake(0, 0, 100, 100);
        indicatorView.backgroundColor = [UIColor blackColor];
        indicatorView.layer.cornerRadius = 8.0;
        
        indicatorView.center = CGPointMake(flower.frame.size.width/2.0, flower.frame.size.height/2.0); // 居于中间
        [indicatorView startAnimating];
        [flower addSubview:indicatorView];
    });
    return flower;
}

+ (void)show {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 状态栏上网络请求指示符出现
    
    // 加到window上面
    [[[UIApplication sharedApplication] keyWindow] addSubview:[self sharedFlower]];
}

+ (void)dismiss {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 移除掉
    [UIView animateWithDuration:1 animations:^{
        [self sharedFlower].alpha = 0.0;
    } completion:^(BOOL finished) {
        [[self sharedFlower] removeFromSuperview]; // 只是从父视图上移除掉了，内存中还是存在的
    }];
}

@end
