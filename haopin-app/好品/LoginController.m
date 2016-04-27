//
//  LoginController.m
//  haopin
//
//  Created by ww on 16/4/1.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "LoginController.h"
#import "RootViewController.h"
#import "ZhuCeController.h"
#import "NSString+Util.h"
#import "Urlutil.h"
#import "AFNetworking.h"
#import "FindViewController.h"

@interface LoginController () <NSURLConnectionDataDelegate,UITextFieldDelegate>
@property (nonatomic) UIImageView *networkView;
@property (nonatomic) UITextField *username;//用户名
@property (nonatomic) UITextField *password;//密码
@property (nonatomic) NSUserDefaults *userDefalt;//沙盒
@property (nonatomic) NSMutableData *data;//如果把服务器传过来的数据看作，mutableData用于存放服务器返回过来的数据
@property (nonatomic, copy) NSString *Legitimacy;//用户的使用期限
@property (nonatomic) UIButton *login;
@property (nonatomic) UIButton *wangji;
@property (nonatomic) UIButton *zhuce;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUI];
    [self jiance];
    //返回 激活的界面
    [self back];
}
- (void)back {
    if (self.jiHuo) {
        UIButton *backBut = [UIButton buttonWithType:UIButtonTypeSystem];
        [backBut setImage:[[UIImage imageNamed:@"HY_left_arrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        backBut.frame = CGRectMake(0, 20, 60, 40);
       // backBut.backgroundColor = [UIColor yellowColor];
        [backBut addTarget:self action:@selector(butBack:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBut];
        [self.view addSubview:backBut];//返回按钮 的事件 
    }
}
- (void)butBack:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)jiance {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status ==AFNetworkReachabilityStatusNotReachable||status ==AFNetworkReachabilityStatusUnknown) {
            if (!_networkView) {
                _networkView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150, 450, 300, 44)];
                _networkView.image = [UIImage imageNamed:@"HY_no_network.png"];
                _networkView.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:_networkView];
                _login.enabled = NO;
                _login.backgroundColor = [UIColor lightGrayColor];
                _wangji.enabled = NO;
                _zhuce.enabled = NO;
            }
        } else {
            [self.networkView removeFromSuperview];
            self.networkView = nil;
            _login.enabled = YES;
            _login.backgroundColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0];
            _wangji.enabled = YES;
            _zhuce.enabled = YES;
        }
    }];
}
- (void)loadData {
    
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    NSMutableString *tmpResult = result.mutableCopy;
    // 去除“-”
    NSRange range = [tmpResult rangeOfString:@"-"];
    while (range.location != NSNotFound) {
        [tmpResult deleteCharactersInRange:range];
        range = [tmpResult rangeOfString:@"-"];
    }
    //存储
    _userDefalt = [NSUserDefaults standardUserDefaults];
    if (![_userDefalt objectForKey:@"UUID"]) {
        [_userDefalt setObject:tmpResult forKey:@"UUID"];
        [_userDefalt synchronize];
    }
    if (![_userDefalt objectForKey:@"jihuoriqi"]) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        [_userDefalt setObject:date forKey:@"jihuoriqi"];
    }
    NSString *uuid = [_userDefalt objectForKey:@"UUID"];
    uuid = [uuid lowercaseString];
    
    NSArray *signArr = [NSArray arrayWithObjects:uuid,_username.text,_password.text,@"haoyang", nil];
    NSMutableString *str= (NSMutableString *)[NSString signString:signArr];
    
    NSString *strSign = @"QvyBR6hvf9Z8bzqGVWF3t8b6H9IK2DQm";
    [str appendString:strSign];
    
    NSString *strUrl = [NSString stringWithFormat:testURL,_username.text,_password.text,uuid,[str md5]];
    //NSString *strUrl = [NSString stringWithFormat:URL1];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    // 请求类
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
    // 连接类,它内部会开辟一个新的线程和服务器交互,不影响主线程代码的执行
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connection start]; //当connection连接建立的时候它会自动的和服务器交互，请求数据
    
}
- (void)addUI {
    if (self.guoqi) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 270, 100, 100)];
        lable.text = @"账户过期,请联系相关人员";
        lable.numberOfLines = 0;
        lable.font = [UIFont systemFontOfSize:20];
        lable.textColor  = [UIColor redColor];
        [self.view addSubview:lable];
    }
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2- 50, 100, 100, 100)];
    UIImage *image = [UIImage imageNamed:@"icon-96.png"];
    imageView.image = image;
    [self.view addSubview:imageView];
    UILabel *haoxiu = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2- 20, 200, 40, 40)];
    haoxiu.text = @"好样";
    haoxiu.textColor = [UIColor colorWithWhite:0 alpha:0.4];
    haoxiu.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:haoxiu];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    //输入用户名
    _username = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2- 150, 270, 300, 40)];
    _username.layer.borderWidth = 1;
    _username.textColor = [UIColor colorWithWhite:0 alpha:0.6];
    _username.text = [userDef objectForKey:@"username"];
    _username.layer.borderColor = [[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]CGColor];
    _username.placeholder = @"请输入手机号";
    _username.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 设置左侧视图
    _username.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftUser = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HY_username_image.png"]];
    
    _username.leftView = leftUser;
    [self.view addSubview:_username];
    //输入密码
    _password = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2- 150, 330, 300, 40)];
    _password.placeholder = @"请输入密码";
    _password.text = [userDef objectForKey:@"password"];
    _password.layer.borderWidth = 1;
    _password.secureTextEntry = YES;
    _password.textColor = [UIColor colorWithWhite:0 alpha:0.6];
    _password.delegate = self;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.layer.borderColor = [[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]CGColor];
    // 设置左侧视图
    _password.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftPass = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HY_password_image.png"]];
    _password.leftView = leftPass;
    _password.tag = 1111;
    [self.view addSubview:_password];
    
    //登录
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    [_login setTitle:@"登    录" forState:UIControlStateNormal];
    
    _login.enabled = NO;
    _login.backgroundColor = [UIColor colorWithRed:85/255.0 green:207/255.0 blue:110/255.0 alpha:1.0];
    //login.layer.borderWidth = 1.0;
    //login.layer.borderColor = [[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]CGColor];
    _login.frame = CGRectMake(self.view.frame.size.width/2-150, 390, 300, 40);
    _login.layer.cornerRadius = 5;
    
    [_login addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];
    //忘记密码
    _wangji = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wangji setTitle:@"忘记密码?" forState:UIControlStateNormal];
    
    _wangji.backgroundColor = [UIColor whiteColor];
    [_wangji setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_wangji setTitleColor:[UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0] forState:UIControlStateNormal];
    //login.layer.borderWidth = 1.0;
    //login.layer.borderColor = [[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]CGColor];
    _wangji.frame = CGRectMake(self.view.frame.size.width-130, self.view.frame.size.height-55, 100, 40);
    _wangji.layer.cornerRadius = 0;
    _wangji.tag = 1111;
    
    [_wangji addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wangji];
    //注册
    _zhuce = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zhuce setTitle:@"注册" forState:UIControlStateNormal];
    [_zhuce setTitleColor:[UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0] forState:UIControlStateNormal];
    //zhuce.layer.borderWidth = 1.0;
    //zhuce.layer.borderColor = [[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]CGColor];
    _zhuce.backgroundColor = [UIColor whiteColor];
    _zhuce.frame = CGRectMake(35, self.view.frame.size.height- 55, 40, 40);
    _zhuce.layer.cornerRadius = 10;
    
    [_zhuce addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zhuce];
}
- (void)buttonClick1:(UIButton *)button {
    ZhuCeController *zhuce = [[ZhuCeController alloc] init];
    [self presentViewController:zhuce animated:YES completion:^{
        
    }];
}
- (void)buttonClick2:(UIButton *)button{
    //if (button.tag == 1111) {
        FindViewController *controller = [[FindViewController alloc] init];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    //}
}
- (void)buttonClick:(UIButton *)button {
   
    if (!(self.username.text.length > 0) || !(self.password.text.length)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请你检测用户名或密码是否为空！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *baoCun = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:baoCun];
    } else {
        [self loadData];
    }
}
- (void)returnBut {
    if (!(self.username.text.length > 0) || !(self.password.text.length)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请你检测用户名或密码是否为空！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *baoCun = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:baoCun];
    } else {
        [self loadData];
    }
}
#pragma mark - <NSURLConnectionDataDelegate>
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"error: %@", error] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *baoCun = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:baoCun];
    [self presentViewController:alert animated:YES completion:nil];
}
// 当收到服务器的响应［在这个方法里我们可以获取服务器给我们传过来的响应头信息］
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [NSMutableData data];
}
// 当收到服务器发送过来的数据，此方法被调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // 1. json解析 data -> dict/array
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    NSString *str = [NSString stringWithFormat:@"%@",dictionary[@"code"]];
    NSString *tishi = dictionary[@"info"];
    if ([str isEqualToString:@"0"]) {
        NSDictionary *dic = dictionary[@"data"];
        
        _Legitimacy = dic[@"expire_time"];
        NSArray *arr = [_Legitimacy componentsSeparatedByString:@"-"];
        NSString *str = [arr componentsJoinedByString:@""];
        _userDefalt = [NSUserDefaults standardUserDefaults];
        [_userDefalt setObject:str forKey:@"Legitimacy"];
        [_userDefalt setObject:_Legitimacy forKey:@"guoqi"];
        //if (![_userDefalt objectForKey:@"username"]||![_userDefalt objectForKey:@"password"]) {
            [_userDefalt setObject:_username.text forKey:@"username"];
            [_userDefalt setObject:_password.text forKey:@"password"];
        //}
        [_userDefalt synchronize];
        if (_jiHuo) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            RootViewController *root = [[RootViewController alloc]init];
            [self presentViewController:root animated:NO completion:nil];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",tishi] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *baoCun = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:baoCun];
        [self presentViewController:alert animated:YES completion:nil];
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
#pragma mark - 键盘的代理方法
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField.tag == 1111) {
        [self returnBut];
    }
    return YES;
}
#pragma  -mark网络监测
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

@end
