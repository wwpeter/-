//
//  FindViewController.m
//  haopin
//
//  Created by ww on 16/4/13.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ModifyViewController.h"
#import "Urlutil.h"
#import "NSString+Util.h"
#import "AFNetworking.h"

@interface ModifyViewController() <UITextFieldDelegate>
@property (nonatomic) UITextField *number;
@property (nonatomic) UITextField *password1;
@property (nonatomic) UITextField *password2;
@property (nonatomic) UIButton *huoqu;
@property (nonatomic) BOOL countdowning;
@property (nonatomic) UIImageView *error1;
@property (nonatomic) UIImageView *error3;
@property (nonatomic) UIImageView *error4;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBack];
    [self createUI];
}
- (void)createUI {
    //找回密码
    UILabel *mimaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, 20, 120, 50)];
    mimaLabel.text = @"修改密码";
    mimaLabel.font = [UIFont systemFontOfSize:20];
    mimaLabel.textAlignment = NSTextAlignmentCenter;
    mimaLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    CGFloat width = self.view.frame.size.width;
    //手机号
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 69, 100, 40)];
    [numberLabel setText:@"手机号:"];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    numberLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:numberLabel];
    _number = [[UITextField alloc] initWithFrame:CGRectMake(85, 69, 870, 40)];
    _number.layer.borderWidth = 0;
    _number.delegate = self;
    _number.tag = 1000;
    _number.keyboardType = UIKeyboardTypeNumberPad;
    _number.placeholder = @" 请输入手机号";
    _number.font = [UIFont systemFontOfSize:15];
    _number.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _number.clearButtonMode = UITextFieldViewModeWhileEditing;
   // _number.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    [self.view addSubview:_number];
    //线条
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView1];
    //密码
    UILabel *pass = [[UILabel alloc] initWithFrame:CGRectMake(30, 119, 100, 40)];
    [pass setText:@"原密码:"];
    pass.textAlignment = NSTextAlignmentLeft;
    pass.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    pass.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:pass];
    _password1 = [[UITextField alloc] initWithFrame:CGRectMake(85, 119, 870, 40)];
    _password1.layer.borderWidth = 0;
    _password1.placeholder = @" 大于等于6位";
    _password1.clearButtonMode = UITextFieldViewModeWhileEditing;
  //  _password1.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    _password1.tag = 1002;
    _password1.delegate = self;
    _password1.secureTextEntry = YES;
    _password1.font = [UIFont systemFontOfSize:15];
    _password1.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:_password1];
    //线条
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(25, 114, self.view.frame.size.width-25, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView2];
    //确认密码
    UILabel *pass2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 169, 100, 40)];
    [pass2 setText:@"新密码:"];
    pass2.textAlignment = NSTextAlignmentLeft;
    pass2.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    pass2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:pass2];
    _password2 = [[UITextField alloc] initWithFrame:CGRectMake(85, 169, 870, 40)];
    _password2.layer.borderWidth = 0;
    _password2.placeholder = @" 大于等于6位";
    _password2.clearButtonMode = UITextFieldViewModeWhileEditing;
   // _password2.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    _password2.tag = 1003;
    _password2.delegate =self;
    _password2.secureTextEntry = YES;
    _password2.font = [UIFont systemFontOfSize:15];
    _password2.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:_password2];
    //线条
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(25, 164, self.view.frame.size.width-25, 1)];
    lineView3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView3];
    //确认
    UIButton *queren = [UIButton buttonWithType:UIButtonTypeSystem];
    [queren setTitle:@"确   定" forState:UIControlStateNormal];
    queren.frame = CGRectMake(10, 234, width -20, 40);
    queren.layer.cornerRadius = 8;
    [queren addTarget:self action:@selector(postData:) forControlEvents:UIControlEventTouchUpInside];
    queren.titleLabel.font = [UIFont systemFontOfSize:17];
    [queren setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    queren.backgroundColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0];
    [self.view addSubview:queren];
    //线条
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 214, self.view.frame.size.width, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView5];
    
    [self.view addSubview:mimaLabel];
}
- (void)createBack {
    UIButton *backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(5, 20, 60, 44);
//    [backBut setTitle:@"返回" forState:UIControlStateNormal];
    [backBut setImage:[UIImage imageNamed:@"HY_cuowu_image.png"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //backBut.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:backBut];
}
- (void)back:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - 确定按钮
- (void)postData:(UIButton *)button {
    [self.view endEditing:YES];
    if (_number.text.length == 0||_password1.text.length == 0||_password2.text.length== 0) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"有模块为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *quding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:quding];
        [self presentViewController:controller animated:YES completion:^{
        }];
    } else {
        if (_error1||_error3||_error4) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请修改错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *quding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:quding];
            [self presentViewController:controller animated:YES completion:^{
            }];
        } else {
            NSArray *signArr = [NSArray arrayWithObjects:_number.text,_password2.text,_password1.text, nil];
            NSMutableString *str= (NSMutableString *)[NSString signString:signArr];
            
            NSString *strSign = @"QvyBR6hvf9Z8bzqGVWF3t8b6H9IK2DQm";
            [str appendString:strSign];
            NSDictionary *dict = @{@"mobile" : _number.text, @"password" : _password1.text, @"newpassword" : _password2.text, @"sign" : [str md5]};//@"sign" : [str md5]
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"]; // 配置content-type
            [manager POST:Modify parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"info"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
                if ([responseObject[@"info"] isEqualToString:@"成功啦"]) {
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    [userDef setObject:_password2.text forKey:@"password"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                NSLog(@"%@",responseObject[@"info"]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }
}
-(void)timer:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [self dismissViewControllerAnimated:alert completion:nil];
    [timer invalidate];
}
#pragma mark - textField Delegate
- (void)textFieldDidEndEditing:(UITextField*)textField {
        CGFloat width = self.view.frame.size.width - 50;
    if (textField.tag == 1000) {
        BOOL numBOOL =  [_number.text isValidPhoneNumber];
        
        if (!numBOOL) {
            if (!_error1) {
                _error1 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 79, 20, 20)];
                _error1.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                [self.view addSubview:_error1];
            }
        }else {
            [_error1 removeFromSuperview];
            _error1 = nil;
        }
    }else if (textField.tag == 1002) {
        if (_password1.text.length<=5) {
            if (!_error4) {
                _error4 = [[UIImageView alloc] initWithFrame:CGRectMake(width,129, 20, 20)];
                _error4.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                [self.view addSubview:_error4];
            }
        }else {
            [_error4 removeFromSuperview];
            _error4 = nil;
        }
    }else if (textField.tag == 1003) {
        if (_password2.text.length<=5) {
            if (!_error3) {
                _error3 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 179, 20, 20)];
                _error3.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                [self.view addSubview:_error3];
            }
        }else {
            [_error3 removeFromSuperview];
            _error3 = nil;
        }
    }else {
        
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
