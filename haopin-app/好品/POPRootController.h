//
//  POPRootController.h
//  好品
//
//  Created by 朱明科 on 16/1/13.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectBlock)(NSString *string);

@interface POPRootController : UITableViewController

@property(nonatomic)NSArray *dataArray;
@property(nonatomic,copy)DidSelectBlock didSelectHandler;

-(void)setDidSelectHandler:(DidSelectBlock)didSelectHandler;
@end
