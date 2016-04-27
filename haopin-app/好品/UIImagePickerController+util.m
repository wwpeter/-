//
//  UIImagePickerController+util.m
//  好品
//
//  Created by 朱明科 on 15/12/17.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "UIImagePickerController+util.h"

@implementation UIImagePickerController (util)
- (BOOL)shouldAutorotate{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
