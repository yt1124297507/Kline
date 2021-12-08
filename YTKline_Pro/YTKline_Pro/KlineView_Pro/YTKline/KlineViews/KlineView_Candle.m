//
//  KlineView_Candle.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import "KlineView_Candle.h"
#import "CAShapeLayer+Candle.h"
@interface KlineView_Candle()


@property (nonatomic,retain) UIImageView *imgKlineLogo;

@property (nonatomic,retain) NSMutableArray <KlinePointModel *>*arrCandlePoints;

@property (nonatomic,retain) NSMutableArray *arrOneMinute;

@property (nonatomic,retain) NSMutableArray *arrMA1;
@property (nonatomic,retain) NSMutableArray *arrMA2;
@property (nonatomic,retain) NSMutableArray *arrMA3;

@property (nonatomic,retain) NSMutableArray *arrEMA1;
@property (nonatomic,retain) NSMutableArray *arrEMA2;
@property (nonatomic,retain) NSMutableArray *arrEMA3;

@property (nonatomic,retain) NSMutableArray *arrUP;
@property (nonatomic,retain) NSMutableArray *arrMB;
@property (nonatomic,retain) NSMutableArray *arrDN;

@property (nonatomic,assign) CGPoint maxPoint;
@property (nonatomic,assign) CGPoint minPoint;

@property (nonatomic,retain) NSString *strMaxPrice;
@property (nonatomic,retain) NSString *strMinPrice;

@property (nonatomic,assign) CGRect MaxMinRect;//self.MaxMinRect = CGRectMake(maxY, minY, max, min);

@property (nonatomic,retain) CALayer *layerNewPrice;

@end

@implementation KlineView_Candle


#pragma mark LifeCycle


- (void)layoutSubviews{
    CGRect frame = self.bounds;
    _drawCandleView.frame = CGRectMake(0, 30, frame.size.width, frame.size.height-35);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubViews];

    }
    return self;
}
-(void)addSubViews{
    
    UIImageView *imgLogo= [UIImageView new];
    _imgKlineLogo = imgLogo;
    [self addSubview:imgLogo];
    
    
    _drawCandleView = [UIView new];
    _drawCandleView.backgroundColor = UIColor.clearColor;
    [self addSubview:_drawCandleView];
    
}

#pragma mark TableDelegate & DataSource

#pragma mark ScrollViewDelegate

#pragma mark CusMethod

-(void)clearAllLayers{
    for (CALayer *layer in self.drawCandleView.layer.sublayers.mutableCopy) {
        if ([layer isEqual:_layerNewPrice]) {
            continue;
        }
        if (layer.superlayer) {
            [layer removeFromSuperlayer];
        }
        
    }
    if (_layerNewPrice.superlayer) {
        [_layerNewPrice removeFromSuperlayer];
        _layerNewPrice = nil;
    }
}

-(CGPoint)pointFromModel:(YTKlineModel *)model{
    
    if (_isOneMinuteModel) {
        for (KlinePointModel *ptModel in _arrOneMinute) {
            if (model.index==ptModel.index) {
                return ptModel.point;
            }
        }
    }else{
        for (KlinePointModel *ptModel in _arrCandlePoints.mutableCopy) {
            if (model.index==ptModel.index) {
                return CGPointMake(ptModel.x, ptModel.close);
            }
        }
    }
    
    return CGPointZero;
}

