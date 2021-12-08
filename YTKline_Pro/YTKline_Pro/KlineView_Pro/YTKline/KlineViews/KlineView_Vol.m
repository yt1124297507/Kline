//
//  KlineView_Vol.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import "KlineView_Vol.h"
#import "YTKlineModel.h"

@interface KlineView_Vol()

@property (nonatomic,retain) NSMutableArray *arrPointVols;
@property (nonatomic,retain) NSMutableArray *arrPointMA_5;
@property (nonatomic,retain) NSMutableArray *arrPointMA_10;

@end


@implementation KlineView_Vol

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
-(void)modesToPoints{
    if (!_arrNeedDrawModels.count) {
        return;;
    }
    __block double max = 0;
    double min = 0;
    [_arrNeedDrawModels enumerateObjectsUsingBlock:^(YTKlineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.amount.doubleValue > max) {
            max = model.amount.doubleValue;
        }
        if (model.VOL_MA1>max) {
            max = model.VOL_MA1;
        }
        if (model.VOL_MA2>max) {
            max = model.VOL_MA2;
        }
        
    }];
//    max *= ;
//    min = 0;
    
    CGFloat minY = 20;
    CGFloat maxY = self.frame.size.height-1;
    
    
    
    
    if (self.getedRightPricesBlock) {
        self.getedRightPricesBlock([KlineHelper StrFromDouble:max scale:2],
                                   [KlineHelper StrFromDouble:(max+min)/2 scale:2],
                                   [KlineHelper StrFromDouble:min scale:2]);
    }
    
    
    double unit = (max-min)/(maxY-minY);
    if (unit == 0) {
        unit = 1;
    }
    _arrPointVols = @[].mutableCopy;
    _arrPointMA_5 = @[].mutableCopy;
    _arrPointMA_10 = @[].mutableCopy;
    
    NSInteger startIndex = [_arrNeedDrawModels.firstObject index];
    for (int i = 0; i<_arrNeedDrawModels.count; i++) {
        YTKlineModel *model = _arrNeedDrawModels[i];
        CGFloat X = (startIndex + i) * (_KlineCandleWid + _KlineCandleSpacing) + _KlineCandleWid/2;
        
        {
            CGFloat y = ABS(maxY-(model.amount.doubleValue-min)/unit);
            CGPoint point = CGPointMake(X, y);
            
            klineVolModel *volModel = [klineVolModel new];
            volModel.point = point;
            volModel.isIncrease = ( model.close.doubleValue >= model.open.doubleValue);
            
            [_arrPointVols addObject:volModel];
        }
        {
            CGFloat y = ABS(maxY-(model.VOL_MA1-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index>=5) {
                [_arrPointMA_5 addObject:NSStringFromCGPoint(point)];
            }
        }
        {
            CGFloat y = ABS(maxY-(model.VOL_MA2-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index>=10) {
                [_arrPointMA_10 addObject:NSStringFromCGPoint(point)];
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
    for (klineVolModel *moel in _arrPointVols) {
        CAShapeLayer *layer = [CAShapeLayer createVolLayer:moel.point width:_KlineCandleWid isIncrease:moel.isIncrease MaxHeight:self.frame.size.height];
        [self.layer addSublayer:layer];
        
    }
    {
        CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrPointMA_5 lineColor:[KlineHelper VOLColor_2]];
        [self.layer addSublayer:layer1];
    }
    {
        CAShapeLayer *layer2 = [CAShapeLayer createSingleLineLayer:_arrPointMA_10 lineColor:[KlineHelper VOLColor_3]];
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

-(void)clearAllLayers{
    for (CALayer *layer in self.layer.sublayers.mutableCopy) {
        [layer removeFromSuperlayer];
    }
}


@end


@implementation klineVolModel


@end
