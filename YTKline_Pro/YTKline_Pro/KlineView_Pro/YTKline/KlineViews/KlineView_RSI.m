//
//  KlineView_RSI.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import "KlineView_RSI.h"
#import "YTKlineHeader.h"

@interface KlineView_RSI()



@property (nonatomic,retain) NSMutableArray *arrPointRSI_1;
@property (nonatomic,retain) NSMutableArray *arrPointRSI_2;
@property (nonatomic,retain) NSMutableArray *arrPointRSI_3;
@end
@implementation KlineView_RSI

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
    __block double max = 0;
    __block double min = MAXFLOAT;
    [_arrNeedDrawModels enumerateObjectsUsingBlock:^(YTKlineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([model maxRSI]>max) {
            max = [model maxRSI];
        }
        if ([model minRSI]<min) {
            min = [model minRSI];
        }
        
    }];
//    max *= 1.01;
//    min *=
    
    CGFloat minY = 20;
    CGFloat maxY = self.frame.size.height-5;
    
    if (self.getedRightPricesBlock) {
        self.getedRightPricesBlock([NSString stringWithFormat:@"%.2f",max],
                              [NSString stringWithFormat:@"%.2f",(max+min)/2],
                              [NSString stringWithFormat:@"%.2f",min]);
    }
    
    
    double unit = (max-min)/(maxY-minY);
    if (unit == 0) {
        unit = 1;
    }
    _arrPointRSI_1 = @[].mutableCopy;
    _arrPointRSI_2 = @[].mutableCopy;
    _arrPointRSI_3 = @[].mutableCopy;
    
    NSInteger startIndex = [_arrNeedDrawModels.firstObject index];
    for (int i = 0; i<_arrNeedDrawModels.count; i++) {
        YTKlineModel *model = _arrNeedDrawModels[i];
        CGFloat X = (startIndex + i) * (_KlineCandleWid + _KlineCandleSpacing) + _KlineCandleWid/2;
        

        {
            CGFloat y = ABS(maxY-(model.RSI_1-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index >= KlineHelper.shared.kLineIndicator.RSI_1) {
                [_arrPointRSI_1 addObject:NSStringFromCGPoint(point)];
            }
            
        }
        {
            CGFloat y = ABS(maxY-(model.RSI_2-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index >= KlineHelper.shared.kLineIndicator.RSI_2) {
                [_arrPointRSI_2 addObject:NSStringFromCGPoint(point)];
            }
            
        }
        {
            CGFloat y = ABS(maxY-(model.RSI_3-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index >= KlineHelper.shared.kLineIndicator.RSI_3) {
                [_arrPointRSI_3 addObject:NSStringFromCGPoint(point)];
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
    KLineIndicatorModel *kIndicatorModel =  KlineHelper.shared.kLineIndicator;
    
    if (kIndicatorModel.selectRSI_1) {
        {
            CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrPointRSI_1 lineColor:[KlineHelper RSIColor_1]];
            [self.layer addSublayer:layer1];
        }
    }
    
    if (kIndicatorModel.selectRSI_2) {
        CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrPointRSI_2 lineColor:[KlineHelper RSIColor_2]];
        [self.layer addSublayer:layer1];
    }
    if (kIndicatorModel.selectRSI_3) {
        CAShapeLayer *layer2 = [CAShapeLayer createSingleLineLayer:_arrPointRSI_3 lineColor:[KlineHelper RSIColor_3]];
        [self.layer addSublayer:layer2];
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
