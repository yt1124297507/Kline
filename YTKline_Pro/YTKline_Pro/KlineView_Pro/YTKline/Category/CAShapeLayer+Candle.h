//
//  CAShapeLayer+Candle.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/15.
//

#import <QuartzCore/QuartzCore.h>
#import "YTKlineHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAShapeLayer (Candle)

/// 根据model绘制出蜡烛图
/// @param model model description
/// @param width width description
+(CAShapeLayer *)createCandleLayer:(KlinePointModel *)model width:(CGFloat)width;


/// 根据数据绘制一条直线
/// @param arrPoints arrPoints description
/// @param color color description
+(CAShapeLayer *)createSingleLineLayer:(NSArray *)arrPoints lineColor:(UIColor *)color;

+(CAShapeLayer *)createOneMinuteLine:(NSArray <KlinePointModel *>*)arrPoints oneWid:(CGFloat)width MaxY:(CGFloat)maxY minY:(CGFloat)minY;

+(CATextLayer *)createRightTextLayer:(NSString *)string txtColor:(UIColor *)colr frame:(CGRect)frame font:(UIFont *)font;

/// 画成交量图
/// @param point point description
/// @param width width description
/// @param isUp width description
/// @param maxHeight maxHeight description
+(CAShapeLayer *)createVolLayer:(CGPoint )point width:(CGFloat)width isIncrease:(BOOL)isUp MaxHeight:(CGFloat)maxHeight;

+(CAShapeLayer *)createMACDLayer:(KlineMacdCandleModel* )model width:(CGFloat)width zeroPointY:(CGFloat)zeroPointY;

///创建箭头指向价格的layer
+(CALayer *)HighLowPriceLayerWithString:(NSString *)string direction:(BOOL)isDirectionLeft frame:(CGRect)frame;


/// 画虚线
/// @param rect rect description
/// @param lineLength lineLength description
/// @param lineSpacing lineSpacing description
/// @param lineColor lineColor description
+ (CAShapeLayer *)drawDashLine:(CGRect )rect lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

+(CATextLayer *)createNewPirceLayer_frame:(CGRect)frame string:(NSString *)string font:(UIFont *)font txtColor:(UIColor *)color backgroundColor:(UIColor *)bgColor fontSize:(NSInteger)fontSize;

+(CATextLayer *)createDateTextLayer:(NSString *)string txtColor:(UIColor *)colr frame:(CGRect)frame font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
