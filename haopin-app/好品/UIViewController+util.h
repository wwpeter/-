//
//  UIViewController+util.h
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//
//2.2
#import <UIKit/UIKit.h>

@interface UIViewController (util)
+ (instancetype)viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image selectedImage:(UIImage *)selectedImage;
- (void)setTitleView:(NSString *)title frame:(CGRect)frame;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (BOOL)shouldAutorotate;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;

//增加alert
+ (void)addAlert:(NSString *)title action1:(NSString *)act1 action2:(NSString *)act2;
@end
