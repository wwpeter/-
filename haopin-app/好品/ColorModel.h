//
//  ColorModel.h
//  haopin
//
//  Created by ww on 16/3/31.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorModel : NSObject
@property (nonatomic      ) UIImage  *colorImage;//图片
@property (nonatomic, copy) NSString *tag;//tag 去图片
@property (nonatomic, copy) NSString *detail;//加色 or 廓形
@property (nonatomic, copy) NSString *colorID;
@end
