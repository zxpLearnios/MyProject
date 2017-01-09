//
//  QRCodeImage.m
//  QRCode
//
//  Copyright © 2015年 ST. All rights reserved.
//

#import "QRCodeImage.h"



@implementation QRCodeImage

/// 1
+ (QRCodeImage *)createQrCodeImageWithString:(NSString *)string
                                size:(CGFloat)width
{
    CIImage *ciImage = [QRCodeImage createQRForString:string];
    if (ciImage) {
        return [QRCodeImage creatNonInterpolatedUIImageFormCIImage:ciImage
                                                               size:width];
    } else {
        return nil;
    }
}


/// 2
+ (QRCodeImage *_Nonnull)createQrCodeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                       qrColor:(UIColor *_Nullable)qrColor isHaveWhiteBg:(BOOL)isWhiteBg
{
    
    
//    QRCodeImage *paramImg =  [QRCodeImage creatCodeImageWithString:string size:width];
//    CIImage *ciImg = [[CIImage alloc] initWithImage:paramImg];
//     QRCodeImage *image = [QRCodeImage creatNonInterpolatedUIImageFormCIImage:ciImg  size:width];
    QRCodeImage *image =  [QRCodeImage createQrCodeImageWithString:string size:width];
 
    
    // 二维码实体颜色
    const CGFloat *components = CGColorGetComponents(qrColor.CGColor);
    CGFloat red     = components[0]*255;
    CGFloat green   = components[1]*255;
    CGFloat blue    = components[2]*255;
    
    
    const int imageWidth    = image.size.width;
    const int imageHeight   = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf   = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 1.创建上下文
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 2.像素转换
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    // 遍历像素
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;

        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        
    }
    
    // 3.生成UIImage
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL,
                                                                  rgbImageBuf,
                                                                  bytesPerRow * imageHeight,
                                                                  ProviderReleaseData);
    
    // kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little (生成有白底的图片); kCGImageAlphaLast | kCGBitmapByteOrder32Little（生成无白底的图片）； kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big（生成蓝绿色底的图片）； （kCGImageAlphaLast\kCGImageAlphaFirst） | kCGBitmapByteOrder16Little (会造成二维码无法识别的),
    
    
    CGImageRef imageRef = nil;
    if (isWhiteBg) {
        imageRef = CGImageCreate(imageWidth,
                      imageHeight,
                      8,
                      32,
                      bytesPerRow,
                      colorSpace,
                      kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little,
                      dataProvider,
                      NULL,
                      true,
                      kCGRenderingIntentDefault);
    }else{
        
        imageRef = CGImageCreate(imageWidth,
                                 imageHeight,
                                 8,
                                 32,
                                 bytesPerRow,
                                 colorSpace,
                                 kCGImageAlphaLast | kCGBitmapByteOrder32Little,
                                 dataProvider,
                                 NULL,
                                 true,
                                 kCGRenderingIntentDefault);
    }
    
    CGDataProviderRelease(dataProvider);
    QRCodeImage *resultUIImage = (QRCodeImage *)[UIImage imageWithCGImage:imageRef];
    
    // 4.释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return  resultUIImage;
}

/// 3
+(QRCodeImage *)createQrCodeImageWithString:(NSString *)string size:(CGFloat)width qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor{

    
    QRCodeImage *image =  [QRCodeImage createQrCodeImageWithString:string size:width];
    
    // 二维码实体颜色
    const CGFloat *components = CGColorGetComponents(qrColor.CGColor);
    CGFloat red     = components[0]*255;
    CGFloat green   = components[1]*255;
    CGFloat blue    = components[2]*255;
    
    // 二维码底色\背景色
    
    const CGFloat *bgComponents = CGColorGetComponents(bgColor.CGColor);
    CGFloat bgRed     = bgComponents[0]*255;
    CGFloat bgGreen   = bgComponents[1]*255;
    CGFloat bgBlue    = bgComponents[2]*255;
    
    
    
    const int imageWidth    = image.size.width;
    const int imageHeight   = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf   = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 1.创建上下文
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 2.像素转换
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    // 遍历像素
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
            
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            // 改变底色
            ptr[3] = bgRed; //0~255
            ptr[2] = bgGreen;
            ptr[1] = bgBlue;
            
            // 改变底色1
            //            ptr[0] = 0;
        }
        
    }
    
    // 3.生成UIImage
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL,
                                                                  rgbImageBuf,
                                                                  bytesPerRow * imageHeight,
                                                                  ProviderReleaseData);
    
    // kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little (生成有白底的图片); kCGImageAlphaLast | kCGBitmapByteOrder32Little（生成无白底的图片）； kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big（生成蓝绿色底的图片）； （kCGImageAlphaLast\kCGImageAlphaFirst） | kCGBitmapByteOrder16Little (会造成二维码无法识别的),
    
    
    CGImageRef imageRef = imageRef = CGImageCreate(imageWidth,
                                                   imageHeight,
                                                   8,
                                                   32,
                                                   bytesPerRow,
                                                   colorSpace,
                                                   kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little,
                                                   dataProvider,
                                                   NULL,
                                                   true,
                                                   kCGRenderingIntentDefault);;
    
    
    CGDataProviderRelease(dataProvider);
    QRCodeImage *resultUIImage = (QRCodeImage *)[UIImage imageWithCGImage:imageRef];
    
    // 4.释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return  resultUIImage;
}

+ (QRCodeImage *_Nonnull)createQrCodeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                       qrColor:(UIColor *_Nullable)qrColor
                                        icon:(UIImage *_Nullable)icon
                                    iconWidth:(CGFloat)iconWidth  isHaveWhiteBg:(BOOL)isWhiteBg;
{
    QRCodeImage *bgImage = [QRCodeImage createQrCodeImageWithString:string
                                                       size:width
                                                      qrColor:qrColor isHaveWhiteBg:isWhiteBg];
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    CGFloat x = (bgImage.size.width - iconWidth) * 0.5;
    CGFloat y = (bgImage.size.height - iconWidth) * 0.5;
    [icon drawInRect:CGRectMake( x,  y, iconWidth,  iconWidth)];
    
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (QRCodeImage *)newImage;
}


+(QRCodeImage *)createQrCodeImageWithString:(NSString *)string size:(CGFloat)width qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor icon:(UIImage *)icon iconWidth:(CGFloat)iconWidth{
    QRCodeImage *bgImage = [QRCodeImage createQrCodeImageWithString:string size:width qrColor:qrColor bgColor:bgColor];
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    CGFloat x = (bgImage.size.width - iconWidth) * 0.5;
    CGFloat y = (bgImage.size.height - iconWidth) * 0.5;
    [icon drawInRect:CGRectMake( x,  y, iconWidth,  iconWidth)];
    
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (QRCodeImage *)newImage;
}

// -----------  private ------------ //
+ (QRCodeImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image
size:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent),
                        size/CGRectGetHeight(extent));
    // 1.创建一个位图图像，绘制到其大小的位图上下文
    size_t width        = CGRectGetWidth(extent) * scale;
    size_t height       = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs  = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   cs,
                                                   (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context     = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.创建具有内容的位图图像
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // 3.清理
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return (QRCodeImage*)[UIImage imageWithCGImage:scaledImage];
}

+ (CIImage *)createQRForString:(NSString *)qrString {
    // 1.将字符串转换为UTF8编码的NSData对象
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 2.创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 3.设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"]; // M H
    // 4.返回CIImage
    return qrFilter.outputImage;
}


void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

@end
