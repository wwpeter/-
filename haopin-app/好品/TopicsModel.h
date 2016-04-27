//
//  TopicsModel.h
//  haopin
//
//  Created by 朱明科 on 16/3/18.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TopicsModel : NSObject
@property(nonatomic)double orignX;
@property(nonatomic)double orignY;
@property(nonatomic)double frameWidth;
@property(nonatomic)double frameHeight;
@property(nonatomic)UIImage *image;
@property(nonatomic,copy)NSString *Tag;//tag值记录是哪一个图片
@property(nonatomic,copy)NSString *currentYear;//当前年份
@property(nonatomic,copy)NSString *currentDate;//当前上货周期
@property(nonatomic,copy)NSString *detail;//主题文字
@end
