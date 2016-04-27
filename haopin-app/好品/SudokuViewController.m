//
//  SudokuViewController.m
//  SudokuDemo
//
//  Created by Yorke on 15/3/11.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import "SudokuViewController.h"
#import "WTSudokuView.h"
#import "KeychainItemWrapper.h"
#import "RootViewController.h"
#import "LoginController.h"

@interface SudokuViewController ()<WTTouchSettingDelegate,WTTouchVerifyDelegate>

@property (nonatomic, strong) WTSudokuView *sudokuview;

@property (nonatomic, copy) NSString *tempPassword;

@property (nonatomic, assign) NSInteger repeatTime;

@end

@implementation SudokuViewController

@synthesize sudokuview;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    _tempPassword = @"";
    _repeatTime = 5;
    if(_type == WTSudokuViewTypeSetting){
        if([[self keychainPassword] isEqualToString:@""]){
            [self setting];
        }else{
            [self resetting];
        }
    }else{
        if([[self keychainPassword] isEqualToString:@""]){
//            NSLog(@"未设置手势密码");
            
        }else{
            [self verity];
        }
        
    }
}

- (void)setting{
     sudokuview = [[WTSudokuView alloc]initWithFrame:self.view.bounds];
    [sudokuview.touchView setType:WTTouchViewTypeSetting];
    sudokuview.touchView.settingDelegate = self;
    [sudokuview showTitle:@"设置您的手势密码"];
    [self.view addSubview:sudokuview];
}

- (void)resetting{
    sudokuview = [[WTSudokuView alloc]initWithFrame:self.view.bounds];
    [sudokuview.touchView setType:WTTouchViewTypeVerify];
    sudokuview.touchView.verifyDelegate = self;
    [sudokuview showTitle:@"验证您的手势密码"];
    [self.view addSubview:sudokuview];
}

- (void)verity{
    sudokuview = [[WTSudokuView alloc]initWithFrame:self.view.bounds];
    [sudokuview.touchView setType:WTTouchViewTypeVerify];
    sudokuview.touchView.verifyDelegate = self;
    [sudokuview showTitle:@"输入您的手势密码"];
    [self.view addSubview:sudokuview];
}

- (BOOL)settingPassword:(NSString *)password{
    if([_tempPassword isEqualToString:@""]){
        _tempPassword = password;
        [sudokuview showTitle: @"确认您的手势密码"];
    }else {
        if([_tempPassword isEqualToString:password]){
            [sudokuview showTitle:@"手势密码设置成功"];
             [self saveKeychainPassword:password];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGesture];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [sudokuview showTitle:@"与上次绘制不一致，请重新绘制"];
            return NO;
        }
    }
    return YES;
}

- (BOOL)verifyPassword:(NSString *)password{
    if([[self keychainPassword] isEqualToString:password]){
        if(_type == WTSudokuViewTypeSetting){
            [sudokuview showTitle:@"设置新的手势密码"];
            [sudokuview.touchView setType:WTTouchViewTypeSetting];
            sudokuview.touchView.verifyDelegate = nil;
            sudokuview.touchView.settingDelegate = self;
            [self clearKeychainPassword];
        }else{
            [sudokuview showTitle:@"验证成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[self dismissViewControllerAnimated:YES completion:nil];
                //密码对了就转到rootviewcontroller
//                CATransition *animation = [CATransition animation];
//                animation.delegate = self;
//                animation.duration = 0.7;
//                animation.timingFunction = UIViewAnimationCurveEaseInOut;
//                animation.type = @"cameraIrisHollowOpen";
//                [self.view.layer addAnimation:animation forKey:@"animation"];
                [self performSelector:@selector(prenstViewController) withObject:nil afterDelay:0];
            });
        }
    }else {
        _repeatTime--;
        if(_repeatTime > 0)
            [sudokuview showTitle:[NSString stringWithFormat:@"密码错误，还可以再输入%ld次",(long)_repeatTime]];
        else{
            [sudokuview showTitle:@"确定您是机主？程序即将自动关闭！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                abort();
            });
        }
        return NO;
    }
    return YES;
}
//跳转到rootviewcontroller
-(void)prenstViewController
{
//    RootViewController *root = [[RootViewController alloc]init];
//    [self presentViewController:root animated:NO completion:nil];
    LoginController *controller = [[LoginController alloc] init];
    UINavigationController *niv = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:niv animated:YES completion:^{
        
    }];
}
- (NSString *)keychainPassword{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    return [keychain objectForKey:(__bridge id)kSecValueData];
}

- (BOOL)saveKeychainPassword:(NSString *)password{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
    [keychin setObject:password forKey:(__bridge id)kSecValueData];
    return YES;
}

- (void)clearKeychainPassword{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}
@end
