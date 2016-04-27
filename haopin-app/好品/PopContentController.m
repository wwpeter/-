//
//  PopContentController.m
//  好品
//
//  Created by 朱明科 on 15/12/25.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "PopContentController.h"

@interface PopContentController ()
@property(nonatomic)NSArray *dataArray;
@end

@implementation PopContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"保存",@"不保存"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArray[indexPath.row];
    if (self.didSelectHandler) {
        self.didSelectHandler(str);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
