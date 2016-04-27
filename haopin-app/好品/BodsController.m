//
//  BodsController.m
//  好品
//
//  Created by 朱明科 on 15/12/16.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "BodsController.h"
#import "FullScreenExampleViewController.h"
#import "ScrollDB.h"
#import "ZhuTiDB.h"
#import "KuZiDB.h"
#import "NewKTDB.h"
#import "NewKTDetail.h"
#import "TopicsDB.h"
@interface BodsController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITextField *bodText;
@property(nonatomic)UITableView *detailTabView;

@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *dataArray;//已经存储的波段
@property(nonatomic)NSMutableArray *inputArr;//输入的波段
@property (nonatomic) NSMutableArray *calendarArray;
@property (nonatomic) UIButton *startBut;
@property (nonatomic) UIButton *stopBut;
@end

@implementation BodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    //[_userDeft setObject:nil forKey:@"bodsARR"];//清空
    //self.inputArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:@"bodsARR"]];
    [self createData];
    [self createUI];
}
-(void)createData{
    NSString *year = [_userDeft objectForKey:@"selectSTR"];
    if (year == nil) {
        self.dataArray = nil;
    }else{
        NSArray *bodArr = [_userDeft objectForKey:year];
        self.dataArray = [NSMutableArray arrayWithArray:bodArr];
    }
    //NSArray *bodArr = [_userDeft objectForKey:[_userDeft objectForKey:@"selectSTR"]];
    //self.dataArray = [NSMutableArray arrayWithArray:bodArr];
    [self.detailTabView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)calendarArray {
    if (_calendarArray == nil) {
        _calendarArray = [NSMutableArray array];
    }
        return _calendarArray;
}
-(void)createUI{
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 723, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"上货周期";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    //添加波段
    self.bodText = [[UITextField alloc]initWithFrame:CGRectMake(350, 55, 270, 45)];
    _bodText.placeholder = @"波段控制";
    _bodText.borderStyle = UITextBorderStyleNone;
    _bodText.backgroundColor = [UIColor whiteColor];
    _bodText.delegate = self;
    _bodText.font = [UIFont systemFontOfSize:16];
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 45)];
    placeView.backgroundColor = [UIColor whiteColor];
    _bodText.leftView = placeView;
    _bodText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_bodText];
    //日期view
    UIView *calendarView = [[UIView alloc] initWithFrame:CGRectMake(5, 55, 340, 45)];
    calendarView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(158, 20, 35, 4)];
