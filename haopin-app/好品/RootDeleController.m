//
//  RootDeleController.m
//  好品
//
//  Created by 朱明科 on 16/1/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "RootDeleController.h"

@interface RootDeleController ()

@property(nonatomic)NSUserDefaults *userDeft;
@end

@implementation RootDeleController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)deleArr{
    if (_deleArr == nil) {
        _deleArr = [NSMutableArray array];
    }
    return _deleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    self.currentYear = [_userDeft objectForKey:@"selectSTR"];
    
    [self createUI];
}
-(void)createUI{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 69)];
    headView.backgroundColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0];
    headView.userInteractionEnabled = YES;
    [self.view addSubview:headView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.frame = CGRectMake(15, 25, 25, 25);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delet:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:deleteBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(kWidth-55, 25, 50, 30);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:doneBtn];
}
-(void)delet:(UIButton *)button{}
-(void)done:(UIButton *)button{}
@end
