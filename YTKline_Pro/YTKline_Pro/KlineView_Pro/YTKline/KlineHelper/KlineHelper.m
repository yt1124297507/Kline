//
//  KlineHelper.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/12.
//
#import "YYModel.h"
#import "KlineHelper.h"


#define KlineIndicatorsKey @"KlineIndicatorsKey"
#define KlineSharedMd KlineHelper.shared.kLineIndicator
@implementation KlineHelper
static KlineHelper *_singleInstance = nil;
+(instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleInstance == nil) {
            _singleInstance = [[self alloc]init];
            [_singleInstance reloadData];
        }
    });
    return _singleInstance;
}

-(void)reloadData{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KlineIndicatorsKey]) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:KlineIndicatorsKey];
        KLineIndicatorModel *model = [KLineIndicatorModel yy_modelWithDictionary:dic];
        self.kLineIndicator = model;
    }else{
        KLineIndicatorModel *model = [KLineIndicatorModel yy_modelWithDictionary:[self defaultIndicatorsData]];;
        self.kLineIndicator = model;
        [self saveToLocal];
    }
}

-(void)saveToLocal{
    NSDictionary *dic = [self.kLineIndicator yy_modelToJSONObject];
    if (dic.count) {
        [[NSUserDefaults standardUserDefaults] setValue:dic forKey:KlineIndicatorsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(NSDictionary *)defaultIndicatorsData{
    return @{
        @"MA_1":@"5",
        @"MA_2":@"10",
        @"MA_3":@"30",
        
        @"selectMA_1" : @"1",
        @"selectMA_2" : @"1",
        @"selectMA_3" : @"1",
        
        @"EMA_1":@"5",
        @"EMA_2":@"10",
        @"EMA_3":@"30",
        
        @"selectEMA_1" : @"1",
        @"selectEMA_2" : @"1",
        @"selectEMA_3" : @"1",
        
        @"BOLL_Cycle":@"20",
        @"BOLL_Wid":@"2",
        
        @"VOL_MA1":@"5",
        @"VOL_MA2":@"10",
        
        @"MACD_Short":@"12",
        @"MACD_Long":@"26",
        @"MACD_Move":@"9",
        
        @"KDJ_Cycle":@"9",
        @"KDJ_M1":@"3",
        @"KDJ_M2":@"3",
        
        @"RSI_1":@"6",
        @"RSI_2":@"14",
        @"RSI_3":@"24",
        
        @"selectRSI_1" : @"1",
        @"selectRSI_2" : @"1",
        @"selectRSI_3" : @"1",
        
        @"WR_1":@"14",
        @"WR_2":@"28",
        
        @"selectWR_1" : @"1",
        @"selectWR_2" : @"1",  
    };
}

+(UIColor *)UpColor{
    return UIColor.greenColor;
}

+(UIColor *)DownColor{
    return UIColor.redColor;
}

+(CGFloat)heigtOfCandle{
    return 235;
}
+(CGFloat)heigtOfVol{
    return 58;
}
+(CGFloat)heigtOfIndicators{
    return 85;
}
+(NSString *)StrFromDouble:(double)value scale:(NSInteger)scale{
    NSString *str = [NSString stringWithFormat:@"%.2f",value];
    return str;
//    return [HighPrecisionCoculate CutAfterDecimalPoint:str Lenth:scale isZeroEnding:YES];
}

/*
 文字颜色 字体
 */
+(UIColor *)RightTxtColor{
    return UIColor.grayColor;;
}
+(UIColor *)HilightColor{
    return UIColor.redColor;;
}
+(UIFont *)RightTxtFont{
    return [UIFont systemFontOfSize:10];
}
+(UIFont *)TopTxtFont{
    return [UIFont systemFontOfSize:10];
}

+(UIColor *)indicatorNameColor{
    return [KlineHelper RightTxtColor];
}
+(UIColor *)backgroundColor{
    return UIColor.whiteColor;;
}
+(UIColor *)color_1{
    return UIColor.brownColor;;;
}
+(UIColor *)color_2{
    return UIColor.orangeColor;;;
}
+(UIColor *)color_3{
    return UIColor.greenColor;
}

/*
 线条颜色
 */
+(UIColor *)MAColor_1{
    return [KlineHelper color_1];
}
+(UIColor *)MAColor_2{
    return [KlineHelper color_2];
}
+(UIColor *)MAColor_3{
    return [KlineHelper color_3];
}

+(UIColor *)EMAColor_1{
    return [KlineHelper color_1];
}
+(UIColor *)EMAColor_2{
    return [KlineHelper color_2];
}
+(UIColor *)EMAColor_3{
    return [KlineHelper color_3];
}

+(UIColor *)BOLLColor_1{
    return [KlineHelper color_1];
}
+(UIColor *)BOLLColor_2{
    return [KlineHelper color_2];
}
+(UIColor *)BOLLColor_3{
    return [KlineHelper color_3];
}

+(UIColor *)VOLColor_1{
    return [KlineHelper indicatorNameColor];
}
+(UIColor *)VOLColor_2{
    return [KlineHelper color_1];
}
+(UIColor *)VOLColor_3{
    return [KlineHelper color_2];
}

+(UIColor *)MACDColor_1{
    return [KlineHelper indicatorNameColor];
}
+(UIColor *)MACDColor_2{
    return [KlineHelper color_1];
}
+(UIColor *)MACDColor_3{
    return [KlineHelper color_2];
}
+(UIColor *)MACDColor_4{
    return [KlineHelper color_3];
}

+(UIColor *)KDJColor_1{
    return [KlineHelper indicatorNameColor];
}
+(UIColor *)KDJColor_2{
    return [KlineHelper color_1];
}
+(UIColor *)KDJColor_3{
    return [KlineHelper color_2];
}
+(UIColor *)KDJColor_4{
    return [KlineHelper color_3];
}

+(UIColor *)RSIColor_1{
    return [KlineHelper color_1];
}
+(UIColor *)RSIColor_2{
    return [KlineHelper color_2];
}
+(UIColor *)RSIColor_3{
    return [KlineHelper color_3];
}

+(UIColor *)WRColor_1{
    return [KlineHelper color_1];
}
+(UIColor *)WRColor_2{
    return [KlineHelper color_2];
}

+(CGFloat)getTxtWid:(NSString *)string font:(UIFont *)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 30)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.width + 1;
}

+(NSString *)timeStampToString:(NSString *)stamp formatter:(NSString *)fmt{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[stamp integerValue]];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:fmt];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

