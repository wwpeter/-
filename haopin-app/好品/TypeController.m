//
//  TypeController.m
//  好品
//
//  Created by 朱明科 on 15/12/16.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "TypeController.h"
#import "DataBase.h"
@interface TypeController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITextField *typeText;
@property(nonatomic)UITableView *typeTabView;

@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *dataArray;//已经存储的类型
@property(nonatomic)NSMutableArray *inputArr;//输入的类型
@end

@implementation TypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    //self.inputArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:@"typeARR"]];
    [self createData];
    [self createUI];
}
-(void)createData{
    NSString *str = [_userDeft objectForKey:@"selectSTR"];
    if (str == nil) {
        self.dataArray = nil;
    }else{
        NSString *type = [NSString stringWithFormat:@"%@type",str];
        NSArray *yearARR = [_userDeft objectForKey:type];
        self.dataArray = [NSMutableArray arrayWithArray:yearARR];
    }
    [self.typeTabView reloadData];
}
-(void)createUI{
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 723, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"品类控制";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    //添加品类
    self.typeText = [[UITextField alloc]initWithFrame:CGRectMake(1, 55, 620, 45)];
    _typeText.placeholder = @"添加品类";
    _typeText.borderStyle = UITextBorderStyleNone;
    _typeText.backgroundColor = [UIColor whiteColor];
    _typeText.delegate = self;
    _typeText.font = [UIFont systemFontOfSize:16];
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 45)];
    placeView.backgroundColor = [UIColor whiteColor];
    _typeText.leftView = placeView;
    _typeText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_typeText];
    //添加按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(630, 55, 93, 45);
    addButton.backgroundColor = [UIColor colorWithRed:64.0/255 green:175.0/255 blue:252.0/255 alpha:1];
    [addButton.titleLabel setFont:_typeText.font];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor whiteColor]];
    [addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    //所有label
    UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 105, 620, 50)];
    allLabel.text = @"  所有品类";
    allLabel.font = [UIFont systemFontOfSize:16];
    allLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    [self.view addSubview:allLabel];
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(622, 105, 100, 50)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    //品类选项
    self.typeTabView = [[UITableView alloc]initWithFrame:CGRectMake(1, 155, 723, 558) style:UITableViewStylePlain];
    _typeTabView.delegate = self;
    _typeTabView.dataSource = self;
    _typeTabView.separatorColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    UIView *views = [[UIView alloc]init];
    views.backgroundColor = [UIColor clearColor];
    [_typeTabView setTableFooterView:views];
    [self.view addSubview:_typeTabView];
}
//开启编辑模式
-(void)edit:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.typeTabView setEditing:YES animated:YES];
    }else{
        [self.typeTabView setEditing:NO animated:NO];
    }
    
}
//添加按钮事件
-(void)addBtnClick:(UIButton *)button{
    if (_typeText.text.length == 0) {
        return;
    }
    if ([_userDeft objectForKey:@"selectSTR"] == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有选择年份季节！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _typeText.text = nil;
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        NSString *string = [NSString stringWithFormat:@"%@",self.typeText.text];
        [self.dataArray addObject:string];
        NSArray *tmpArray = [NSArray arrayWithArray:_dataArray];
        NSString *str = [_userDeft objectForKey:@"selectSTR"];
        NSString *type = [NSString stringWithFormat:@"%@type",str];
        [_userDeft setObject:tmpArray forKey:type];//保存到本地
        [_userDeft synchronize];
        _typeText.text = nil;
        [self.typeText resignFirstResponder];
        [self createData];
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.typeText resignFirstResponder];
}
#pragma mark - text delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中是无色
    return cell;
}
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    [super setEditing:editing animated:animated];
//    [self.typeTabView setEditing:editing animated:animated];
//}
#pragma mark - 删除
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"删除本品类的所有数据？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *deleTypeStr = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = @[indexPath];
        [self.typeTabView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        NSArray *arr = [NSArray arrayWithArray:_dataArray];
        NSString *str = [_userDeft objectForKey:@"selectSTR"];
        NSString *type = [NSString stringWithFormat:@"%@type",str];
        [_userDeft setObject:arr forKey:type];
        [_userDeft synchronize];
        //删除数据库对应的内容
        [[DataBase shareInstance]deleteClothByYear:str andType:deleTypeStr];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"refresh" object:nil userInfo:@{@"YES":@"refresh"}];
        NSNotification *notification = [NSNotification notificationWithName:@"typeRefresh" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 改变位置
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//编辑模式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//缩进
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath == destinationIndexPath) {
        return;
    }
    NSString *string = [self.dataArray objectAtIndex:sourceIndexPath.row];
    [self.dataArray removeObjectAtIndex:sourceIndexPath.row];
    [self.dataArray insertObject:string atIndex:destinationIndexPath.row];
    NSArray *arr = [NSArray arrayWithArray:_dataArray];
    NSString *str = [_userDeft objectForKey:@"selectSTR"];
    NSString *type = [NSString stringWithFormat:@"%@type",str];
    [_userDeft setObject:arr forKey:type];
    [_userDeft synchronize];
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"refresh" object:nil userInfo:@{@"YES":@"refresh"}];
    NSNotification *notification = [NSNotification notificationWithName:@"typeRefresh" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)viewWillAppear:(BOOL)animated{
    [self createData];
}
@end
