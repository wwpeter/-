//
//  ActivationController.m
//  haopin
//
//  Created by ww on 16/4/7.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ActivationController.h"
#import "LoginController.h"
#import "ModifyViewController.h"

@interface ActivationController ()

@end

@implementation ActivationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLine];
    [self addUI];
}
- (void)addLine {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width-300, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 98, self.view.frame.size.width-300, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView2];
    //修改密码
    UILabel *modify = [[UILabel alloc] initWithFrame:CGRectMake(5, 58, self.view.frame.size.width - 300, 35)];
    modify.text = @"修改密码";
    modify.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:modify];
    //
    UIImageView *modifyView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 350, 63, 20, 20)];
    modifyView.image = [UIImage imageNamed:@"shape-10.png"];
    [self.view addSubview:modifyView];
}
- (void)addUI {
    UILabel *guoqiLabel = [[UILabel alloc] init];
    NSUserDefaults *userDefeult = [NSUserDefaults standardUserDefaults];
    guoqiLabel.text = [NSString stringWithFormat:@"有效期间: %@ 到 %@",[userDefeult objectForKey:@"jihuoriqi"],[userDefeult objectForKey:@"guoqi"]];
    guoqiLabel.frame = CGRectMake(5, 5, self.view.frame.size.width, 40);
    guoqiLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    guoqiLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:guoqiLabel];
    
    UIButton *jihuoBut = [UIButton buttonWithType:UIButtonTypeSystem];
    jihuoBut.frame = CGRectMake(620, 8, 100, 30);
    jihuoBut.backgroundColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0];
    jihuoBut.layer.cornerRadius = 8;
    [jihuoBut setTitle:@"再次授权" forState:UIControlStateNormal];
    [jihuoBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jihuoBut addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jihuoBut];
    //修改密码
    UIButton *modifyBut = [UIButton buttonWithType:UIButtonTypeSystem];
    modifyBut.frame = CGRectMake(5, 50, self.view.frame.size.width-300, 40);
    modifyBut.backgroundColor = [UIColor clearColor];
    modifyBut.layer.cornerRadius = 8;
    [modifyBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modifyBut addTarget:self action:@selector(modify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBut];
}
- (void)modify:(UIButton *)button {
    ModifyViewController *controller = [[ModifyViewController alloc] init];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)click:(UIButton *)button {
    LoginController *controller = [[LoginController alloc] init];
    controller.jiHuo = YES;
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
