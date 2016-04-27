//
//  KTBodController.m
//  好品
//
//  Created by 朱明科 on 15/12/29.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "KTBodController.h"

@interface KTBodController ()
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *bodDataArr;
@end

@implementation KTBodController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    self.tableView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    [self createBodData];
}
-(void)createBodData{
    NSString *year = [_userDeft objectForKey:@"selectSTR"];
    self.bodDataArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:year]];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bodDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.bodDataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:62.0/255 green:202.0/255 blue:72.0/255 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"draw"] forState:UIControlStateNormal];
    cell.accessoryView = button;
    if (self.didSelectBodHandler) {
        self.didSelectBodHandler(cell.textLabel.text,indexPath.row);
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryView = nil;
}
@end
