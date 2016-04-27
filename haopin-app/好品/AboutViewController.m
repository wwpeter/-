//
//  AboutViewController.m
//  好品
//
//  Created by 朱明科 on 15/12/16.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}
-(void)createUI{
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 723, 44)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"关于";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    UIView *lineo = [[UIView alloc]initWithFrame:CGRectMake(1, 44, 723, 1)];
    lineo.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self.view addSubview:lineo];
    //logo View
    UIView *logoView = [[UIView alloc]initWithFrame:CGRectMake(1, 45, 723, 300)];
    logoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:logoView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(310, 62, 100, 100)];
//    imageView.backgroundColor = [UIColor greenColor];
    imageView.image = [UIImage imageNamed:@"icon-96"];
    [logoView addSubview:imageView];
    UILabel *logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(310, 155, 100, 100)];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.text = @"V1.0";
    logoLabel.font = [UIFont systemFontOfSize:14];
    logoLabel.textColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [logoView addSubview:logoLabel];
    UILabel *haopin = [[UILabel alloc]initWithFrame:CGRectMake(310, 155, 100, 50)];
    haopin.textAlignment = NSTextAlignmentCenter;
    haopin.text = @"好样";
    haopin.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    haopin.font = [UIFont systemFontOfSize:18];
    [logoView addSubview:haopin];
    //联系电话
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(1, 294, 723, 1)];
    line1.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    [self.view addSubview:line1];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(1, 295, 19, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    UILabel *phoLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 295, 300, 50)];
    phoLable.textAlignment = NSTextAlignmentLeft;
    phoLable.text = @"客服电话";
    phoLable.font = [UIFont systemFontOfSize:16];
    phoLable.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    phoLable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoLable];
    UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(281, 295, 423, 50)];
    numLable.text = @"0571-81110605";
    numLable.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    numLable.font = [UIFont systemFontOfSize:14];
    numLable.textAlignment = NSTextAlignmentRight;
    numLable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:numLable];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(704, 295, 20, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    //版权 View
    UIView *usView = [[UIView alloc]initWithFrame:CGRectMake(1, 345, 723, 325)];
    usView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:usView];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 723, 1)];
    line2.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    [usView addSubview:line2];
}
@end


