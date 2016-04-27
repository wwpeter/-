//
//  ZhuCeController.m
//  haopin
//
//  Created by ww on 16/4/1.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ZhuCeController.h"
#import "WQFlower.h"
#import "Urlutil.h"
#import "NSString+Util.h"
#import "AFNetworking.h"
//#import "UIViewController+util.h"

@interface ZhuCeController ()<UIWebViewDelegate,UITextFieldDelegate>
@property (nonatomic) BOOL countdowning;
@property (nonatomic) UIWebView *web;
@property (nonatomic) UITextField *nicheng;
@property (nonatomic) UITextField *number;
@property (nonatomic) UITextField *yanzhengma;
@property (nonatomic) UITextField *email;
@property (nonatomic) UITextField *password1;
@property (nonatomic) UITextField *password2;
@property (nonatomic) UIButton *huoqu;
@property (nonatomic) UIImageView *error1;
@property (nonatomic) UIImageView *error2;
@property (nonatomic) UIImageView *error3;
@property (nonatomic) UIImageView *error4;
@property (nonatomic) UIView *lineView1;
@end


//#define test @"http://www.howshow.com.com/auth/register"

@implementation ZhuCeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[self addUI];
    [self createUI];
    [self addBack];
}
- (void)addBack {
    //增加返回登录按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-10, 20, 80, 44);
    //[button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"HY_cuowu_image.png"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)createUI {
    [self.view addSubview:[self lineView1]];
    
   CGFloat width = self.view.frame.size.width;
    //导航条
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 50, 20, 100, 44)];
    label.text = @"用户注册";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:label];
    //昵称
    UILabel *nichengaLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 69, 100, 40)];
    [nichengaLabel setText:@"昵    称:"];
    nichengaLabel.textAlignment = NSTextAlignmentLeft;
    nichengaLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    nichengaLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:nichengaLabel];
    _nicheng = [[UITextField alloc] initWithFrame:CGRectMake(85, 69, 870, 40)];
    _nicheng.font = [UIFont systemFontOfSize:15];
    _nicheng.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _nicheng.layer.borderWidth = 0;
    //_nicheng.placeholder = @"好样";
    _nicheng.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nicheng.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    [self.view addSubview:_nicheng];
    //线条
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(25, 114, self.view.frame.size.width-25, 1)];
    lineView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:lineView1];
    
    //手机号
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 119, 100, 40)];
    [numberLabel setText:@"手机号:"];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    numberLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:numberLabel];
    _number = [[UITextField alloc] initWithFrame:CGRectMake(85, 119, 870, 40)];
    _number.layer.borderWidth = 0;
    _number.font = [UIFont systemFontOfSize:15];
    _number.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _number.delegate = self;
    _number.tag = 1000;
    //_number.placeholder = @"请输入手机号";
    _number.keyboardType = UIKeyboardTypeNumberPad;
    _number.clearButtonMode = UITextFieldViewModeWhileEditing;
    _number.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    [self.view addSubview:_number];
    //线条
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(25, 164, self.view.frame.size.width-25, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView2];
    //验证码
    UILabel *yanzhengmaLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 169, 100, 40)];
    [yanzhengmaLabel setText:@"验证码:"];
    yanzhengmaLabel.textAlignment = NSTextAlignmentLeft;
    yanzhengmaLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    yanzhengmaLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:yanzhengmaLabel];
    _yanzhengma = [[UITextField alloc] initWithFrame:CGRectMake(85, 169, 750, 40)];
    _yanzhengma.layer.borderWidth = 0;
    _yanzhengma.font = [UIFont systemFontOfSize:15];
    _yanzhengma.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _yanzhengma.clearButtonMode = UITextFieldViewModeWhileEditing;
    _yanzhengma.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    _yanzhengma.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_yanzhengma];
    
    _huoqu = [UIButton buttonWithType:UIButtonTypeCustom];
    _huoqu.frame = CGRectMake(self.view.frame.size.width - 110, 172, 90, 35);
    [_huoqu setTitle:@"获取验证码" forState:UIControlStateNormal];
    //[huoqu setTitleColor:[UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_huoqu addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _huoqu.layer.cornerRadius = 5;
    _huoqu.layer.borderWidth = 1;
    _huoqu.titleLabel.font = [UIFont systemFontOfSize:14];
    _huoqu.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    [self.view addSubview:_huoqu];
    [self didLoginButtonChange:NO];
    //邮箱
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 219, 100, 40)];
    [emailLabel setText:@"邮    箱:"];
    emailLabel.textAlignment = NSTextAlignmentLeft;
    emailLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    emailLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:emailLabel];
    _email = [[UITextField alloc] initWithFrame:CGRectMake(85, 219, 870, 40)];
    _email.layer.borderWidth = 0;
    _email.font = [UIFont systemFontOfSize:15];
    _email.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _email.clearButtonMode = UITextFieldViewModeWhileEditing;
    _email.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    _email.tag = 1001;
    _email.delegate = self;
    [self.view addSubview:_email];
    //线条
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(25, 214, self.view.frame.size.width-25, 1)];
    lineView3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView3];
    
    //密码
    UILabel *pass2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 269, 100, 40)];
    [pass2 setText:@"密   码:"];
    pass2.textAlignment = NSTextAlignmentLeft;
    pass2.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    pass2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:pass2];
    _password2 = [[UITextField alloc] initWithFrame:CGRectMake(85, 269, 870, 40)];
    _password2.layer.borderWidth = 0;
    _password2.font = [UIFont systemFontOfSize:15];
    _password2.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _password2.placeholder = @"大于等于6位";
    _password2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password2.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
    _password2.tag = 1003;
    _password2.delegate =self;
    _password2.secureTextEntry = YES;
    [self.view addSubview:_password2];
    //线条
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(25, 264, self.view.frame.size.width-25, 1)];
    lineView4.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView4];
    
    //确认密码
    UILabel *pass = [[UILabel alloc] initWithFrame:CGRectMake(30, 319, 100, 40)];
    [pass setText:@"确认密码:"];
    pass.textAlignment = NSTextAlignmentLeft;
    pass.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    pass.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:pass];
    _password1 = [[UITextField alloc] initWithFrame:CGRectMake(105, 319, 860, 40)];
    _password1.layer.borderWidth = 0;
    _password1.font = [UIFont systemFontOfSize:15];
    _password1.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    _password1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password1.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
    _password1.tag = 1002;
    _password1.delegate = self;
    //_password1.placeholder = @"大于等于6位";
    _password1.secureTextEntry = YES;
    [self.view addSubview:_password1];
    //线条
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(25, 314, self.view.frame.size.width-25, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView5];
    
    //确认
    UIButton *queren = [UIButton buttonWithType:UIButtonTypeSystem];
    [queren setTitle:@"确    定" forState:UIControlStateNormal];
    queren.frame = CGRectMake(10, 384, self.view.frame.size.width-20, 40);
    queren.layer.cornerRadius = 8;
    [queren addTarget:self action:@selector(postData:) forControlEvents:UIControlEventTouchUpInside];
    queren.titleLabel.font = [UIFont systemFontOfSize:18];
    [queren setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    queren.backgroundColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0];
    [self.view addSubview:queren];
    
   // 线条
    UIView *lineView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 364, self.view.frame.size.width, 1)];
    lineView6.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:lineView6];
}
- (void)postData:(UIButton *)button {
    if (_nicheng.text.length==0||_number.text.length == 0||_yanzhengma.text.length==0||_email.text.length == 0||_password1.text.length == 0||_password2.text.length== 0) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"有模块为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *quding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:quding];
        [self presentViewController:controller animated:YES completion:^{
        }];
    } else {
        if (_error1||_error2||_error3||_error4) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请修改错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *quding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:quding];
            [self presentViewController:controller animated:YES completion:^{
            }];
        } else {
            NSArray *signArr = [NSArray arrayWithObjects:_number.text,_nicheng.text,_email.text,_password2.text,_yanzhengma.text, nil];
            NSMutableString *str= (NSMutableString *)[NSString signString:signArr];
            NSLog(@"%@",str);
            NSString *strSign = @"QvyBR6hvf9Z8bzqGVWF3t8b6H9IK2DQm";
            [str appendString:strSign];
            NSDictionary *dict = @{@"name" : _nicheng.text, @"mobile" : _number.text, @"password" : _password2.text, @"email" : _email.text, @"code" : _yanzhengma.text, @"sign" : [str md5]};//@"sign" : [str md5]
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"]; // 配置content-type
            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:Register parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self.view endEditing:YES];
               // NSDictionary *dic = responseObject[@"info"];
                NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                
                if ([str isEqualToString:@"0"]) {
                    [self alertCancle:responseObject[@"info"]];
                    if ([responseObject[@"info"] isEqualToString:@"注册成功"]) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                    }
                } else {

                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"info"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *queding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                    }];
                    [alert addAction:queding];
                    [self presentViewController:alert animated:YES completion:nil];
                }
