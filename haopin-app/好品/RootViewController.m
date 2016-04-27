//
//  RootViewController.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "RootViewController.h"
#import "UIViewController+util.h"
#import "KTbookController.h"
#import "SeeCombinationController.h"
#import "SeeBoardViewController.h"
#import "SeeGoodsController.h"
#import "SettingsController.h"
#import "NewKTController.h"

#define kSize CGRectMake(6, (self.view.frame.size.width - 80) / 2.0, 80, 32)

@interface RootViewController ()
@property(nonatomic)NSUserDefaults *userDeft;
@end

@implementation RootViewController{
    UIImageView *navBarHairlineImageView;
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self setControllers];
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
-(void)setControllers{
    self.tabBar.tintColor = [UIColor colorWithRed:78.0/255 green:206.0/255 blue:96.0/255 alpha:1.0];
//    KTbookController *ktbookController = [KTbookController viewControllerWithTabTitle:@"KT板" image:[UIImage imageNamed:@"kt"] selectedImage:[UIImage imageNamed:@"kt-selection"]];//kt-selection
//    [ktbookController setTitleView:@"KT板" frame:kSize];
//    UINavigationController *ktNavController = [[UINavigationController alloc]initWithRootViewController:ktbookController];
    
    NewKTController *newKtController = [NewKTController viewControllerWithTabTitle:@"KT板" image:[UIImage imageNamed:@"kt"] selectedImage:[UIImage imageNamed:@"kt-selection"]];
    [newKtController setTitleView:@"KT板" frame:kSize];
    UINavigationController *newKtNavController = [[UINavigationController alloc]initWithRootViewController:newKtController];
    
    SeeCombinationController *seeCombibationController = [SeeCombinationController viewControllerWithTabTitle:@"看组合" image:[UIImage imageNamed:@"combined"] selectedImage:[UIImage imageNamed:@"combined-selection"]];
    [seeCombibationController setTitleView:@"看组合" frame:kSize];
    UINavigationController *seeCombNavController = [[UINavigationController alloc]initWithRootViewController:seeCombibationController];
    
    SeeBoardViewController *seeBoardController = [SeeBoardViewController viewControllerWithTabTitle:@"看板墙" image:[UIImage imageNamed:@"boards"] selectedImage:[UIImage imageNamed:@"boards-selection"]];
    [seeBoardController setTitleView:@"看板墙" frame:kSize];
    UINavigationController *seeBoardNavController = [[UINavigationController alloc]initWithRootViewController:seeBoardController];
    
    SeeGoodsController *seeGoodsController = [SeeGoodsController viewControllerWithTabTitle:@"好样" image:[UIImage imageNamed:@"goods"] selectedImage:[UIImage imageNamed:@"goods-selection"]];
    [seeGoodsController setTitleView:@"好样" frame:kSize];
    UINavigationController *seeGoodsNavController = [[UINavigationController alloc]initWithRootViewController:seeGoodsController];
        
    SettingsController *settingsController = [SettingsController viewControllerWithTabTitle:@"设置" image:[UIImage imageNamed:@"set-up"] selectedImage:[UIImage imageNamed:@"set-selection"]];
    [settingsController  setTitleView:@"设置" frame:kSize];
    UINavigationController *settingsNavController = [[UINavigationController alloc]initWithRootViewController:settingsController];

    self.viewControllers = @[seeGoodsNavController,newKtNavController,seeBoardNavController,seeCombNavController,settingsNavController];
    self.tabBar.translucent = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}
@end
