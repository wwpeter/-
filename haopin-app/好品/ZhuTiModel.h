//
//  ZhuTiModel.h
//  haopin
//
//  Created by ww on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZhuTiModel : NSObject
@property (nonatomic, copy) NSString *detail;//区分是货杆还是主题
@property (nonatomic) UIImage *image;
@property (nonatomic,copy)NSString *year;
@property (nonatomic, copy) NSString *date;
@property(nonatomic,copy)NSString *tag;
@end
