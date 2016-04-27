//
//  JileiController.m
//  好品
//
//  Created by 朱明科 on 16/1/7.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "JileiController.h"

@interface JileiController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JileiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    
    [self createUI];
}
-(void)createUI{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kWidth, 49)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.userInteractionEnabled = YES;
    [self.view addSubview:titleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(15, 10, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"trturn02"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    headView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 40)];
    headLabel.text = self.headTitle;
    [headView addSubview:headLabel];
    _tableView.tableHeaderView = headView;
    //尾视图
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footView;
    [self.view addSubview:_tableView];
}
-(void)backView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    cell.layer.borderWidth = 2.0;
//    cell.layer.borderColor = [[UIColor greenColor]CGColor];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [NSString stringWithString:self.dataArr[indexPath.row]];
    if (self.haveSelectRowHandler) {
        self.haveSelectRowHandler(string);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
