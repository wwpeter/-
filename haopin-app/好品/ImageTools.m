//
//  ImageTools.m
//  好品
//
//  Created by 朱明科 on 15/12/11.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "ImageTools.h"
#import <QuartzCore/QuartzCore.h>
@implementation ImageTools
static ImageTools *_shareImageTool =nil;
+(ImageTools *)shareTool{
    @synchronized(self){
        if (_shareImageTool == nil) {
            _shareImageTool = [[ImageTools alloc] init];
        }
    }
    return _shareImageTool;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(UIImage *)resizeImageToSize:(CGSize)size sizeOfImage:(UIImage *)image{
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx= UIGraphicsGetCurrentContext();//上下文
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);//重绘
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}
-(UIImage *)imageWithScreenContentsInView:(UIView *)view{
    UIGraphicsBeginImageContext([[UIScreen mainScreen] bounds].size);//根据屏幕大小获取上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    
    UIImage *newimage = nil;
    
    
    
    if (image)
        
    {
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height)
            
        {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else
            
        {
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        
        [image drawInRect:rect];
        
        
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}
@end
