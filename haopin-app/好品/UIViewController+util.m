//
//  UIViewController+util.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "UIViewController+util.h"
#import "UIImage+util.h"

@implementation UIViewController (util)
+ (instancetype)viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image selectedImage:(UIImage *)selectedImage{
    CGSize size = CGSizeMake(30, 30);
    UIImage *newImage = [image scaleToSize:image size:size];
    UIImage *newSelectedImage = [selectedImage scaleToSize:selectedImage size:size];
    UIViewController *controller = [[[self class] alloc] init];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:newImage selectedImage:newSelectedImage];
     //UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:newImage selectedImage:[newSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    controller.tabBarItem = item;
    return controller;

}
- (void)setTitleView:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    //label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    label.font = [UIFont systemFontOfSize:20];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    self.navigationItem.titleView = label;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)addAlert:(NSString *)title action1:(NSString *)act1 action2:(NSString *)act2 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *queding = [UIAlertAction actionWithTitle:act1 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *isOK = [UIAlertAction actionWithTitle:act2 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:queding];
    [alert addAction:isOK];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
