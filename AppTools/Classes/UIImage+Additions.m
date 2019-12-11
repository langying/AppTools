//
//  UIImage+Additions.m
//  TBSport
//
//  Created by 赵敏行 on 15-4-9.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "UIImage+Additions.h"

typedef unsigned char  uchar;

@implementation UIImage (Additions)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (id)_wallPager {
    Class clazz  = NSClassFromString(@"PLStaticWallpaperImageViewController");
    id wallpager = [[clazz alloc] performSelector:NSSelectorFromString(@"initWithUIImage:") withObject:self];
    [wallpager setValue:@(YES) forKeyPath:@"allowsEditing"];
    [wallpager setValue:@(YES) forKeyPath:@"saveWallpaperData"];
    return wallpager;
}
- (void)_setHomeScreen {
    [self._wallPager performSelector:@selector(setImageAsHomeScreenClicked:) withObject:nil];
}
- (void)_setLockScreen {
    [self._wallPager performSelector:@selector(setImageAsLockScreenClicked:) withObject:nil];
}
- (void)_setHomeAndLockScreen {
    [self._wallPager performSelector:@selector(setImageAsHomeScreenAndLockScreenClicked:) withObject:nil];
}
#pragma clang diagnostic pop

- (UIImage*)orientationFixedImage{
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        
        switch (self.imageOrientation) {
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, self.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
        }
        
        switch (self.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledCompress:(CGFloat)scaledCompress {
    if (scaledCompress >= 1) {
        return image;
    }
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaledCompress, image.size.height * scaledCompress));
    // new size
    [image drawInRect:CGRectMake(0,0,image.size.width * scaledCompress,image.size.height * scaledCompress)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


+ (UIImage*)rectImage:(CGSize)size backgroundColor:(UIColor*)bgColor cornerRadius:(float)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    UIImage *image = [[UIImage alloc] init];
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    [bgColor set];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius / 2.0] addClip];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    [image drawInRect:rect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
@end
