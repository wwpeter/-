//
//  ZhuTiController.h
//  haopin
//
//  Created by ww on 16/3/28.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuTiController : UIViewController
@property(nonatomic,copy)NSString *currentData;//当前的上货周期
@property(nonatomic,copy)NSString *currentGan;//当前的杆
@property(nonatomic,copy)NSString *currentYear;//当前的年份
@property(nonatomic,copy)NSString *yearAndDate;//年份+上货周期(为了存储杆数)
@end
