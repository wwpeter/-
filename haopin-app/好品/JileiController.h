//
//  JileiController.h
//  好品
//
//  Created by 朱明科 on 16/1/7.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

typedef void (^HaveSelectRow)(NSString *str);
@interface JileiController : UIViewController

@property(nonatomic,copy)NSString *headTitle;
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *dataArr;
@property(nonatomic)UITableView *tableView;
@property(nonatomic,copy)HaveSelectRow haveSelectRowHandler;
-(void)setHaveSelectRowHandler:(HaveSelectRow)haveSelectRowHandler;
@end
