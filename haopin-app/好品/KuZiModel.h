//
//  KuZiModel.h
//  haopin
//
//  Created by ww on 16/3/25.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KuZiModel : NSObject
@property(nonatomic)UIImage *image;
@property(nonatomic,copy)NSString *currentYear;//当前年份
@property(nonatomic,copy)NSString *currentDate;//当前上货周期
@property(nonatomic,copy)NSString *detailTag;//tag值记录是哪一个图片
@end
