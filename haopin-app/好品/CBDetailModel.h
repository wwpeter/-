//
//  CBDetailModel.h
//  haopin
//
//  Created by 朱明科 on 16/3/2.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CBDetailModel : NSObject
@property(nonatomic)double orignX;
@property(nonatomic)double orignY;
@property(nonatomic)double frameWidth;
@property(nonatomic)double frameHeight;
@property(nonatomic)UIImage *image;
@property(nonatomic,copy)NSString *detailTag;
@property(nonatomic,copy)NSString *detailYear;//年份
@property(nonatomic,copy)NSString *detailBod;//波段
@property(nonatomic,copy)NSString *vvID;
@end
