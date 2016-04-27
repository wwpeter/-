//
//  PopContentController.h
//  好品
//
//  Created by 朱明科 on 15/12/25.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectBlock)(NSString *string);

@interface PopContentController : UITableViewController

@property(nonatomic,copy)DidSelectBlock didSelectHandler;
-(void)setDidSelectHandler:(DidSelectBlock)didSelectHandler;
@end