//    lineView.center = calendarView.center;
    lineView.backgroundColor = [UIColor darkGrayColor];
    [calendarView addSubview:lineView];
    
    [self.view addSubview:calendarView];

    //增加点击事件
    _startBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [_startBut setTitle:@"开始日期" forState:UIControlStateNormal];
    [_startBut setTintColor:[UIColor lightGrayColor]];
    _startBut.frame = CGRectMake(1, 0, 150, 45);
    [_startBut addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [calendarView addSubview:_startBut];
    
    _stopBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [_stopBut setTitle:@"结束日期" forState:UIControlStateNormal];
    [_stopBut setTintColor:[UIColor lightGrayColor]];
    _stopBut.frame = CGRectMake(180, 0, 150, 45);
    [_stopBut addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
    [calendarView addSubview:_stopBut];
    
    //添加按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(630, 55, 93, 45);
    addButton.backgroundColor = [UIColor colorWithRed:64.0/255 green:175.0/255 blue:252.0/255 alpha:1];
    [addButton.titleLabel setFont:_bodText.font];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor whiteColor]];
    [addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    //所有label
    UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 105, 723, 50)];
    allLabel.text = @"  所有上货周期";
    allLabel.font = [UIFont systemFontOfSize:16];
    allLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    [self.view addSubview:allLabel];
    //波段选项
    self.detailTabView = [[UITableView alloc]initWithFrame:CGRectMake(1, 155, 723, 558) style:UITableViewStylePlain];
    _detailTabView.delegate = self;
    _detailTabView.dataSource = self;
    _detailTabView.separatorColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    UIView *views = [[UIView alloc]init];
    views.backgroundColor = [UIColor clearColor];
    [_detailTabView setTableFooterView:views];
    [self.view addSubview:_detailTabView];
    
}
#pragma mark - 选择日期按钮
- (void)startClick:(UIButton *)button {
    NSLog(@"凯斯日期");
    FullScreenExampleViewController *controller = [[FullScreenExampleViewController alloc] init];
    [controller setHidesBottomBarWhenPushed:YES];
    [controller setHandler:^(NSString *startString) {
        NSLog(@"%@",startString);
        [_startBut setTitle:startString forState:UIControlStateNormal];
        
    }];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)stopClick:(UIButton *)button {
    NSLog(@"结束日期");
    FullScreenExampleViewController *controller = [[FullScreenExampleViewController alloc] init];
    [controller setHidesBottomBarWhenPushed:YES];
    [controller setHandler:^(NSString *startString) {
        NSLog(@"%@",startString);
        [_stopBut setTitle:startString forState:UIControlStateNormal];
        
    }];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - 保存本地数据
//添加按钮事件
-(void)addBtnClick:(UIButton *)button{
    if (_bodText.text.length == 0) {
        return;
    }
//    if (_calendarText.text.length == 0 || _calendarText1.text.length == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择起止日期" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
    if ([_userDeft objectForKey:@"selectSTR"] == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有选择年份季节！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _bodText.text = nil;
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
            if ([[self.startBut currentTitle] isEqualToString:@"开始日期"]||[[self.stopBut currentTitle] isEqualToString:@"结束日期"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入起止日期！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                self.calendarArray = nil;
                NSString *bodString = [NSString stringWithFormat:@"%@",self.bodText.text];
                NSString *startCalendar = [NSString stringWithFormat:@"%@",[self.startBut currentTitle]];
                NSString *stopCalendar = [NSString stringWithFormat:@"%@",[self.stopBut currentTitle]];
                [self.calendarArray addObject:bodString];
                [self.calendarArray addObject:startCalendar];
                [self.calendarArray addObject:stopCalendar];
                NSLog(@"--------------%@",self.calendarArray);
                [self.dataArray addObject:self.calendarArray];
                NSArray *tmpArray = [NSArray arrayWithArray:_dataArray];
                [_userDeft setObject:tmpArray forKey:[_userDeft objectForKey:@"selectSTR"]];//保存到本地
                [_userDeft synchronize];
                _bodText.text = nil;
                [self.startBut setTitle:@"开始日期" forState:UIControlStateNormal];
                [self.stopBut setTitle:@"结束日期" forState:UIControlStateNormal];
                
                [self createData];
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.bodText resignFirstResponder];
}
#pragma mark - text delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //[self.dataArray addObject:textField.text];
}
#pragma mark - tableview del data
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSArray *arr = self.dataArray[indexPath.row];
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@-%@",arr[1],arr[2]];
    cell.textLabel.text = string;
    cell.detailTextLabel.text = arr[0];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中是无色
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"删除本周期的所有数据？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *tmpArr = self.dataArray[indexPath.row];
        NSString *currentDate = [NSString stringWithFormat:@"%@%@-%@%@",[_userDeft objectForKey:@"selectSTR"],tmpArr[1],tmpArr[2],tmpArr[0]];
        [_userDeft setObject:nil forKey:currentDate];
        
        NSString *panduan = [NSString stringWithFormat:@"%@panduan",[_userDeft objectForKey:@"selectSTR"]];
        NSArray *panduanArr = [_userDeft objectForKey:panduan];
        NSString *string = [NSString stringWithFormat:@"%@-%@%@",tmpArr[1],tmpArr[2],tmpArr[0]];
        NSMutableArray *tmpA = [[NSMutableArray array]init];
        for (NSInteger i = 0; i < panduanArr.count; i ++) {
            if ([string isEqualToString:panduanArr[i]] == NO) {
                [tmpA addObject:panduanArr[i]];
            }
        }
        NSArray *xxx = [NSArray arrayWithArray:tmpA];
        [_userDeft setObject:xxx forKey:panduan];
        
        NSString *dateOfStr = string;
        NSString *currentYear = [_userDeft objectForKey:@"selectSTR"];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = @[indexPath];
        [self.detailTabView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        NSArray *arr = [NSArray arrayWithArray:_dataArray];
        [_userDeft setObject:arr forKey:[_userDeft objectForKey:@"selectSTR"]];
        [_userDeft synchronize];
        
        //删除数据库里的内容
        [[ScrollDB sharedInstance]deleteBySession:currentYear andDate:dateOfStr];
        [[ZhuTiDB sharedInstance]deleteBySession:currentYear andDate:dateOfStr];
        [[KuZiDB sharedInstance]deleteBySession:currentYear andDate:dateOfStr];
        [[NewKTDB sharedInstance]deleteBySession:currentYear andDate:dateOfStr];//上衣
        [[NewKTDetail sharedInstance]deleteBySession:currentYear andDate:dateOfStr];
        [[TopicsDB sharedInstance]deleteBySession:currentYear andDate:dateOfStr];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)viewWillAppear:(BOOL)animated{
    [self createData];
    self.navigationController.navigationBar.translucent = NO;
}

@end
