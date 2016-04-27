//
//  KTModel.h
//  好品
//
//  Created by 朱明科 on 15/12/29.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KTModel : NSObject
@property(nonatomic,copy)NSString *ktDetail;//KT板的年份+波段
@property(nonatomic,copy)NSString *ktYear;
@property(nonatomic,copy)NSString *ktBod;
@property(nonatomic)UIImage *ktImage;
@end