-(NSString *)MA_Name_1{
    return [NSString stringWithFormat:@"MA(%ld)",KlineSharedMd.MA_1];
}
-(NSString *)MA_Name_2{
    return [NSString stringWithFormat:@"MA(%ld)",KlineSharedMd.MA_2];
}
-(NSString *)MA_Name_3{
    return [NSString stringWithFormat:@"MA(%ld)",KlineSharedMd.MA_3];
}

-(NSString *)EMA_Name_1{
    return [NSString stringWithFormat:@"EMA(%ld)",KlineSharedMd.EMA_1];
}
-(NSString *)EMA_Name_2{
    return [NSString stringWithFormat:@"EMA(%ld)",KlineSharedMd.EMA_2];
}
-(NSString *)EMA_Name_3{
    return [NSString stringWithFormat:@"EMA(%ld)",KlineSharedMd.EMA_3];
}
-(NSString *)MACD_Name{
    return [NSString stringWithFormat:@"MACD(%ld,%ld,%ld)",KlineSharedMd.MACD_Short,KlineSharedMd.MACD_Long,KlineSharedMd.MACD_Move];
}

-(NSString *)VOL_MA_Name_1{
    return [NSString stringWithFormat:@"%ld",KlineSharedMd.VOL_MA1];
}
-(NSString *)VOL_MA_Name_2{
    return [NSString stringWithFormat:@"%ld",KlineSharedMd.VOL_MA2];
}
-(NSString *)RSI_Name_1{
    return [NSString stringWithFormat:@"RSI(%ld)",KlineSharedMd.RSI_1];
}
-(NSString *)RSI_Name_2{
    return [NSString stringWithFormat:@"RSI(%ld)",KlineSharedMd.RSI_2];
}
-(NSString *)RSI_Name_3{
    return [NSString stringWithFormat:@"RSI(%ld)",KlineSharedMd.RSI_3];
}
-(NSString *)WR_Name_1{
    return [NSString stringWithFormat:@"WR(%ld)",KlineSharedMd.WR_1];
}
-(NSString *)WR_Name_2{
    return [NSString stringWithFormat:@"WR(%ld)",KlineSharedMd.WR_2];
}




@end


@implementation KLineIndicatorModel

@end
