//
//  RootDeleController.h
//  好品
//
//  Created by 朱明科 on 16/1/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
#define kItemWidth   ([UIScreen mainScreen].bounds.size.width-50)/4
#define kItemHeight 280
@interface RootDeleController : UIViewController

@property(nonatomic,copy)NSString *currentYear;
@property(nonatomic)UIButton *deleteBtn;
@property(nonatomic)UIButton *doneBtn;
@property(nonatomic)NSMutableArray *dataArr;
@property(nonatomic)NSMutableArray *deleArr;

-(void)delet:(UIButton *)button;
-(void)done:(UIButton *)button;
@end
