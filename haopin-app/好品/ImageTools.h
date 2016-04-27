//
//  ImageTools.h
//  好品
//
//  Created by 朱明科 on 15/12/11.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTools : NSObject
+ (ImageTools *)shareTool;
- (UIImage*)resizeImageToSize:(CGSize)size sizeOfImage:(UIImage*)image;
- (UIImage *)imageWithScreenContentsInView:(UIView *)view;
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
-(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
