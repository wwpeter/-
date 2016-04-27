//
//  ChooseSessionController.m
//  好品
//
//  Created by 朱明科 on 15/12/28.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "ChooseSessionController.h"

@interface ChooseSessionController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UITableView *detailTabView;
@property (nonatomic) NSUserDefaults *userDeft;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic,copy) NSString *selectStr;//选中时
@property (nonatomic) NSNumber *selectNumYear;//选中的是第几个年份
@property (nonatomic) NSIndexPath *alreadySel;
@end

@implementation ChooseSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self createData];
    [self createUI];
}
-(void)createData{
    NSArray *yearARR = [_userDeft objectForKey:@"yearARR"];
    if (yearARR == nil) {
        self.dataArray = nil;
    }else{
        self.dataArray = [NSMutableArray arrayWithArray:yearARR];
    }
    //self.dataArray = [NSMutableArray arrayWithArray:yearARR];
    [self.detailTabView reloadData];
}
-(void)createUI{
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 723, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"选择年份季节";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    //所有label
    UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 45, 723, 50)];
    allLabel.text = @"  所有年份季节";
    allLabel.font = [UIFont systemFontOfSize:16];
    allLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    [self.view addSubview:allLabel];
    
    //年份选项
    self.detailTabView = [[UITableView alloc]initWithFrame:CGRectMake(1, 104, 723, 623) style:UITableViewStylePlain];
    _detailTabView.delegate = self;
    _detailTabView.dataSource = self;
    _detailTabView.separatorColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    UIView *views = [[UIView alloc]init];
    views.backgroundColor = [UIColor clearColor];
    [_detailTabView setTableFooterView:views];
    [self.view addSubview:_detailTabView];
}
#pragma mark - tableview data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
//    NSNumber *num = [_userDeft objectForKey:@"selectNumYear"];
//    NSInteger selectInt = [num integerValue];
//    if (indexPath.row == selectInt && num != nil) {
//        self.alreadySel = indexPath;
//        cell.textLabel.textColor = [UIColor colorWithRed:62.0/255 green:202.0/255 blue:72.0/255 alpha:1.0];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.frame = CGRectMake(0, 0, 25, 25);
//        [button setBackgroundImage:[UIImage imageNamed:@"draw"] forState:UIControlStateNormal];
//        cell.accessoryView = button;
//    }
    NSString *selectRow = [_userDeft objectForKey:@"selectSTR"];
    if ([cell.textLabel.text isEqualToString:selectRow]) {
        self.alreadySel = indexPath;
        cell.textLabel.textColor = [UIColor colorWithRed:62.0/255 green:202.0/255 blue:72.0/255 alpha:1.0];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 25, 25);
        [button setBackgroundImage:[UIImage imageNamed:@"draw"] forState:UIControlStateNormal];
        cell.accessoryView = button;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *scell = [_detailTabView cellForRowAtIndexPath:self.alreadySel];
    scell.textLabel.textColor = [UIColor blackColor];
    scell.accessoryView = nil;
    
    self.selectStr = [NSString stringWithString:self.dataArray[indexPath.row]];
    UITableViewCell *cell = [_detailTabView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:62.0/255 green:202.0/255 blue:72.0/255 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"draw"] forState:UIControlStateNormal];
    cell.accessoryView = button;
    [_userDeft setObject:self.selectStr forKey:@"selectSTR"];
    [_userDeft synchronize];
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"typeRefresh" object:nil userInfo:@{@"YES":@"refresh"}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
   // NSNotificationCenter *center = [NSNotificationCenter ];
//    self.selectNumYear = [NSNumber numberWithInteger:indexPath.row];
//    [_userDeft setObject:_selectNumYear forKey:@"selectNumYear"];
//    [_userDeft synchronize];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_detailTabView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryView = nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)viewWillAppear:(BOOL)animated{
    [self createData];
}
@end
