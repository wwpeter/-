//
//  BodTableController.m
//  好品
//
//  Created by 朱明科 on 16/1/7.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "BodTableController.h"

@interface BodTableController ()

@end

@implementation BodTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *year = [self.userDeft objectForKey:@"selectSTR"];
    if (year == nil) {
        self.dataArr = nil;
    }else{
        self.dataArr = [NSMutableArray arrayWithArray:[self.userDeft objectForKey:year]];
    }
//    self.dataArr = [NSMutableArray arrayWithArray:[self.userDeft objectForKey:year]];
    //头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    headView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 40)];
    headLabel.text = @"所有波段";
    [headView addSubview:headLabel];
    self.tableView.tableHeaderView = headView;
}
@end
