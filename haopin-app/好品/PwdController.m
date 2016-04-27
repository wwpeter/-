//
//  PwdController.m
//  好品
//
//  Created by 朱明科 on 15/12/16.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "PwdController.h"
#import "SudokuViewController.h"
#import "KeychainItemWrapper.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface PwdController ()
@property(nonatomic)UISwitch *switchBtn;
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UIButton *changeButton;

@property(nonatomic)SudokuViewController *sudoController;
@end

@implementation PwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self createUI];
}

-(SudokuViewController *)sudoController{
    if (_sudoController == nil) {
        _sudoController = [[SudokuViewController alloc]init];
        _sudoController.view.frame = self.view.bounds;
        _sudoController.type = WTSudokuViewTypeSetting;
    }
    return _sudoController;
}

-(void)createUI{
    UIColor *tyColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    BOOL isTurnOn = [_userDeft boolForKey:@"isTurnOn"];
    BOOL xxx = [_userDeft boolForKey:@"Gesture"];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 723, 44)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"手势密码";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = tyColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(1, 44, 723, 1)];
    lines.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self.view addSubview:lines];
    //密码开关
    UIView *pwdView = [[UIView alloc]initWithFrame:CGRectMake(1, 45, 723, 50)];
    pwdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pwdView];
    UILabel *pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 40)];
    pwdLabel.text = @"手势密码";
    pwdLabel.textColor = tyColor;
    pwdLabel.font = [UIFont systemFontOfSize:16];
    pwdLabel.textAlignment = NSTextAlignmentLeft;
    [pwdView addSubview:pwdLabel];
    self.switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(650, 7, 51, 31)];
    [_switchBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    [pwdView addSubview:_switchBtn];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(1, 92, 723, 1)];
    line2.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    [self.view addSubview:line2];
    
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(1, 93, 723, 560)];
    tmpView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tmpView];
    //修改
    self.changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _changeButton.frame = CGRectMake(-1, -1, 726, 50);
    [_changeButton setTitle:@"修改手势密码" forState:UIControlStateNormal];
    _changeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _changeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _changeButton.backgroundColor = [UIColor whiteColor];
    _changeButton.layer.borderWidth = 1.0;
    _changeButton.layer.borderColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0].CGColor;
    [_changeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_changeButton setTitleColor:tyColor forState:UIControlStateNormal];
    [_changeButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    //本地存储判断
    if (isTurnOn == YES && xxx == YES) {
        _changeButton.hidden = NO;
        _switchBtn.on = YES;
    }else{
        _changeButton.hidden = YES;
        _switchBtn.on = NO;
    }
    [tmpView addSubview:_changeButton];
}
-(void)switchClick:(UISwitch *)switchBtn{
    //本地存储设置
    if (switchBtn.on == YES) {
        _changeButton.hidden = NO;
        [_userDeft setBool:YES forKey:@"isTurnOn"];
        //转换成密码设置界面
        SudokuViewController *sudokuVC = [[SudokuViewController alloc]init];
        sudokuVC.type = WTSudokuViewTypeSetting;
        sudokuVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sudokuVC animated:YES];
    }else{
        _changeButton.hidden = YES;
        [_userDeft setBool:NO forKey:@"isTurnOn"];
        [_userDeft setBool:NO forKey:@"Gesture"];
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
        [keychain resetKeychainItem];//清空密码
    }
    [_userDeft synchronize];
//    if (self.childViewControllers.count == 0) {
//        [self addChildViewController:self.sudoController];
//        [self.view addSubview:_sudoController.view];
//    }
//    self.sudoController.view.hidden = NO;
}
//转换到修改密码页面
-(void)clickBtn:(UIButton *)button{
    SudokuViewController *vc = [[SudokuViewController alloc]init];
    vc.type = WTSudokuViewTypeSetting;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

