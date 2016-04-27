//
//  KuoXingController.m
//  haopin
//
//  Created by 朱明科 on 16/3/31.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "KuoXingController.h"

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kColor  [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0]
@interface KuoXingController ()
@property(nonatomic)UIImageView *kImageView;
@end

@implementation KuoXingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton];
    [self initUI];
}
-(void)createButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [backButton setTitleColor:kColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item1;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(0, 0, 44, 44);
    [doneButton setTitle:@"保存" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [doneButton setTitleColor:kColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = item2;
}
-(void)initUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:249.0/255 alpha:1.0];
    [self.view addSubview:bgView];
    
    self.kImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kWidth-400)/2, 100, 400, kHeight-270)];
    _kImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_kImageView setImage:self.backImage];
    [self.view addSubview:self.kImageView];
}
#pragma mark - 返回
-(void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mrak - 保存
-(void)done:(UIButton *)button{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
