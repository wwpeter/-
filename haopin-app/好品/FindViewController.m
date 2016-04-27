//
//  FindViewController.m
//  haopin
//
//  Created by ww on 16/4/13.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "FindViewController.h"
#import "Urlutil.h"
#import "NSString+Util.h"
#import "AFNetworking.h"

@interface FindViewController () <UITextFieldDelegate>
@property (nonatomic) UITextField *nicheng;
@property (nonatomic) UITextField *number;
@property (nonatomic) UITextField *yanzhengma;
@property (nonatomic) UITextField *email;
@property (nonatomic) UITextField *password1;
@property (nonatomic) UITextField *password2;
@property (nonatomic) UIButton *huoqu;
@property (nonatomic) BOOL countdowning;
@property (nonatomic) UIImageView *error1;
@property (nonatomic) UIImageView *error3;
@property (nonatomic) UIImageView *error4;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBack];
    [self createUI];
}
- (void)createUI {
    //找回密码
    UILabel *mimaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, 20, 120, 44)];
    mimaLabel.text = @"找回密码";
    mimaLabel.font = [UIFont systemFontOfSize:20];
    mimaLabel.textAlignment = NSTextAlignmentCenter;
    mimaLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    
     CGFloat width = self.view.frame.size.width;
    //手机号
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 100, 40)];
    [numberLabel setText:@"手机号:"];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    numberLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:numberLabel];
    _number = [[UITextField alloc] initWithFrame:CGRectMake(85, 70, 880, 40)];
    _number.layer.borderWidth = 0;
    _number.font = [UIFont systemFontOfSize:15];
    _number.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    //_number.placeholder = @"请输入手机号";
    _number.delegate = self;
    _number.tag = 1000;
    _number.keyboardType = UIKeyboardTypeNumberPad;
    _number.clearButtonMode = UITextFieldViewModeWhileEditing;
    _number.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    [self.view addSubview:_number];
    //线条
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView1];
    //验证码
    //线条
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(25, 115, self.view.frame.size.width-25, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView2];
    UILabel *yanzhengmaLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 100, 40)];
    [yanzhengmaLabel setText:@"验证码:"];
    yanzhengmaLabel.textAlignment = NSTextAlignmentLeft;
    yanzhengmaLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    yanzhengmaLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:yanzhengmaLabel];
    _yanzhengma = [[UITextField alloc] initWithFrame:CGRectMake(85, 120, 830, 40)];
    _yanzhengma.layer.borderWidth = 0;
    _yanzhengma.font = [UIFont systemFontOfSize:15];
    _yanzhengma.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _yanzhengma.clearButtonMode = UITextFieldViewModeWhileEditing;
    _yanzhengma.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_yanzhengma];
    
    _huoqu = [UIButton buttonWithType:UIButtonTypeCustom];
    _huoqu.frame = CGRectMake(self.view.frame.size.width - 110, 123, 90, 35);
    [_huoqu setTitle:@"获取验证码" forState:UIControlStateNormal];
    //[huoqu setTitleColor:[UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_huoqu addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _huoqu.layer.cornerRadius = 5;
    _huoqu.layer.borderWidth = 0;
    _huoqu.titleLabel.font = [UIFont systemFontOfSize:14];
    _huoqu.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_huoqu];
    [self didLoginButtonChange:NO];
    
    //密码
    UILabel *pass = [[UILabel alloc] initWithFrame:CGRectMake(30, 170, 100, 40)];
    [pass setText:@"密   码:"];
    pass.textAlignment = NSTextAlignmentLeft;
    pass.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    pass.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:pass];
    _password1 = [[UITextField alloc] initWithFrame:CGRectMake(85 ,170, 875, 40)];
    _password1.layer.borderWidth = 0;
    _password1.font = [UIFont systemFontOfSize:15];
    _password1.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _password1.placeholder = @" 大于等于6位";
    _password1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password1.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    _password1.tag = 1010;
    _password1.delegate = self;
    _password1.secureTextEntry = YES;
    [self.view addSubview:_password1];
    //线条
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(25, 165, self.view.frame.size.width-25, 1)];
    lineView3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView3];
    //确认密码
    UILabel *pass2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 100, 40)];
    [pass2 setText:@"确认密码:"];
    pass2.textAlignment = NSTextAlignmentLeft;
    pass2.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    pass2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:pass2];
    _password2 = [[UITextField alloc] initWithFrame:CGRectMake(105, 220, 860, 40)];
    //_password2.placeholder = @" 大于等于6位";
    _password2.layer.borderWidth = 0;
    _password2.font = [UIFont systemFontOfSize:15];
    _password2.textColor = [UIColor colorWithWhite:0 alpha:0.6];
    _password2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password2.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    _password2.tag = 1011;
    _password2.delegate =self;
    _password2.secureTextEntry = YES;
    [self.view addSubview:_password2];
    //线条
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(25, 215, self.view.frame.size.width-25, 1)];
    lineView4.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView4];
    //线条
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 265, self.view.frame.size.width-0, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView5];
    //确认
    UIButton *queren = [UIButton buttonWithType:UIButtonTypeSystem];
    [queren setTitle:@"确  定" forState:UIControlStateNormal];
    queren.frame = CGRectMake(10, 285, width- 20, 40);
    queren.layer.cornerRadius = 8;
    [queren addTarget:self action:@selector(postData:) forControlEvents:UIControlEventTouchUpInside];
    queren.titleLabel.font = [UIFont systemFontOfSize:17];
    [queren setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    queren.backgroundColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0];
    [self.view addSubview:queren];
 
    
    [self.view addSubview:mimaLabel];
}
- (void)createBack {
    UIButton *backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(5, 20, 60, 44);
    //[backBut setTitle:@"返回" forState:UIControlStateNormal];
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
    if (_number.text.length == 0||_yanzhengma.text.length==0||_password1.text.length == 0||_password2.text.length== 0) {
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
            NSArray *signArr = [NSArray arrayWithObjects:_number.text,_password2.text,_yanzhengma.text, nil];
            NSMutableString *str= (NSMutableString *)[NSString signString:signArr];
            
            NSString *strSign = @"QvyBR6hvf9Z8bzqGVWF3t8b6H9IK2DQm";
            [str appendString:strSign];
            NSDictionary *dict = @{@"mobile" : _number.text, @"newpassword" : _password2.text, @"code" : _yanzhengma.text, @"sign" : [str md5]};//@"sign" : [str md5]
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"]; // 配置content-type
            [manager POST:Back parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"info"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
                if ([responseObject[@"info"] isEqualToString:@"成功啦"]) {
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
#pragma mark - 验证码
- (void)click:(UIButton *)button {
    [self timeCountdown];
    NSArray *signArr = [NSArray arrayWithObjects:_number.text, nil];
    NSMutableString *str= (NSMutableString *)[NSString signString:signArr];
    
    NSString *strSign = @"QvyBR6hvf9Z8bzqGVWF3t8b6H9IK2DQm";
    [str appendString:strSign];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"]; // 配置content-type
    NSString *strURL = [NSString stringWithFormat:GetCode,_number.text,[str md5]];
    NSLog(@"%@",strURL);
     _huoqu.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
#pragma mark - Event response 处理按钮状态
- (void)didLoginButtonChange:(BOOL)enabled
{
    if (enabled) {
        _huoqu.userInteractionEnabled = YES;
        _huoqu.layer.borderWidth = 1;
        _huoqu.layer.borderColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0  alpha:1.0].CGColor;
        [_huoqu setTitleColor:[UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        _huoqu.userInteractionEnabled = NO;
        _huoqu.layer.borderWidth = 1;
        _huoqu.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_huoqu setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
    }
}

#pragma mark - textField Delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;
{
    if (_number.text.length==10) {
        [self didLoginButtonChange:YES];
    }
    else {
        [self didLoginButtonChange:NO];
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self didLoginButtonChange:NO];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField*)textField {
    CGFloat width = self.view.frame.size.width - 50;
    if (textField.tag == 1000) {
        BOOL numBOOL =  [_number.text isValidPhoneNumber];
        if (!numBOOL) {
            if (!_error1) {
                _error1 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 80, 20, 20)];
                _error1.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                _error1.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:_error1];
            }
        }else {
            [_error1 removeFromSuperview];
            _error1 = nil;
        }
    }else if (textField.tag == 1010) {
        if (_password1.text.length<=5) {
            if (!_error4) {
                _error4 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 180, 20, 20)];
                _error4.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                [self.view addSubview:_error4];
            }
        }else {
            [_error4 removeFromSuperview];
            _error4 = nil;
        }
    }else if (textField.tag == 1011) {
        if (![_password2.text isEqualToString:_password1.text]||_password2.text.length<=5) {
            if (!_error3) {
                _error3 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 230, 20, 20)];
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

#pragma mark - 60s 倒计时
- (void)timeCountdown{
    _countdowning = YES;
    __block NSInteger timeout = 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _huoqu.titleLabel.text = @"重新发送";
                _countdowning = NO;
                [_huoqu setTitleColor:[UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0] forState:UIControlStateNormal];
                _huoqu.userInteractionEnabled = YES;
                if (_number.text.length >= 10) {
                    _huoqu.enabled = YES;
                }
            });
        }
        else {
            [_huoqu setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _huoqu.userInteractionEnabled = NO;
            NSInteger seconds = timeout % 60;
            NSString* strTime = [NSString stringWithFormat:@"(%.2ld)后重发", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _huoqu.titleLabel.text = strTime;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
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
