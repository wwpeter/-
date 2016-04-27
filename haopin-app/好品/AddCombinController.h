//
//  AddCombinController.h
//  好品
//
//  Created by 朱明科 on 15/12/23.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^editCombinBlock)(void);

@interface AddCombinController : UIViewController
@property(nonatomic)BOOL edit;
@property(nonatomic,copy)NSString *currentCombinDetail;
@property(nonatomic,copy)NSString *curentCombinName;

@property(nonatomic,copy)editCombinBlock editCombinHandler;
-(void)setEditCombinHandler:(editCombinBlock)editCombinHandler;
@end