-(void)updateNewPriceLayer:(YTKlineModel *)model newPriceModelX:(CGFloat)newPriceX isWeakLeft:(BOOL)isWeakLeft scrollView:(UIScrollView *)scMain{

    
    
    
    _imgKlineLogo.frame = CGRectMake(scMain.contentOffset.x + 15, self.frame.size.height-26-15, 97, 26);
    
    double maxY = _MaxMinRect.origin.x;
    double minY = _MaxMinRect.origin.y;
    double max = _MaxMinRect.size.width;
    double min = _MaxMinRect.size.height;
    double unit = (max-min)/(maxY-minY);;
    if (unit==0) {
        unit=1;
    }
    
//    ABS(maxY-(model.high.doubleValue-min)/unit);
    CGFloat newPriceClose;
    CGPoint newPricePoint = CGPointZero;;
    if (model.close.doubleValue >= max) {
        newPriceClose = max;
    }else if(model.close.doubleValue <= min){
        newPriceClose = min;
    }else{
        newPriceClose = model.close.doubleValue;
    }
    
    newPricePoint.y = ABS(maxY-(newPriceClose-min)/unit);
    
    if (_layerNewPrice.superlayer) {
        [_layerNewPrice removeFromSuperlayer];
        _layerNewPrice = nil;
    }
    
    
    CAShapeLayer *weaklayer;
    BOOL isIncrease = model.close.doubleValue > model.open.doubleValue;
    UIColor *weakLineColor = isIncrease ? [KlineHelper UpColor] : [KlineHelper DownColor];
    
    if (isWeakLeft) {
        weaklayer = [CAShapeLayer drawDashLine:CGRectMake(0, 0, newPriceX, 0.5) lineLength:6 lineSpacing:2 lineColor:weakLineColor];
        weaklayer.frame = CGRectMake(0, 0, newPriceX, 0.5);
    }else{
        weaklayer = [CAShapeLayer drawDashLine:CGRectMake(0, 0, 1000, 0.5) lineLength:6 lineSpacing:2 lineColor:weakLineColor];
        weaklayer.frame = CGRectMake(newPriceX, 0, 1000, 0.5);
    }
    
    UIFont *font = [UIFont systemFontOfSize:10];
    NSString *string = model.close;
    CGFloat txtWid = [KlineHelper getTxtWid:string font:font];
    CGRect frame = CGRectMake(scMain.contentOffset.x+scMain.frame.size.width-txtWid, -7, txtWid, 12);;
    
    UIColor *txtColor = [KlineHelper HilightColor];
    UIColor *bgColor = [KlineHelper backgroundColor];
    
    CATextLayer *txtlayer = [CAShapeLayer createNewPirceLayer_frame:frame string:string font:font txtColor:txtColor backgroundColor:bgColor fontSize:10.0];
    
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, newPricePoint.y, self.frame.size.width, 12);
    
    [layer addSublayer:weaklayer];
    [layer addSublayer:txtlayer];
    
    _layerNewPrice = layer;
    
    [self.drawCandleView.layer addSublayer:layer];
    
}


/// 画线 画蜡烛
-(void)drawAllLinesAndCandle{
    {//清空
        for (CALayer *layer in self.drawCandleView.layer.sublayers.mutableCopy) {
            if ([layer isEqual:_layerNewPrice]) {
                continue;
            }
            [layer removeFromSuperlayer];
        }
    }
    
    if (_isOneMinuteModel) {
        CAShapeLayer *layer = [CAShapeLayer createOneMinuteLine:_arrOneMinute oneWid:_KlineCandleWid MaxY:self.drawCandleView.frame.size.height minY:_MaxMinRect.origin.y];;
        [self.drawCandleView.layer addSublayer:layer];
    }else{
        for (KlinePointModel *model in _arrCandlePoints) {
            CAShapeLayer *layerCandle = [CAShapeLayer createCandleLayer:model width:_KlineCandleWid];
            [self.drawCandleView.layer addSublayer:layerCandle];
        }
        
        
        KLineIndicatorModel *kIndicatorModel =  KlineHelper.shared.kLineIndicator;
        
        switch (_y_stockChartType) {
            case Y_StockChartType_None:{
                
            }break;
            case Y_StockChartType_MA:{
                
                CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrMA1 lineColor:[KlineHelper MAColor_1]];
                CAShapeLayer *layer2 = [CAShapeLayer createSingleLineLayer:_arrMA2 lineColor:[KlineHelper MAColor_2]];
                CAShapeLayer *layer3 = [CAShapeLayer createSingleLineLayer:_arrMA3 lineColor:[KlineHelper MAColor_3]];
                
                if (kIndicatorModel.selectMA_1) {
                    [self.drawCandleView.layer addSublayer:layer1];
                }
                if (kIndicatorModel.selectMA_2) {
                    [self.drawCandleView.layer addSublayer:layer2];
                }
                if (kIndicatorModel.selectMA_3) {
                    [self.drawCandleView.layer addSublayer:layer3];
                }
                
                
            }break;
            case Y_StockChartType_EMA:{
                
                CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrEMA1 lineColor:[KlineHelper EMAColor_1]];
                CAShapeLayer *layer2 = [CAShapeLayer createSingleLineLayer:_arrEMA2 lineColor:[KlineHelper EMAColor_2]];
                CAShapeLayer *layer3 = [CAShapeLayer createSingleLineLayer:_arrEMA3 lineColor:[KlineHelper EMAColor_3]];
                
                if (kIndicatorModel.selectEMA_1) {
                    [self.drawCandleView.layer addSublayer:layer1];
                }
                if (kIndicatorModel.selectEMA_2) {
                    [self.drawCandleView.layer addSublayer:layer2];
                }
                if (kIndicatorModel.selectEMA_3) {
                    [self.drawCandleView.layer addSublayer:layer3];
                }
                
            }break;
            case Y_StockChartType_BOLL:{
                CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrUP lineColor:[KlineHelper BOLLColor_2]];
                CAShapeLayer *layer2 = [CAShapeLayer createSingleLineLayer:_arrMB lineColor:[KlineHelper BOLLColor_1]];
                CAShapeLayer *layer3 = [CAShapeLayer createSingleLineLayer:_arrDN lineColor:[KlineHelper BOLLColor_3]];
                
                [self.drawCandleView.layer addSublayer:layer1];
                [self.drawCandleView.layer addSublayer:layer2];
                [self.drawCandleView.layer addSublayer:layer3];
            }break;
                
            default:
                break;
        }
        {
            
            YTKlineModel *firstModel = _arrNeedDrawModels.firstObject;
            CGFloat first_X = (firstModel.index + 1)*(_KlineCandleWid + _KlineCandleSpacing)-_KlineCandleWid/2;
            
            
            {
                BOOL isLeftDirection = (_maxPoint.x - first_X) < 150;
                CGRect maxFrame = CGRectMake(_maxPoint.x, _maxPoint.y, 50, 10);
                CALayer *layer = [CAShapeLayer HighLowPriceLayerWithString:_strMaxPrice direction:isLeftDirection frame:maxFrame];
                [self.drawCandleView.layer addSublayer:layer];
            }
            
            {
                BOOL isLeftDirection = (_minPoint.x - first_X) < 150;
                CGRect minFrame = CGRectMake(_minPoint.x, _minPoint.y, 50, 10);
                CALayer *layer = [CAShapeLayer HighLowPriceLayerWithString:_strMinPrice direction:isLeftDirection frame:minFrame];;
                [self.drawCandleView.layer addSublayer:layer];
            }
        }
    }
    

    
}

