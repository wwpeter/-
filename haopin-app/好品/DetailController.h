//
//  DetailController.h
//  好品
//
//  Created by 朱明科 on 15/12/22.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClothPhoto.h"

typedef void(^refreshUIBlock)(void);
@interface DetailController : UIViewController
@property(nonatomic,copy)refreshUIBlock refreshHandler;

@property(nonatomic)NSMutableArray *photoModelArray;
@property(nonatomic)ClothPhoto *cloth;
@property (nonatomic) BOOL detailBool;
-(void)setRefreshHandler:(refreshUIBlock)refreshHandler;
@end
