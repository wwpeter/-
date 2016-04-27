//
//  POPRootController.m
//  好品
//
//  Created by 朱明科 on 16/1/13.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "POPRootController.h"

@interface POPRootController ()

@end

@implementation POPRootController

- (void)viewDidLoad {
    [super viewDidLoad];

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
}
@end
