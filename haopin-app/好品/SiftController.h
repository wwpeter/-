//
//  SiftController.h
//  好品
//
//  Created by 朱明科 on 16/1/18.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectedBlock)(NSString *string);
@interface SiftController : UIViewController

@property(nonatomic,copy)DidSelectedBlock didSelectedHandler;
-(void)setDidSelectedHandler:(DidSelectedBlock)didSelectedHandler;
@end