//                else if([str isEqualToString:@"10010"]){
//                    
//                    NSDictionary *dic = responseObject[@"info"];
//                    if (dic[@"name"]) {
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"昵称被占用" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *queding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                            
//                        }];
//                        [alert addAction:queding];
//                        [self presentViewController:alert animated:YES completion:nil];
//                    } else {
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手机号被占用"message:nil preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *queding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                            
//                        }];
//                        [alert addAction:queding];
//                        [self presentViewController:alert animated:YES completion:nil];
//                    }
//                    
//                    NSLog(@"%@",dic[@"name"]);
//                } else if ([str isEqualToString:@"20003"]){
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"验证码错误"message:nil preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *queding = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        
//                    }];
//                    [alert addAction:queding];
//                    [self presentViewController:alert animated:YES completion:nil];
//                }
                NSLog(@"ww");
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }
}
- (void)alertCancle:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
}
-(void)timer:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [self dismissViewControllerAnimated:alert completion:nil];
    [timer invalidate];
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//- (void)addUI {
//    
//    // _web
//    //[WQFlower show];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
//    webView.delegate = self;
//    NSURL *urls = [NSURL URLWithString:Register];//http://oauth.lixy.com/auth/register
//    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:urls];
//    
//    [webView loadRequest:urlRequest];
//    [self.view addSubview:webView];
//}
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
        _huoqu.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        [_huoqu setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
    }
}
#pragma mark - textField Delegate

