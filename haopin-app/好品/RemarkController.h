//
//  RemarkController.h
//  好品
//
//  Created by 朱明科 on 16/2/25.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
typedef void (^detailBlock)(void);

@interface RemarkController : UIViewController
@property(nonatomic)ClothPhoto *tmpCloth;

@property(nonatomic,copy)detailBlock detailHandler;
-(void)setDetailHandler:(detailBlock)detailHandler;
@end
