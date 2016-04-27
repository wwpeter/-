//
//  AddClothController.h
//  好品
//
//  Created by 朱明科 on 15/12/18.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^blockHandler)(NSString *refresh);

@interface AddClothController : UIViewController
@property (nonatomic)NSString *turnBackStr;
@property (nonatomic, copy) blockHandler handler;

- (void)setHandler:(blockHandler)handler;
@end
