//
//  ClothPhoto.h
//  好品
//
//  Created by 朱明科 on 15/12/14.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClothPhoto : NSObject

@property(nonatomic,copy)NSString *ind;
@property(nonatomic,copy)NSString *year;
@property(nonatomic,copy)NSString *type;//类型
@property(nonatomic,copy)NSString *bod;//波段
@property(nonatomic,copy)NSString *color;//颜色->打样
@property(nonatomic,copy)NSString *pinkuan;//评款
@property(nonatomic,copy)NSString *price;//价格
@property(nonatomic,copy)NSString *designor;//设计师
@property(nonatomic)UIImage *image;
@property(nonatomic)UIImage *backImage;
@end
