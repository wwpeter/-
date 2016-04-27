//
//  ChangeColorController.h
//  haopin
//
//  Created by 朱明科 on 16/3/29.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DoneBlock)(UIImageView *imageView);
@interface ChangeColorController : UIViewController
@property(nonatomic)UIImageView *kImageView;
@property(nonatomic)UIImage *ysImage;
@property(nonatomic)BOOL isAddColor;
@property(nonatomic,copy)DoneBlock doneHandler;

-(void)setDoneHandler:(DoneBlock)doneHandler;
@end
