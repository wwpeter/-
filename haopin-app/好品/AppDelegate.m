//
//  AppDelegate.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "SudokuViewController.h"
#import "KeychainItemWrapper.h"
#import "DataBase.h"
#import "LoginController.h"

@interface AppDelegate ()
@property(nonatomic)NSUserDefaults *userDeft;
@property (nonatomic) BOOL hah;
@end

@implementation AppDelegate

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [NSThread sleepForTimeInterval:1.0];//启动页页停留时间
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //登录页面
  self.userDeft = [NSUserDefaults standardUserDefaults];
    NSString *str = [_userDeft objectForKey:@"Legitimacy"];
    NSInteger daoqiDay = (NSInteger)[str integerValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSInteger newDay = (NSInteger)[date integerValue];
    
    if (str || newDay>daoqiDay) {//str == nil || newDay>daoqiDay
        self.userDeft = [NSUserDefaults standardUserDefaults];
        BOOL isTurnOn = [_userDeft boolForKey:@"isTurnOn"];
        BOOL gestureBool = [_userDeft boolForKey:@"Gesture"];
        if (gestureBool == NO) {
            isTurnOn = NO;
        }
        if (isTurnOn == YES) {//如果设置了密码
            SudokuViewController *vc = [[SudokuViewController alloc]init];
            self.window.rootViewController = vc;
        }else{//如果没有设置密码
            NSLog(@"没有设置手势密码");
            [self initData];
            LoginController *controller = [[LoginController alloc] init];
            UINavigationController *niv = [[UINavigationController alloc] initWithRootViewController:controller];
            if (newDay > daoqiDay&& daoqiDay) {
                controller.guoqi = YES;
            }
             self.window.rootViewController = niv;
        }
    }else
    {
        self.userDeft = [NSUserDefaults standardUserDefaults];
        BOOL isTurnOn = [_userDeft boolForKey:@"isTurnOn"];
        BOOL gestureBool = [_userDeft boolForKey:@"Gesture"];
        if (gestureBool == NO) {
            isTurnOn = NO;
        }
        if (isTurnOn == YES) {//如果设置了密码
            SudokuViewController *vc = [[SudokuViewController alloc]init];
            self.window.rootViewController = vc;
        }else{//如果没有设置密码
            NSLog(@"没有设置手势密码");
            RootViewController *rootController = [[RootViewController alloc]init];
            self.window.rootViewController = rootController;
        }
        [self initData];
   }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initData{
    BOOL firstOpen = [_userDeft boolForKey:@"firstOpen"];
    if (firstOpen == NO) {
        NSString *string = [[NSString alloc]init];
        NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"HpPlist" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
        NSArray *arr = [[array reverseObjectEnumerator] allObjects];
        for (NSDictionary *dict in arr) {
            ClothPhoto *photo = [[ClothPhoto alloc]init];
            photo.ind = dict[@"ind"];
            photo.year = dict[@"year"];
            string = photo.year;
            photo.type = dict[@"type"];
            photo.bod = dict[@"bod"];
            photo.color = @"打样";
            photo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dict[@"image"]]];
            photo.backImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dict[@"backImage"]]];
            photo.pinkuan = dict[@"pinkuan"];
            photo.price = dict[@"price"];
            photo.designor = dict[@"designor"];
            [[DataBase shareInstance]insertCloth:photo];
        }
        NSArray *yearArr = [NSArray arrayWithObjects:@"2016年夏季女装", nil];
        [_userDeft setObject:yearArr forKey:@"yearARR"];
        NSArray *bodArr = [NSArray arrayWithObjects:@[@"第一波段",@"3月01",@"4月07"],@[@"第二波段",@"6月28",@"7月03"],@[@"第三波段",@"7月07",@"7月14"], nil];
        [_userDeft setObject:bodArr forKey:string];
        NSArray *typeArr = [NSArray arrayWithObjects:@"上装",@"下装",@"内搭",@"套装",@"配饰", nil];
        [_userDeft setObject:typeArr forKey:[NSString stringWithFormat:@"%@type",string]];
        NSArray *designorArr = [NSArray arrayWithObjects:@"小美",@"小陈",@"小张", nil];
        [_userDeft setObject:designorArr forKey:[NSString stringWithFormat:@"%@design",string]];
        [_userDeft synchronize];
    }
    [_userDeft setBool:YES forKey:@"firstOpen"];
    [_userDeft synchronize];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(timer:) userInfo:nil repeats:NO];
    NSLog(@"进入后台");
}
-(void)timer:(NSTimer *)timer{
    self.hah = YES;
    [timer invalidate];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"进入前台");
    if (self.hah == YES) {
        NSLog(@"我要重新启动登录");
        LoginController *login = [[LoginController alloc]init];
        UINavigationController *niv = [[UINavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = niv;
    }
    self.hah = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
