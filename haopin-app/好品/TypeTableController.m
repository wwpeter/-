//
//  TypeTableController.m
//  好品
//
//  Created by 朱明科 on 16/1/7.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "TypeTableController.h"

@interface TypeTableController ()

@end

@implementation TypeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *type = [NSString stringWithFormat:@"%@type",[self.userDeft objectForKey:@"selectSTR"]];
    if (type == nil) {
        self.dataArr = nil;
    }else{
        self.dataArr = [NSMutableArray arrayWithArray:[self.userDeft objectForKey:type]];
    }
//    self.dataArr = [NSMutableArray arrayWithArray:[self.userDeft objectForKey:type]];
    //头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    headView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 40)];
    headLabel.text = @"所有品类";
    [headView addSubview:headLabel];
    self.tableView.tableHeaderView = headView;
}

@end
