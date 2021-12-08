//
//  KlineView_KDJ.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import "KlineView_KDJ.h"
#import "YTKlineHeader.h"
@interface KlineView_KDJ()

@property (nonatomic,retain) NSMutableArray *arrPointKDJ_K;
@property (nonatomic,retain) NSMutableArray *arrPointKDJ_D;
@property (nonatomic,retain) NSMutableArray *arrPointKDJ_J;

@end

@implementation KlineView_KDJ

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

        if ([model maxKDJ]>max) {
            max = [model maxKDJ];
        }
        if ([model minKDJ]<min) {
            min = [model minKDJ];
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
    _arrPointKDJ_K = @[].mutableCopy;
    _arrPointKDJ_D = @[].mutableCopy;
    _arrPointKDJ_J = @[].mutableCopy;
    
    NSInteger startIndex = [_arrNeedDrawModels.firstObject index];
    for (int i = 0; i<_arrNeedDrawModels.count; i++) {
        YTKlineModel *model = _arrNeedDrawModels[i];
        CGFloat X = (startIndex + i) * (_KlineCandleWid + _KlineCandleSpacing) + _KlineCandleWid/2;
        

        {
            CGFloat y = ABS(maxY-(model.KDJ_K-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index > KlineHelper.shared.kLineIndicator.KDJ_Cycle) {
                [_arrPointKDJ_K addObject:NSStringFromCGPoint(point)];
            }
            
        }
        {
            CGFloat y = ABS(maxY-(model.KDJ_D-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index > KlineHelper.shared.kLineIndicator.KDJ_Cycle) {
                [_arrPointKDJ_D addObject:NSStringFromCGPoint(point)];
            }
            
        }
        {
            CGFloat y = ABS(maxY-(model.KDJ_J-min)/unit);
            CGPoint point = CGPointMake(X, y);
            if (model.index > KlineHelper.shared.kLineIndicator.KDJ_Cycle) {
                [_arrPointKDJ_J addObject:NSStringFromCGPoint(point)];
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
   
    {
        CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrPointKDJ_K lineColor:[KlineHelper KDJColor_2]];
        [self.layer addSublayer:layer1];
    }
    {
        CAShapeLayer *layer1 = [CAShapeLayer createSingleLineLayer:_arrPointKDJ_D lineColor:[KlineHelper KDJColor_3]];
        [self.layer addSublayer:layer1];
    }
    {
        CAShapeLayer *layer2 = [CAShapeLayer createSingleLineLayer:_arrPointKDJ_J lineColor:[KlineHelper KDJColor_4]];
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
