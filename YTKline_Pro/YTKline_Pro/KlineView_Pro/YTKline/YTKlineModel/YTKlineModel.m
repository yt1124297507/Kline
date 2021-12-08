//
//  YTKlineModel.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//
#import "KlineHelper.h"
#import "YTKlineModel.h"

@implementation YTKlineModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"date" : @"id",
             };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}




+(NSMutableArray *)colculateIndicators:(NSMutableArray <YTKlineModel *>*)arr isSokcet:(BOOL)isSocket{
    
    KLineIndicatorModel *kLineIndicator = [KlineHelper shared].kLineIndicator;
    
    NSInteger firstIndex = 0;
    if (isSocket && arr.count >1 ){
        firstIndex = arr.count - 2;
    }
    for (NSInteger i = firstIndex; i<arr.count; i++) {
        YTKlineModel *model = arr[i];
        YTKlineModel *lastModel;
        if (i>0) {
            lastModel = arr[i-1];
        }
        if (i==0) {//初始化第一个model的部分数据
            model.EMA1 = model.close.doubleValue;
            model.EMA2 = model.close.doubleValue;
            model.EMA3 = model.close.doubleValue;
            
            model.MACD_EMA1 = model.close.doubleValue;
            model.MACD_EMA2 = model.close.doubleValue;
            
            model.RSI_In_1 = 0;
            model.RSI_ALL_1 = 0;
            
            model.RSI_In_2 = 0;
            model.RSI_ALL_2 = 0;
            
            model.RSI_In_3 = 0;
            model.RSI_ALL_3 = 0;
        }
        {//辅助计算
            if (i==0) {
                model.SumOfClose = model.close.doubleValue;
                model.SumOfAmount = model.amount.doubleValue;
            }else{
                model.SumOfClose = lastModel.SumOfClose + model.close.doubleValue;
                model.SumOfAmount = lastModel.SumOfAmount + model.amount.doubleValue;
            }
        }
        
        {
            {//计算M1
                NSInteger MA_Index = kLineIndicator.MA_1;
                if (i>=(MA_Index)) {
                    
                    model.MA1 = (model.SumOfClose - arr[i-(MA_Index)].SumOfClose)/MA_Index;
                }
            }
            {//计算M2
                NSInteger MA_Index = kLineIndicator.MA_2;
                if (i>=(MA_Index)) {
                    
                    model.MA2 = (model.SumOfClose - arr[i-(MA_Index)].SumOfClose)/MA_Index;
                }
            }
            {//计算M3
                NSInteger MA_Index = kLineIndicator.MA_3;
                if (i>=(MA_Index)) {
                    
                    model.MA3 = (model.SumOfClose - arr[i-(MA_Index)].SumOfClose)/MA_Index;
                }
            }
        }
        {
            {//EMA1
                NSInteger EMA_Index = kLineIndicator.EMA_1;
                if (i >= 1) {
                    model.EMA1 = (2 * model.close.doubleValue + (EMA_Index-1) * lastModel.EMA1)/(EMA_Index+1);
                }
            }
            {//EMA2
                NSInteger EMA_Index = kLineIndicator.EMA_2;
                if (i >= 1) {
                    model.EMA2 = (2 * model.close.doubleValue + (EMA_Index-1) * lastModel.EMA2)/(EMA_Index+1);
                }
            }
            {//EMA3
                NSInteger EMA_Index = kLineIndicator.EMA_3;
                if (i >= 1) {
                    model.EMA3 = (2 * model.close.doubleValue + (EMA_Index-1) * lastModel.EMA3)/(EMA_Index+1);
                }
            }
        }
        
        {//计算BOLL
            NSInteger MA_Index = kLineIndicator.BOLL_Cycle;
            NSInteger MA_Wid = kLineIndicator.BOLL_Wid;
            
            if (i >= (MA_Index)) {
                model.BOLL_MB = (model.SumOfClose - arr[i-(MA_Index)].SumOfClose)/MA_Index;
                model.BOLL_MV = (model.close.doubleValue-model.BOLL_MB) * (model.close.doubleValue-model.BOLL_MB);
                model.BOLL_MV_SUM = lastModel.BOLL_MV_SUM + model.BOLL_MV;
                if (i > MA_Index) {
                    model.BOLL_MD = sqrt((model.BOLL_MV_SUM - arr[i-MA_Index+1].BOLL_MV_SUM)/MA_Index);
                    model.BOLL_UP = model.BOLL_MB + MA_Wid * model.BOLL_MD;
                    model.BOLL_DN = model.BOLL_MB - MA_Wid * model.BOLL_MD;
                }

            }
        }
//        {//计算M1
//            NSInteger MA_Index = kLineIndicator.MA_1;
//            if (i>=(MA_Index)) {
//
//                model.MA1 = (model.SumOfClose - arr[i-(MA_Index)].SumOfClose)/MA_Index;
//            }
//        }
        {//VOL_MA_1
            {//计算M1
                NSInteger MA_Index = kLineIndicator.VOL_MA1;
                if (i>=(MA_Index)) {
                    model.VOL_MA1 = (model.SumOfAmount - arr[i-(MA_Index)].SumOfAmount)/MA_Index;
                }
            }
            {//计算M2
                NSInteger MA_Index = kLineIndicator.VOL_MA2;
                if (i>=(MA_Index)) {
                    model.VOL_MA2 = (model.SumOfAmount - arr[i-(MA_Index)].SumOfAmount)/MA_Index;
                }
            }
        }
        
        {//MACD
            NSInteger EMA_Short = kLineIndicator.MACD_Short;
            NSInteger EMA_Long = kLineIndicator.MACD_Long;
            NSInteger Macd_move = kLineIndicator.MACD_Move;
            {
                if (i >= 1) {
                    model.MACD_EMA1 = (2 * model.close.doubleValue + (EMA_Short-1) * lastModel.MACD_EMA1)/(EMA_Short+1);
                }
            }
            {
                if (i >= 1) {
                    model.MACD_EMA2 = (2 * model.close.doubleValue + (EMA_Long-1) * lastModel.MACD_EMA2)/(EMA_Long+1);
                }
            }
            if (i >= 1) {
                model.MACD_DIF = model.MACD_EMA1 - model.MACD_EMA2;
                model.MACD_DEA = (2*model.MACD_DIF + (Macd_move-1)*lastModel.MACD_DEA)/(Macd_move + 1);
                model.MACD = (model.MACD_DIF-model.MACD_DEA) * 2;
            }
        }
        {//KDJ
            NSInteger kdj_Cycle = kLineIndicator.KDJ_Cycle;
            NSInteger M1 = kLineIndicator.KDJ_M1;
            NSInteger M2 = kLineIndicator.KDJ_M2;
            if (i > kdj_Cycle) {
                NSMutableArray *subArr = [arr subarrayWithRange:NSMakeRange(i-(kdj_Cycle-1), kdj_Cycle)].mutableCopy;

                double minValue = MAXFLOAT;
                double maxValue = 0;
                for (YTKlineModel *subModel in subArr) {
                    if (subModel.high.doubleValue>maxValue) {
                        maxValue = subModel.high.doubleValue;
                    }
                    if (subModel.low.doubleValue<minValue) {
                        minValue = subModel.low.doubleValue;
                    }
                }

                if (maxValue-minValue==0) {
                    model.KDJ_RSV = 0;
                }else{
                    model.KDJ_RSV = (model.close.doubleValue-minValue)/(maxValue-minValue)*100;
                }

                model.KDJ_K = [model SMA_C:model.KDJ_RSV N:M1 M:1 sma:lastModel.KDJ_K];
                                //(model.KDJ_RSV + 2 * lastModel.KDJ_K)/3;
                model.KDJ_D = [model SMA_C:model.KDJ_K N:M2 M:1 sma:lastModel.KDJ_D];
                                //(model.KDJ_K + 2 * lastModel.KDJ_D)/3;
                model.KDJ_J = model.KDJ_K * 3 - model.KDJ_D * 2;
            }

        }
        {//RSI
            {
                NSInteger RSI = kLineIndicator.RSI_1;
                if (i > RSI) {
                    double diff = model.close.doubleValue-lastModel.close.doubleValue;
                    
                    double MAXdiff = [model MAX_A:diff B:0 C:0];
                    
                    model.RSI_In_1 = [model SMA_C:MAXdiff N:RSI M:1 sma:lastModel.RSI_In_1];
                    model.RSI_ALL_1 = [model SMA_C:ABS(diff) N:RSI M:1 sma:lastModel.RSI_ALL_1];
                    model.RSI_1 = model.RSI_In_1/model.RSI_ALL_1*100;
                    if (model.RSI_ALL_1==0) {
                        model.RSI_1 = 0;
                    }
                }
            }
            {
                NSInteger RSI = kLineIndicator.RSI_2;
                if (i > RSI) {
                    double diff = model.close.doubleValue-lastModel.close.doubleValue;
                    
                    double MAXdiff = [model MAX_A:diff B:0 C:0];
                    
                    model.RSI_In_2 = [model SMA_C:MAXdiff N:RSI M:1 sma:lastModel.RSI_In_2];
                    model.RSI_ALL_2 = [model SMA_C:ABS(diff) N:RSI M:1 sma:lastModel.RSI_ALL_2];
                    model.RSI_2 = model.RSI_In_2/model.RSI_ALL_2*100;
                    if (model.RSI_ALL_2==0) {
                        model.RSI_2 = 0;
                    }
                }
            }
            {
                NSInteger RSI = kLineIndicator.RSI_3;
                if (i > RSI) {
                    double diff = model.close.doubleValue-lastModel.close.doubleValue;
                    
                    double MAXdiff = [model MAX_A:diff B:0 C:0];
                    
                    model.RSI_In_3 = [model SMA_C:MAXdiff N:RSI M:1 sma:lastModel.RSI_In_3];
                    model.RSI_ALL_3 = [model SMA_C:ABS(diff) N:RSI M:1 sma:lastModel.RSI_ALL_3];
                    model.RSI_3 = model.RSI_In_3/model.RSI_ALL_3*100;
                    if (model.RSI_ALL_3==0) {
                        model.RSI_3 = 0;
                    }
                }
            }
        }
        {//WR1
            NSInteger WR = kLineIndicator.WR_1;
            if (i > WR) {
                double Max = 0;
                double Min = MAXFLOAT;
                NSMutableArray *subArr = [arr subarrayWithRange:NSMakeRange(i-(WR-1), WR)].mutableCopy;
                for (YTKlineModel *subModel in subArr) {
                    if (subModel.high.doubleValue > Max) {
                        Max = subModel.high.doubleValue;
                    }
                    if (subModel.low.doubleValue < Min) {
                        Min = subModel.low.doubleValue;
                    }
                }

                if ((Max-Min)==0) {
                    model.WR_1 = 0;
                }else{
                    model.WR_1 = 100*(Max - model.close.doubleValue)/(Max-Min);
                }

            }
        }
        {//WR2
            NSInteger WR = kLineIndicator.WR_2;
            if (i > WR) {
                double Max = 0;
                double Min = MAXFLOAT;
                NSMutableArray *subArr = [arr subarrayWithRange:NSMakeRange(i-(WR-1), WR)].mutableCopy;
                for (YTKlineModel *subModel in subArr) {
                    if (subModel.high.doubleValue > Max) {
                        Max = subModel.high.doubleValue;
                    }
                    if (subModel.low.doubleValue < Min) {
                        Min = subModel.low.doubleValue;
                    }
                }
                
                if ((Max-Min)==0) {
                    model.WR_2 = 0;
                }else{
                    model.WR_2 = 100*(Max - model.close.doubleValue)/(Max-Min);
                }

            }
        }
        
    }
        
    return arr;
}


