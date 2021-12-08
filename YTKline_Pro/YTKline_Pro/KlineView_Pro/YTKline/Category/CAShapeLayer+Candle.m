//
//  CAShapeLayer+Candle.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/15.
//

#import "CAShapeLayer+Candle.h"
#import "YTKlineHeader.h"
@implementation CAShapeLayer (Candle)
+(CAShapeLayer *)createCandleLayer:(KlinePointModel *)model width:(CGFloat)width{
    BOOL isincrease = model.close >= model.open;
    
    CGPoint point = CGPointMake(model.x, isincrease ? model.open : model.close);
    CGRect frame = CGRectMake(model.x-width/2, point.y, width, ABS(model.close-model.open));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];;
    
    [path moveToPoint:CGPointMake(model.x, model.low)];
    [path addLineToPoint:CGPointMake(model.x, model.high)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    
    if (model.open >= model.close) {
        layer.strokeColor = [KlineHelper UpColor].CGColor;
        layer.fillColor = [KlineHelper UpColor].CGColor;
    }
    else {
        //不跌
        layer.strokeColor = [KlineHelper DownColor].CGColor;
        layer.fillColor = [KlineHelper DownColor].CGColor;
    }
    
    
    
    return layer;   
}



+(CAShapeLayer *)createSingleLineLayer:(NSArray *)arrPoints lineColor:(UIColor *)color{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
//    BOOL HaveFirstPoint = NO;
    for (int i = 0; i<arrPoints.count; i++) {
        NSString *strPoint = arrPoints[i];
        CGPoint point = CGPointFromString(strPoint);
        if (i==0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.f;
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
    
}

+(CAShapeLayer *)createOneMinuteLine:(NSArray <KlinePointModel *>*)arrPoints oneWid:(CGFloat)width MaxY:(CGFloat)maxY minY:(CGFloat)minY{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    UIBezierPath *path_1 = [UIBezierPath bezierPath];
    path_1.lineWidth = 1.0;
    path_1.lineCapStyle = kCGLineCapRound;
    path_1.lineJoinStyle = kCGLineJoinRound;
    
    KlinePointModel *firstModel = arrPoints.firstObject;
    KlinePointModel *lastModel = arrPoints.lastObject;
    
    CGPoint firstPoint = CGPointMake(firstModel.x, maxY);
    [path moveToPoint:firstPoint];//左下角的点
    [path addLineToPoint:CGPointMake(firstModel.x, firstModel.point.y)];//左侧第一个点
    
    [path_1 moveToPoint:CGPointMake(firstModel.x, firstModel.point.y)];
    
    for (int i = 0; i<arrPoints.count; i++) {
        KlinePointModel *endPtModel = arrPoints[i];
        CGPoint endPt = endPtModel.point;
        if (i==0) {
            [path addLineToPoint:endPt];
            [path_1 addLineToPoint:endPt];
        }else{
            KlinePointModel *startPtModel = arrPoints[i-1];
            CGPoint startPt = startPtModel.point;
            CGPoint cPt1, cPt2;
            cPt1 = (CGPoint){(startPt.x + endPt.x)/2, startPt.y};
            cPt2 = (CGPoint){cPt1.x, endPt.y};

            [path addCurveToPoint:endPt controlPoint1:cPt1 controlPoint2:cPt2];
            [path_1 addCurveToPoint:endPt controlPoint1:cPt1 controlPoint2:cPt2];
        }
        
    }
    
    
    [path addLineToPoint:CGPointMake(lastModel.point.x, maxY)];
    [path addLineToPoint:firstPoint];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path_1.CGPath;
    layer.lineWidth = 1.5;
    layer.strokeColor = [[KlineHelper HilightColor] CGColor];
    layer.fillColor = [UIColor clearColor].CGColor;
    
    CAShapeLayer *layer_1 = [CAShapeLayer layer];
    layer_1.path = path.CGPath;
    [path closePath];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    
    UIColor *redcolor = UIColor.redColor;;
    UIColor *redcolor_1 = UIColor.clearColor;
    
    
    gradientLayer.colors = @[(__bridge id)redcolor.CGColor,(__bridge id)redcolor_1.CGColor];
    gradientLayer.locations = @[@(0),@(1)];
    
    gradientLayer.frame =CGRectMake(firstPoint.x, 0, ABS(lastModel.point.x-firstPoint.x), maxY) ;//
    gradientLayer.mask = layer_1;
    gradientLayer.backgroundColor = UIColor.clearColor.CGColor;
    
    [layer addSublayer:gradientLayer];
    
    
    
    
    return layer;
}

+(CATextLayer *)createRightTextLayer:(NSString *)string txtColor:(UIColor *)colr frame:(CGRect)frame font:(UIFont *)font{
    CATextLayer *textLayer = [CATextLayer layer];;
    textLayer.frame = frame;
    textLayer.foregroundColor = [colr CGColor];
    textLayer.string = [NSString stringWithFormat:@"%@",string];
    textLayer.font = (__bridge CFTypeRef _Nullable)(font);
//    textLayer.
    
    return textLayer;
}

+(CAShapeLayer *)createVolLayer:(CGPoint )point width:(CGFloat)width isIncrease:(BOOL)isUp MaxHeight:(CGFloat)maxHeight{
    
    CGRect frame = CGRectMake(point.x-width/2, point.y, width, maxHeight-ABS(point.y));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];;
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    if (isUp) {
//        layer.strokeColor = [KlineHelper UpColor].CGColor;
        layer.fillColor = [KlineHelper UpColor].CGColor;
    }
    else {
//        layer.strokeColor = [KlineHelper DownColor].CGColor;
        layer.fillColor = [KlineHelper DownColor].CGColor;
    }
    
    return layer;
}
+(CAShapeLayer *)createMACDLayer:(KlineMacdCandleModel* )model width:(CGFloat)width zeroPointY:(CGFloat)zeroPointY{
    
    CGFloat height = ABS(model.point.y-zeroPointY);
    
    CGRect frame = CGRectMake(model.point.x-width/2, model.point.y, width, model.model.MACD > 0 ? height : -height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];;
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    if (model.model.MACD > 0) {
        layer.fillColor = [KlineHelper UpColor].CGColor;
    }else{
        layer.fillColor = [KlineHelper DownColor].CGColor;
    }
    
    return layer;
}

+(CALayer *)HighLowPriceLayerWithString:(NSString *)string direction:(BOOL)isDirectionLeft frame:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor.clearColor CGColor];
    UIImage *image =  [UIImage imageNamed:@"K线箭头左"];
    
    CGSize imageSize = CGSizeMake(22, 12);
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (__bridge id)(image.CGImage);
    imgLayer.backgroundColor = [UIColor.clearColor CGColor];
    
    CATextLayer *textLayer = [CATextLayer layer];
    UIFont *font = [UIFont systemFontOfSize:10];
    
    CGFloat txtWid = [KlineHelper getTxtWid:string font:font];
    textLayer.font = (__bridge CFTypeRef _Nullable)(font);
    textLayer.string = string;
    textLayer.fontSize = 10;
    textLayer.foregroundColor = [UIColor.grayColor CGColor];;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    CGFloat layerHeight = imageSize.height;//layer高度
    CGFloat layerWidth = imageSize.width + txtWid;
    CGFloat X = frame.origin.x;
    CGFloat Y = frame.origin.y - layerHeight/2;;
    if (!isDirectionLeft) {
        X-=layerWidth;
    }
    CGRect rect = CGRectMake(X, Y, layerWidth, layerHeight);
    layer.frame = rect;
    
    
    
    if (isDirectionLeft) {
        imgLayer.frame = CGRectMake(0, (layerHeight-imageSize.height)/2, imageSize.width, imageSize.height);
        textLayer.frame = CGRectMake(imageSize.width, 0, txtWid, layerHeight);
    }else{
        imgLayer.frame = CGRectMake(txtWid , (layerHeight-imageSize.height)/2, imageSize.width, imageSize.height);
        textLayer.frame = CGRectMake(0, 0, txtWid, layerHeight);
        imgLayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }
    
    [layer addSublayer:imgLayer];
    [layer addSublayer:textLayer];
    return layer;
}


