//
//  ChooseController.h
//  haopin
//
//  Created by 朱明科 on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectBlack)(NSString *str , BOOL chosed);
@interface ChooseController : UIViewController

@property(nonatomic,copy)DidSelectBlack selectHandler;
-(void)setSelectHandler:(DidSelectBlack)selectHandler;
@end
