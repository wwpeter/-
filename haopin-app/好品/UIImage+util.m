//
//  UIImage+util.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "UIImage+util.h"

@implementation UIImage (util)

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    UIGraphicsBeginImageContext(newsize);
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
