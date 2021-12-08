//
//  KlineHelper.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface KLineIndicatorModel : NSObject

@property (nonatomic,assign) NSInteger MA_1;
@property (nonatomic,assign) NSInteger MA_2;
@property (nonatomic,assign) NSInteger MA_3;

@property (nonatomic,assign) BOOL selectMA_1;
@property (nonatomic,assign) BOOL selectMA_2;
@property (nonatomic,assign) BOOL selectMA_3;

@property (nonatomic,assign) NSInteger EMA_1;
@property (nonatomic,assign) NSInteger EMA_2;
@property (nonatomic,assign) NSInteger EMA_3;

@property (nonatomic,assign) BOOL selectEMA_1;
@property (nonatomic,assign) BOOL selectEMA_2;
@property (nonatomic,assign) BOOL selectEMA_3;

@property (nonatomic,assign) NSInteger BOLL_Cycle;//周期
@property (nonatomic,assign) NSInteger BOLL_Wid;//带宽

@property (nonatomic,assign) NSInteger VOL_MA1;
@property (nonatomic,assign) NSInteger VOL_MA2;

@property (nonatomic,assign) NSInteger MACD_Short;
@property (nonatomic,assign) NSInteger MACD_Long;
@property (nonatomic,assign) NSInteger MACD_Move;

@property (nonatomic,assign) NSInteger KDJ_Cycle;
@property (nonatomic,assign) NSInteger KDJ_M1;
@property (nonatomic,assign) NSInteger KDJ_M2;

@property (nonatomic,assign) NSInteger RSI_1;
@property (nonatomic,assign) NSInteger RSI_2;
@property (nonatomic,assign) NSInteger RSI_3;

@property (nonatomic,assign) BOOL selectRSI_1;
@property (nonatomic,assign) BOOL selectRSI_2;
@property (nonatomic,assign) BOOL selectRSI_3;

@property (nonatomic,assign) NSInteger WR_1;
@property (nonatomic,assign) NSInteger WR_2;

@property (nonatomic,assign) BOOL selectWR_1;
@property (nonatomic,assign) BOOL selectWR_2;


@end


/// 协助处理K线数据中的一些计算 存储
@interface KlineHelper : NSObject

@property (nonatomic,retain) KLineIndicatorModel *kLineIndicator;

+(instancetype)shared;

+(UIColor *)UpColor;
+(UIColor *)DownColor;

+(CGFloat)heigtOfCandle;
+(CGFloat)heigtOfVol;
+(CGFloat)heigtOfIndicators;

+(NSString *)StrFromDouble:(double)value scale:(NSInteger)scale;

/*
 文字颜色 字体
 */
+(UIColor *)RightTxtColor;
+(UIColor *)HilightColor;
+(UIFont *)RightTxtFont;
+(UIFont *)TopTxtFont;

+(UIColor *)indicatorNameColor;
+(UIColor *)backgroundColor;
/*
 线条颜色 便于用户自定义颜色
 */
+(UIColor *)MAColor_1;
+(UIColor *)MAColor_2;
+(UIColor *)MAColor_3;

+(UIColor *)EMAColor_1;
+(UIColor *)EMAColor_2;
+(UIColor *)EMAColor_3;

+(UIColor *)BOLLColor_1;
+(UIColor *)BOLLColor_2;
+(UIColor *)BOLLColor_3;

+(UIColor *)VOLColor_1;
+(UIColor *)VOLColor_2;
+(UIColor *)VOLColor_3;

+(UIColor *)MACDColor_1;
+(UIColor *)MACDColor_2;
+(UIColor *)MACDColor_3;
+(UIColor *)MACDColor_4;

+(UIColor *)KDJColor_1;
+(UIColor *)KDJColor_2;
+(UIColor *)KDJColor_3;
+(UIColor *)KDJColor_4;

+(UIColor *)RSIColor_1;
+(UIColor *)RSIColor_2;
+(UIColor *)RSIColor_3;

+(UIColor *)WRColor_1;
+(UIColor *)WRColor_2;


-(NSString *)MA_Name_1;
-(NSString *)MA_Name_2;
-(NSString *)MA_Name_3;

-(NSString *)EMA_Name_1;
-(NSString *)EMA_Name_2;
-(NSString *)EMA_Name_3;

-(NSString *)MACD_Name;

-(NSString *)VOL_MA_Name_1;
-(NSString *)VOL_MA_Name_2;
-(NSString *)RSI_Name_1;
-(NSString *)RSI_Name_2;
-(NSString *)RSI_Name_3;
-(NSString *)WR_Name_1;
-(NSString *)WR_Name_2;

-(void)saveToLocal;

/// 获取字符串大致宽度
/// @param string string description
/// @param font font description
+(CGFloat)getTxtWid:(NSString *)string font:(UIFont *)font;


/// 时间戳转字符串
/// @param stamp stamp description
/// @param fmt fmt  yyyy-MM-dd HH:mm:ss   MM-dd HH:mm
+(NSString *)timeStampToString:(NSString *)stamp formatter:(NSString *)fmt;

@end

NS_ASSUME_NONNULL_END
