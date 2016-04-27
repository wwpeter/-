//
//  SessionsController.m
//  好品
//
//  Created by 朱明科 on 15/12/16.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "SessionsController.h"
#import "DataBase.h"
#import "DBManager.h"
#import "DataManager.h"
#import "KTDBManager.h"
#import "DetailDB.h"
#import "CBDetailDB.h"
#import "BQDetailDB.h"
#import "NewKTDB.h"
#import "NewKTDetail.h"
#import "TopicsDB.h"
#import "ZhuTiDB.h"
@interface SessionsController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITextField *yearText;
@property(nonatomic)UITableView *detailTabView;

@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *dataArray;//已经存储的年份季节
@property(nonatomic)NSMutableArray *inputArr;//输入的季节年份
@property(nonatomic,copy)NSString *selectStr;//选中时
@property(nonatomic)NSNumber *selectNumYear;//选中的是第几个年份
@end

@implementation SessionsController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    NSArray *nianArr = [_userDeft objectForKey:@"yearARR"];
    if (nianArr == nil) {
        self.inputArr = nil;
    }else{
        self.inputArr = [NSMutableArray arrayWithArray:nianArr];
    }

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
    [self.detailTabView reloadData];
}
-(void)createUI{
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 723, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"添加年份季节";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    //添加年份
    self.yearText = [[UITextField alloc]initWithFrame:CGRectMake(1, 55, 620, 45)];
    _yearText.placeholder = @"添加年份季节";
    _yearText.borderStyle = UITextBorderStyleNone;
    _yearText.backgroundColor = [UIColor whiteColor];
    _yearText.delegate = self;
    _yearText.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_yearText];
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 45)];
    placeView.backgroundColor = [UIColor whiteColor];
    _yearText.leftView = placeView;
    _yearText.leftViewMode = UITextFieldViewModeAlways;
    //添加按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(630, 55, 93, 45);
    addButton.backgroundColor = [UIColor colorWithRed:64.0/255 green:175.0/255 blue:252.0/255 alpha:1];
    [addButton.titleLabel setFont:_yearText.font];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor whiteColor]];
    [addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    //所有label
    UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 105, 723, 50)];
    allLabel.text = @"  已添加年份季节";
    allLabel.font = [UIFont systemFontOfSize:16];
    allLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    [self.view addSubview:allLabel];
    
    //年份选项
    self.detailTabView = [[UITableView alloc]initWithFrame:CGRectMake(1, 155, 723, 558) style:UITableViewStylePlain];
    _detailTabView.delegate = self;
    _detailTabView.dataSource = self;
    _detailTabView.separatorColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    UIView *views = [[UIView alloc]init];
    views.backgroundColor = [UIColor clearColor];
    [_detailTabView setTableFooterView:views];
    [self.view addSubview:_detailTabView];
    
}
//添加按钮事件
-(void)addBtnClick:(UIButton *)button{
    if (_yearText.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有输入年份信息！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        NSString *string = [NSString stringWithFormat:@"%@",self.yearText.text];
        [self.dataArray addObject:string];
        NSArray *arr = [NSArray arrayWithArray:_dataArray];
        [_userDeft setObject:arr forKey:@"yearARR"];
        [_userDeft synchronize];
        _yearText.text = nil;
        [self.yearText resignFirstResponder];
        [self createData];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.yearText resignFirstResponder];
}
#pragma mark - text delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //输入的季节年份
    [self.dataArray addObject:textField.text];
}
#pragma mark - tableview del data
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.detailTabView setEditing:editing animated:animated];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"删除本年份的所有数据？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSString *yearStr = self.dataArray[indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = @[indexPath];
        [self.detailTabView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        NSArray *arr = [NSArray arrayWithArray:_dataArray];
        [_userDeft setObject:arr forKey:@"yearARR"];
        NSString *type = [NSString stringWithFormat:@"%@type",yearStr];
        NSString *designor = [NSString stringWithFormat:@"%@design",yearStr];
        NSString *panduan = [NSString stringWithFormat:@"%@panduan",yearStr];
        [_userDeft setObject:nil forKey:yearStr];
        [_userDeft setObject:nil forKey:type];
        [_userDeft setObject:nil forKey:designor];
        [_userDeft setObject:nil forKey:@"selectSTR"];
        [_userDeft setObject:nil forKey:panduan];
        [_userDeft synchronize];
//删除对应年份的所有信息
        [[DataBase shareInstance]deleteClothByYear:yearStr];//货品
        [[DBManager sharedInstance]deleteByYear:yearStr];//组合
        [[CBDetailDB sharedInstance]deleteBySession:yearStr];
        [[DataManager sharedInstance]deleteByYear:yearStr];//板墙
        [[KTDBManager sharedInstance]deleteBySession:yearStr];//
        [[BQDetailDB sharedInstance]deleteBySession:yearStr];//板墙详情
        [[DetailDB sharedInstance]deleteBySession:yearStr];//KT详情
        [[NewKTDB sharedInstance]deleteBySession:yearStr];
        [[NewKTDetail sharedInstance]deleteBySession:yearStr];
        [[TopicsDB sharedInstance]deleteBySession:yearStr];
        [[ZhuTiDB sharedInstance]deleteBySession:yearStr];
        //创建一个消息对象
        NSNotification *notification = [NSNotification notificationWithName:@"typeRefresh" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
@end
