//
//  SudokuViewController.h
//  SudokuDemo
//
//  Created by Yorke on 15/3/11.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGesture @"Gesture"

typedef NS_ENUM(NSInteger, WTSudokuViewType) {
    WTSudokuViewTypeSetting = 1,//设置密码
    WTSudokuViewTypeVerity//验证密码
};

@interface SudokuViewController : UIViewController

@property (nonatomic, assign) WTSudokuViewType type;

@end
