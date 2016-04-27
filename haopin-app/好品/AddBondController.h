//
//  AddBondController.h
//  好品
//
//  Created by 朱明科 on 15/12/28.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackRefreshBlock)(void);

@interface AddBondController : UIViewController

@property(nonatomic)BOOL edit;
@property(nonatomic,copy)NSString *currentBqName;
@property(nonatomic,copy)NSString *currentBqDetail;

@property(nonatomic,copy)BackRefreshBlock backRefreshHandler;
-(void)setBackRefreshHandler:(BackRefreshBlock)backRefreshHandler;
@end
