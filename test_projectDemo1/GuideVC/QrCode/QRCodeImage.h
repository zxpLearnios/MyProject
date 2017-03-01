//
//  QRCodeImage.h
//  QRCode
//
//  Copyright zjn © 2015年 ST. All rights reserved.
//  最全的二维码生成
// 彩色二维码生成, 二维码的颜色底色皆可自定义   OC版 ，目前swift3照此写还是有问题

#import <UIKit/UIKit.h>

@interface QRCodeImage : UIImage

/**
 *  1.生成一个普通的二维码(白底黑内容)
 *
 *  @param string 字符串
 *  @param width  二维码宽度
 *
 *  @return <#return value description#>
 */
+ (QRCodeImage *_Nonnull)createQrCodeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width;

/**
 *  2.生成一个颜色二维码(外部定有无白底)。
 *
 *  @param string 字符串
 *  @param width  二维码宽度
 *  @param color  二维码颜色
 *  @param isHaveWhiteBg  是否显示白底
 */
+ (QRCodeImage *_Nonnull)createQrCodeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                            qrColor:(UIColor *_Nullable)qrColor isHaveWhiteBg:(BOOL)isWhiteBg;


/**
 *  3.生成一个颜色二维码。
 *
 *  @param string 字符串
 *  @param width  二维码宽度
 *  @param color  二维码颜色
 *  @param bgColor  底色
 */
+ (QRCodeImage *_Nonnull)createQrCodeImageWithString:(NSString *_Nullable)string
                                               size:(CGFloat)width
                                              qrColor:(UIColor *_Nullable)qrColor bgColor:(UIColor *_Nullable)bgColor;


/**
 *  4.生成一个二维码,中间有Icon
 *
 *  @param string    字符串
 *  @param width     二维码宽度
 *  @param color     二维码颜色
 *  @param icon      头像
 *  @param iconWidth 头像宽度，建议宽度小于二维码宽度的1/4
 *
 *  @return <#return value description#>
 */
+ (QRCodeImage *_Nonnull)createQrCodeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                       qrColor:(UIColor *_Nullable)qrColor
                                        icon:(UIImage *_Nullable)icon
                                   iconWidth:(CGFloat)iconWidth isHaveWhiteBg:(BOOL)isWhiteBg;


/**
 *  5.生成一个二维码, 中间有Icon
 *
 *  @param string    字符串
 *  @param width     二维码宽度
 *  @param color     二维码颜色
 *  @param bgColor  底色
 *  @param icon      头像
 *  @param iconWidth 头像宽度，建议宽度小于二维码宽度的1/4
 *
 *  @return <#return value description#>
 */
+ (QRCodeImage *_Nonnull)createQrCodeImageWithString:(NSString *_Nullable)string
                                                size:(CGFloat)width
                                             qrColor:(UIColor *_Nullable)qrColor bgColor:(UIColor *)bgColor
                                                icon:(UIImage *_Nullable)icon
                                           iconWidth:(CGFloat)iconWidth;

@end