/// Description
/// @param c c 被计算值
/// @param n n 指标设置的值
/// @param m m 权重 一般为 1
/// @param sma sma 上一个的值
-(double)SMA_C:(double)c N:(double)n M:(double)m sma:(double)sma{
    return (m * c + (n - m) * sma) / n;
}

-(double)SMA_Num:(double)num n:(double)n sam:(double)sma{
    return (num + (n - 1) * sma) / n;
}


-(double)maxMA{
    return [self MAX_A:_MA1 B:_MA2 C:_MA3];
}

-(double)minMA{
    return [self MIN_A:_MA1 B:_MA2 C:_MA3];
}

-(double)maxEMA{
    return [self MAX_A:_EMA1 B:_EMA2 C:_EMA3];
}

-(double)minEMA{
    return [self MIN_A:_EMA1 B:_EMA2 C:_EMA3];
}

-(double)maxBOLL{
    return [self MAX_A:_BOLL_UP B:_BOLL_MB C:_BOLL_DN];
}

-(double)minBOLL{
    return [self MIN_A:_BOLL_UP B:_BOLL_MB C:_BOLL_DN];
}
-(double)maxMACD{
    return [self MAX_A:_MACD B:_MACD_DEA C:_MACD_DIF];
}
-(double)minMACD{
    return [self MIN_A:_MACD B:_MACD_DEA C:_MACD_DIF];
}
-(double)maxKDJ{
    return [self MAX_A:_KDJ_K B:_KDJ_D C:_KDJ_J];
}
-(double)minKDJ{
    return [self MIN_A:_KDJ_K B:_KDJ_D C:_KDJ_J];
}
//
-(double)maxRSI{
    return [self MAX_A:_RSI_1 B:_RSI_2 C:_RSI_3];
}
-(double)minRSI{
    return [self MIN_A:_RSI_1 B:_RSI_2 C:_RSI_3];
}

