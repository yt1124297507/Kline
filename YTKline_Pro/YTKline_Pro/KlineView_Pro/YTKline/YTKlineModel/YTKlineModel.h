//
//  YTKlineModel.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YTKlineModel : NSObject

@property (nonatomic,assign) NSInteger index;//在数组中的位置

@property (nonatomic,strong) NSString *high;
@property (nonatomic,strong) NSString *open;
@property (nonatomic,strong) NSString *low;
@property (nonatomic,strong) NSString *close;



@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *vol;


@property (nonatomic,assign) double SumOfClose;//close的总量
@property (nonatomic,assign) double SumOfAmount;//amount的总量

//     MA :移动平均线 (N =5 10 30)
//    //MA（N）=（C1+C2+……CN）/N
@property (nonatomic,assign) double MA1;
@property (nonatomic,assign) double MA2;
@property (nonatomic,assign) double MA3;

//      EMA :加权移动平均线  (5 10 30)
//     EMA(N) = 2/(N+1)*C + (N-1)/(N+1)*EMA'
//    EMA(n) = @((2 * C + (n-1) * EMA')/(n+1))
@property (nonatomic,assign) double EMA1;
@property (nonatomic,assign) double EMA2;
@property (nonatomic,assign) double EMA3;

//    BOLL:布林线  *k一般为2(带宽)   计算周期N
//    中轨线(MB) = MA(N)
//    上轨线(UP) = MB + k * (MD)
//    下轨线(DN) =  MB - k * (MD)
//    中间计算值(MV) =  (C-MA(N)) * (C-MA(N))
//    标准差(MD) =   sqrt (MV,N-1)/N     *N-1天的 MV之和
@property (nonatomic,assign) double BOLL_MB;//
@property (nonatomic,assign) double BOLL_UP;//
@property (nonatomic,assign) double BOLL_DN;//
@property (nonatomic,assign) double BOLL_MV;
@property (nonatomic,assign) double BOLL_MV_SUM;
@property (nonatomic,assign) double BOLL_MD;

@property (nonatomic,assign) double VOL_MA1;
@property (nonatomic,assign) double VOL_MA2;

//MACD:指数平滑移动均线
//    MACD = (DIF-DEA）*2。
//    DIF = EMA（12） - EMA（26）
//    DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
@property (nonatomic,assign) double MACD;
@property (nonatomic,assign) double MACD_DIF;
@property (nonatomic,assign) double MACD_DEA;
@property (nonatomic,assign) double MACD_EMA1;
@property (nonatomic,assign) double MACD_EMA2;

//KDJ:随机指标
//    未成熟随机值RSV（Raw Stochastic Value）:     * N一般为9
//        LLV(LOW,N)     :  N日内最小close值
//        HHV(HIGH,N)    ：N日内最大close值
//        RSV: = (CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N)) * 100;
//    KDJ_K(N) =  (RSV + 2* KDJ_K(n-1))/3
//        *KDJ_K = SMA    SMA = (RSV+SMA’*(N-M))/N)     N 通常为3  M通常为1
//                        SMA()
//    KDJ_D(N) =  (KDJ_K + 2* KDJ_D(n-1))/3
//    KDJ_J(N) =  KDJ_K*3 - 2* KDJ_D

@property (nonatomic,assign) double KDJ_RSV;
@property (nonatomic,assign) double KDJ_K;
@property (nonatomic,assign) double KDJ_D;
@property (nonatomic,assign) double KDJ_J;

//RSI:相对强弱指标
//    Average gain =  abs Sum(close-open`,n)/n  当前close-上一个的open
//    Average loss =  abs  Sum(close-open`,n)/n
//    double RS       = Average gain/Average loss;
//    double RSI      = (100-(100/(1+RS)));
@property (nonatomic,assign) double RSI_1;
@property (nonatomic,assign) double RSI_In_1;
@property (nonatomic,assign) double RSI_ALL_1;

@property (nonatomic,assign) double RSI_2;
@property (nonatomic,assign) double RSI_In_2;
@property (nonatomic,assign) double RSI_ALL_2;

@property (nonatomic,assign) double RSI_3;
@property (nonatomic,assign) double RSI_In_3;
@property (nonatomic,assign) double RSI_ALL_3;

//WR(N) = (MAX(Close,n)-CLose)/(MAX(Close,n)-Min(Close，n));
@property (nonatomic,assign) double WR_1;
@property (nonatomic,assign) double WR_2;

-(double)maxMA;
-(double)minMA;

-(double)maxEMA;
-(double)minEMA;

-(double)maxBOLL;
-(double)minBOLL;

-(double)maxMACD;
-(double)minMACD;

-(double)maxKDJ;
-(double)minKDJ;

-(double)maxRSI;
-(double)minRSI;

-(double)maxWR;
-(double)minWR;


/// model计算指标数据
/// @param arr arr description
/// @param isSocket isSocket description
+(NSMutableArray *)colculateIndicators:(NSMutableArray <YTKlineModel *>*)arr isSokcet:(BOOL)isSocket;


@end


@interface KlinePointModel : NSObject

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) CGFloat high;
@property (nonatomic,assign) CGFloat open;
@property (nonatomic,assign) CGFloat low;
@property (nonatomic,assign) CGFloat close;
@property (nonatomic,assign) CGFloat x;

@property (nonatomic,assign) CGPoint point;

+(instancetype)initWit_high:(CGFloat)high
                       open:(CGFloat)open
                        low:(CGFloat)low
                      close:(CGFloat)close
                      x:(CGFloat)x;

@end

@interface KlineMacdCandleModel : NSObject
@property (nonatomic,assign) CGPoint point;
@property (nonatomic,assign) CGPoint zeroPoint;
@property (nonatomic,retain) YTKlineModel *model;


+(instancetype)iniwtWithModel:(YTKlineModel *)model point:(CGPoint)point zeroPoint:(CGPoint)zeroPoint;

@end

NS_ASSUME_NONNULL_END
