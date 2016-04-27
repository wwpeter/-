//
//  ChooseController.m
//  haopin
//
//  Created by 朱明科 on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ChooseController.h"

#define kWidth self.view.frame.size.width-600
#define kHeight self.view.frame.size.height
@interface ChooseController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *dataArr;
@property(nonatomic,copy)NSString *year;
@property (nonatomic) BOOL select;
@property (nonatomic) NSMutableArray *selectArray;
@property(nonatomic,copy)NSString *string;
@end

@implementation ChooseController
- (NSMutableArray *)selectArray {
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
   return _selectArray;
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userDeft = [NSUserDefaults standardUserDefaults];
    self.year = [_userDeft objectForKey:@"selectSTR"];
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    [self createData];
    [self createUI];
}
-(void)createData{
    self.dataArr = [_userDeft objectForKey:self.year];
    NSString *str = [NSString stringWithFormat:@"%@panduan",self.year];
    self.selectArray = [_userDeft objectForKey:str];
}
-(void)createUI{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(1,1, 80, 40);
    //[cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor greenColor]];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    //[cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(kWidth-81, 1, 80, 40);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTintColor:[UIColor greenColor]];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [doneBtn setBackgroundColor:[UIColor whiteColor]];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 1, kWidth-160, 40)];
    headLabel.backgroundColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.text = @"请选择上货周期";
    headLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:headLabel];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(1, 45, kWidth-2, 500) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UIView *bottomView = [[UIView alloc]init];
    tableView.tableFooterView = bottomView;
    [self.view addSubview:tableView];
}
-(void)cancel:(UIButton *)button{
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
}
-(void)done:(UIButton *)button{
    if (self.select) {
        [self.view removeFromSuperview];
        [self willMoveToParentViewController:nil];
        [self removeFromParentViewController];
        NSMutableArray *mutabelArr = [NSMutableArray arrayWithArray:_selectArray];
        [mutabelArr addObject:_string];
        NSArray *array = [NSArray arrayWithArray:mutabelArr];
        NSString *str = [NSString stringWithFormat:@"%@panduan",self.year];
        [_userDeft setObject:array forKey:str];
    } else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择上货周期" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark - tableview dele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSArray *arr = self.dataArr[indexPath.row];
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@-%@",arr[1],arr[2]];
    cell.textLabel.text = string;
    cell.detailTextLabel.text = arr[0];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = [NSString stringWithFormat:@"%@-%@%@",arr[1],arr[2],arr[0]];
    for (NSInteger i = 0; i <_selectArray.count; i++) {
        if ([str isEqualToString:self.selectArray[i]]) {
              cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.selected = NO;
            cell.userInteractionEnabled = NO;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
    cell.detailTextLabel.textColor = [UIColor greenColor];
    NSMutableString *mutString = [NSMutableString stringWithFormat:@"%@%@",cell.textLabel.text,cell.detailTextLabel.text];
    _string = [NSString stringWithString:mutString];
    BOOL selected = YES;
    self.select = YES;
    if (self.selectHandler) {
        self.selectHandler(_string,selected);
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = nil;
    cell.detailTextLabel.textColor = nil;
}
@end