-(double)maxWR{
    return [self MAX_A:_WR_1 B:_WR_2 C:_WR_2];
}
-(double)minWR{
    return [self MIN_A:_WR_1 B:_WR_2 C:_WR_2];
}


-(double)MAX_A:(double)A B:(double)B C:(double)C{
    double max = A > B ? A : B;
    return (max > C) ? max : C;
}
-(double)MIN_A:(double)A B:(double)B C:(double)C{
    double min = A < B ? A : B;
    return (min < C) ? min : C;
}



@end



@implementation KlinePointModel

+(instancetype)initWit_high:(CGFloat)high
                       open:(CGFloat)open
                        low:(CGFloat)low
                      close:(CGFloat)close
                      x:(CGFloat)x{
    KlinePointModel *model = [KlinePointModel new];
    model.high = high;
    model.open = open;
    model.low = low;
    model.close = close;
    model.x = x;
    return model;
    
}

@end


@implementation KlineMacdCandleModel
+(instancetype)iniwtWithModel:(YTKlineModel *)model point:(CGPoint)point zeroPoint:(CGPoint)zeroPoint{
    KlineMacdCandleModel *md = [KlineMacdCandleModel new];
    md.model = model;
    md.point = point;
    md.zeroPoint = zeroPoint;
    return md;
}
@end
