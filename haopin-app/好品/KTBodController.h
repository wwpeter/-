//
//  KTBodController.h
//  好品
//
//  Created by 朱明科 on 15/12/29.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectBodBlock)(NSString *string,NSInteger num);
@interface KTBodController : UITableViewController

@property(nonatomic,copy)DidSelectBodBlock didSelectBodHandler;
-(void)setDidSelectBodHandler:(DidSelectBodBlock)didSelectBodHandler;
@end