-(void)modesToPoints{
    if (!_arrNeedDrawModels.count) {
        return;;
    }
    __block double max = 0;
    __block double min = MAXFLOAT;
    
    __block YTKlineModel * maxPriceModel = _arrNeedDrawModels.firstObject;
    __block YTKlineModel * minPriceModel = _arrNeedDrawModels.firstObject;
    [_arrNeedDrawModels enumerateObjectsUsingBlock:^(YTKlineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        {//找最大最小model
            if (model.high.doubleValue > maxPriceModel.high.doubleValue) {
                maxPriceModel = model;
            }
            if (model.low.doubleValue < minPriceModel.low.doubleValue) {
                minPriceModel = model;
            }
            
        }
        if (_isOneMinuteModel) {
            if (model.close.doubleValue > max) {
                max = model.close.doubleValue;
            }
            if (model.close.doubleValue < min) {
                min = model.close.doubleValue;
            }
        }else{
            if (model.high.doubleValue > max) {
                max = model.high.doubleValue;
            }
            if (model.low.doubleValue < min) {
                min = model.low.doubleValue;
            }
            switch (self.y_stockChartType) {
                case Y_StockChartType_None:{
                    
                }break;
                case Y_StockChartType_MA:{
                    if ([model maxMA] > max) {
                        max = [model maxMA];
                    }
                    if ([model minMA] < min) {
                        if ([model minMA]!=0) {
                            min = [model minMA];
                        }
                    }
                }break;
                case Y_StockChartType_EMA:{
                    if ([model maxEMA] > max) {
                        max = [model maxEMA];
                    }
                    if ([model minEMA] < min) {
                        if ([model minEMA]!=0) {
                            min = [model minEMA];
                        }
                    }
                }break;
                case Y_StockChartType_BOLL:{
                    if ([model maxBOLL] > max) {
                        max = [model maxBOLL];
                    }
                    if ([model minBOLL] < min) {
                        if ([model minBOLL]!=0) {
                            min = [model minBOLL];
                        }
                    }
                }break;
                default:
                    break;
            }
        }
    }];
    
    if (self.getedRightPricesBlock) {
        self.getedRightPricesBlock([KlineHelper StrFromDouble:max scale:2],
                                   [KlineHelper StrFromDouble:(max+min)/2 scale:2],
                                   [KlineHelper StrFromDouble:min scale:2]);
    }
    
    CGFloat minY = YT_Kline_Candle_MinY;
    CGFloat maxY = self.drawCandleView.frame.size.height - YT_Kline_Candle_TopY;
    double unit = (max-min)/(maxY-minY);
    if (unit == 0) {
        unit = 1;
    }
    
    
    _arrCandlePoints = @[].mutableCopy;
    
    _arrOneMinute = @[].mutableCopy;
    
    _arrMA1 = @[].mutableCopy;
    _arrMA2 = @[].mutableCopy;
    _arrMA3 = @[].mutableCopy;
    
    _arrEMA1 = @[].mutableCopy;
    _arrEMA2 = @[].mutableCopy;
    _arrEMA3 = @[].mutableCopy;
    
    _arrUP = @[].mutableCopy;
    _arrMB = @[].mutableCopy;
    _arrDN = @[].mutableCopy;
    
    self.MaxMinRect = CGRectMake(maxY, minY, max, min);
    
    NSInteger startIndex = [_arrNeedDrawModels.firstObject index];
    
    if (_isOneMinuteModel) {
        for (int i = 0; i < _arrNeedDrawModels.count; i++) {
            YTKlineModel *model = _arrNeedDrawModels[i];
            CGFloat X = (startIndex + i) * (_KlineCandleWid + _KlineCandleSpacing) + _KlineCandleWid/2;
            CGFloat Y = ABS(maxY-(model.close.doubleValue-min)/unit);
            
            CGPoint point = CGPointMake(X, Y);
            
            KlinePointModel *pointModel = [KlinePointModel new];
            pointModel.point = point;
            pointModel.index = model.index;
            [_arrOneMinute addObject:pointModel];
            
        }
    }else{
        for (int i = 0; i < _arrNeedDrawModels.count; i++) {
            YTKlineModel *model = _arrNeedDrawModels[i];
            
            CGFloat X = (startIndex + i) * (_KlineCandleWid + _KlineCandleSpacing) + _KlineCandleWid/2;
            
            {//蜡烛
                CGFloat high = ABS(maxY-(model.high.doubleValue-min)/unit);
                CGFloat low = ABS(maxY-(model.low.doubleValue-min)/unit);
                CGFloat open = ABS(maxY-(model.open.doubleValue-min)/unit);
                CGFloat close = ABS(maxY-(model.close.doubleValue-min)/unit);
                
                KlinePointModel *pointModel = [KlinePointModel initWit_high:high open:open low:low close:close x:X];
                pointModel.index = model.index;
                [_arrCandlePoints addObject:pointModel];
                
                if ([model isEqual:maxPriceModel]) {
                    self.maxPoint = CGPointMake(X, high);
                    self.strMaxPrice = model.high;
                }
                if ([model isEqual:minPriceModel]) {
                    self.minPoint = CGPointMake(X, low);
                    self.strMinPrice = model.low;
                }
            }
            
            
            
            
            switch (_y_stockChartType) {
                case Y_StockChartType_None:{
                    
                }break;
                case Y_StockChartType_MA:{

                    {
                        CGFloat y = ABS(maxY-(model.MA1-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        if (model.index >= KlineHelper.shared.kLineIndicator.MA_1) {
                            [_arrMA1 addObject:NSStringFromCGPoint(point)];
                        }
                    }
                    {
                        CGFloat y = ABS(maxY-(model.MA2-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        if (model.index >= KlineHelper.shared.kLineIndicator.MA_2) {
                            [_arrMA2 addObject:NSStringFromCGPoint(point)];
                        }
                        
                    }
                    {
                        CGFloat y = ABS(maxY-(model.MA3-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        if (model.index >= KlineHelper.shared.kLineIndicator.MA_3) {
                            [_arrMA3 addObject:NSStringFromCGPoint(point)];
                        }
                        
                    }
                }break;
                case Y_StockChartType_EMA:{
                    {
                        CGFloat y = ABS(maxY-(model.EMA1-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        [_arrEMA1 addObject:NSStringFromCGPoint(point)];
                    }
                    {
                        CGFloat y = ABS(maxY-(model.EMA2-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        [_arrEMA2 addObject:NSStringFromCGPoint(point)];
                    }
                    {
                        CGFloat y = ABS(maxY-(model.EMA3-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        [_arrEMA3 addObject:NSStringFromCGPoint(point)];
                    }
                }break;
                case Y_StockChartType_BOLL:{
                    {
                        CGFloat y = ABS(maxY-(model.BOLL_UP-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        if (model.index > KlineHelper.shared.kLineIndicator.BOLL_Cycle) {
                            [_arrUP addObject:NSStringFromCGPoint(point)];
                        }
                        
                        
                    }
                    {
                        CGFloat y = ABS(maxY-(model.BOLL_MB-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        if (model.index > KlineHelper.shared.kLineIndicator.BOLL_Cycle) {
                            [_arrMB addObject:NSStringFromCGPoint(point)];
                        }
                        
                    }
                    {
                        CGFloat y = ABS(maxY-(model.BOLL_DN-min)/unit);
                        CGPoint point = CGPointMake(X, y);
                        if (model.index > KlineHelper.shared.kLineIndicator.BOLL_Cycle) {
                            [_arrDN addObject:NSStringFromCGPoint(point)];
                        }
                        
                        
                    }
                }break;
                    
                default:
                    break;
            }
            
        }
    }
    
    
    
}
#pragma mark BtnEvent

#pragma mark NetWorking

#pragma mark ------------------分割线----------------

#pragma mark Setters & Getters
-(void)reDraw{
    [self modesToPoints];
    [self drawAllLinesAndCandle];
}

- (void)setArrNeedDrawModels:(NSMutableArray *)arrNeedDrawModels{
    _arrNeedDrawModels = arrNeedDrawModels;
    [self reDraw];
}



#pragma mark LazyLoad

#pragma mark SetUp & Init


@end
