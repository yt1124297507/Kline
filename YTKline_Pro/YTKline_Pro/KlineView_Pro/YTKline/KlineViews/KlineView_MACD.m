//
//  KlineView_MACD.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import "KlineView_MACD.h"
#import "YTKlineHeader.h"
@interface KlineView_MACD()

@property (nonatomic,retain) NSMutableArray *arrPointMACD;
@property (nonatomic,retain) NSMutableArray *arrPointFast;
@property (nonatomic,retain) NSMutableArray *arrPointLow;

@end

@implementation KlineView_MACD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}


#pragma mark LifeCycle

#pragma mark TableDelegate & DataSource

#pragma mark ScrollViewDelegate

#pragma mark CusMethod
-(void)clearAllLayers{
    for (CALayer *layer in self.layer.sublayers.mutableCopy) {
        [layer removeFromSuperlayer];
    }
}
-(void)modesToPoints{
    if (!_arrNeedDrawModels.count) {
        return;;
    }
    
    
    __block double max = -MAXFLOAT;
    __block double min = MAXFLOAT;
    
    [_arrNeedDrawModels enumerateObjectsUsingBlock:^(YTKlineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model maxMACD] > max) {
            max = [model maxMACD];
        }
        if ([model minMACD] < min) {
            min = [model minMACD];
        }
    }];

    
    
    CGFloat minY = 20;
    CGFloat maxY = self.frame.size.height-5;
    
    if (self.getedRightPricesBlock) {
        self.getedRightPricesBlock([KlineHelper StrFromDouble:max scale:2],
                              0,
                                   [KlineHelper StrFromDouble:min scale:2]);
    }
    
    
    double unit = (max-min)/(maxY-minY);
    if (unit == 0) {
        unit = 1;
    }
    _arrPointMACD = @[].mutableCopy;
    _arrPointLow = @[].mutableCopy;
    _arrPointFast = @[].mutableCopy;
    
    
    CGFloat zeroPointY = ABS(maxY-(0-min)/unit);
    
    
    
    NSInteger startIndex = [_arrNeedDrawModels.firstObject index];
    for (int i = 0; i<_arrNeedDrawModels.count; i++) {
        YTKlineModel *model = _arrNeedDrawModels[i];
        CGFloat X = (startIndex + i) * (_KlineCandleWid + _KlineCandleSpacing) + _KlineCandleWid/2;
        
        {
            CGFloat y = ABS(maxY-(model.MACD-min)/unit);
            CGPoint point = CGPointMake(X, y);

            KlineMacdCandleModel *md = [KlineMacdCandleModel iniwtWithModel:model point:point zeroPoint:CGPointMake(0, zeroPointY)];;
            [_arrPointMACD addObject:md];
            
        }
        {
            CGFloat y = ABS(maxY-(model.MACD_DIF-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index > 1) {
                [_arrPointFast addObject:NSStringFromCGPoint(point)];
            }
            
        }
        {
            CGFloat y = ABS(maxY-(model.MACD_DEA-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index > 1) {
                [_arrPointLow addObject:NSStringFromCGPoint(point)];
            }
        }
        
    }
    
}

-(void)drawAllLinesAndCandle{
    {//清空
        for (CALayer *layer in self.layer.sublayers.mutableCopy) {
            [layer removeFromSuperlayer];
        }
    }
    for (KlineMacdCandleModel *model in _arrPointMACD) {
        CAShapeLayer *layer = [CAShapeLayer createMACDLayer:model width:_KlineCandleWid zeroPointY:model.zeroPoint.y];
        [self.layer addSublayer:layer];

    }
    {
        CAShapeLayer *layer = [CAShapeLayer createSingleLineLayer:_arrPointFast lineColor:[KlineHelper MACDColor_3]];
        [self.layer addSublayer:layer];
    }
    {
        CAShapeLayer *layer = [CAShapeLayer createSingleLineLayer:_arrPointLow lineColor:[KlineHelper MACDColor_4]];
        [self.layer addSublayer:layer];
    }
    
    
}
#pragma mark BtnEvent

#pragma mark NetWorking

#pragma mark ------------------分割线----------------

#pragma mark Setters & Getters

- (void)setArrNeedDrawModels:(NSMutableArray *)arrNeedDrawModels{
    _arrNeedDrawModels= arrNeedDrawModels;
    [self modesToPoints];
    [self drawAllLinesAndCandle];
}
#pragma mark LazyLoad

#pragma mark SetUp & Init


@end