- (void)textFieldDidBeginEditing:(UITextField*)textField {
    if (textField.tag == 1002) {
        self.view.frame = CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

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
                _error1 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 129, 20, 20)];
                _error1.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                _error1.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:_error1];
            }
        }else {
            [_error1 removeFromSuperview];
            _error1 = nil;
        }
    }else if (textField.tag == 1001) {
        BOOL numBOOL =  [_email.text isValidEmail];
        if (!numBOOL) {
            if (!_error2) {
                _error2 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 229, 20, 20)];
                _error2.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                _error2.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:_error2];
            }
        }else {
            [_error2 removeFromSuperview];
            _error2 = nil;
        }
    }else if (textField.tag == 1003) {
        if (_password2.text.length<=5) {
            if (!_error4) {
                _error4 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 279, 20, 20)];
                _error4.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                _error4.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:_error4];
            }
        }else {
            [_error4 removeFromSuperview];
            _error4 = nil;
        }
    }else if (textField.tag == 1002) {
        if (![_password1.text isEqualToString:_password2.text]||_password1.text.length<=5) {
            if (!_error3) {
                _error3 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 328, 20, 20)];
                _error3.image = [UIImage imageNamed:@"HY_Status_error1.png"];
                _error3.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:_error3];
            }
        }else {
            [_error3 removeFromSuperview];
            _error3 = nil;
        }
    }else {
    
    }
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"成功");
    //[WQFlower dismiss];
    
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
                 _countdowning = NO;
                _huoqu.titleLabel.text = @"重新发送";
                [_huoqu setTitleColor:[UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0] forState:UIControlStateNormal];
                 _huoqu.layer.borderColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0].CGColor;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - getter and  setter 方法
- (UIView *)lineView1 {
    if(!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
        _lineView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        return _lineView1;
    }
    return nil;
}

@end