+ (CAShapeLayer *)drawDashLine:(CGRect )rect lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:rect];
    [shapeLayer setPosition:CGPointMake(rect.size.width / 2, rect.size.height)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(rect)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(rect), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    return shapeLayer;;
}

+(CATextLayer *)createNewPirceLayer_frame:(CGRect)frame string:(NSString *)string font:(UIFont *)font txtColor:(UIColor *)color backgroundColor:(UIColor *)bgColor fontSize:(NSInteger)fontSize{
    CATextLayer *textLayer = [CATextLayer layer];
    
    textLayer.backgroundColor = [bgColor CGColor];
    textLayer.font = (__bridge CFTypeRef _Nullable)(font);
    textLayer.string = string;
    textLayer.fontSize = fontSize;
    textLayer.foregroundColor = [color CGColor];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.alignmentMode = kCAAlignmentRight;
    textLayer.frame = frame;
    
    return textLayer;
}

+(CATextLayer *)createDateTextLayer:(NSString *)string txtColor:(UIColor *)colr frame:(CGRect)frame font:(UIFont *)font{
    CATextLayer *textLayer = [CATextLayer layer];;
    textLayer.frame = frame;
    textLayer.foregroundColor = [colr CGColor];
    textLayer.string = [NSString stringWithFormat:@"%@",string];
    textLayer.font = (__bridge CFTypeRef _Nullable)(font);
    textLayer.fontSize = 10;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
//    textLayer.
    
    return textLayer;
}

@end
