//
//  DesignorControllerViewController.m
//  好品
//
//  Created by 朱明科 on 16/2/25.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "DesignorControllerViewController.h"

@interface DesignorControllerViewController ()

@end

@implementation DesignorControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *design = [NSString stringWithFormat:@"%@design",[self.userDeft objectForKey:@"selectSTR"]];
    if (design == nil) {
        self.dataArr = nil;
    }else{
        self.dataArr = [NSMutableArray arrayWithArray:[self.userDeft objectForKey:design]];
    }
    //头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    headView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 40)];
    headLabel.text = @"所有设计师";
    [headView addSubview:headLabel];
    self.tableView.tableHeaderView = headView;
}

@end
