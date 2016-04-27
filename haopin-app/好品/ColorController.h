//
//  ColorController.h
//  haopin
//
//  Created by 朱明科 on 16/4/8.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DoneBlock)(UIImageView *imageView);
@interface ColorController : UIViewController

@property(nonatomic)UIImageView *kImageView;
@property(nonatomic)UIImage *ysImage;
@property(nonatomic)BOOL isAddColor;
@property(nonatomic,copy)DoneBlock doneHandler;

-(void)setDoneHandler:(DoneBlock)doneHandler;
@end
